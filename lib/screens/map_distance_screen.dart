
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapDistanceScreen extends StatefulWidget {
  final String city;
  final String country;

  const MapDistanceScreen({
    super.key,
    required this.city,
    this.country = '',
  });

  @override
  State<MapDistanceScreen> createState() =>
      _MapDistanceScreenState();
}

class _MapDistanceScreenState extends State<MapDistanceScreen> {
  static const Color purple = Color(0xFF7653D6);
  static const Color background = Color(0xFFF7F5FC);
  static const Color ink = Color(0xFF29233A);

  final MapController _mapController = MapController();

  final TextEditingController _fromController =
      TextEditingController();

  final TextEditingController _toController =
      TextEditingController();

  LatLng? _cityCenter;
  LatLng? _startLocation;
  LatLng? _destination;

  List<LatLng> _routePoints = [];

  double? _distanceKm;
  double? _durationMinutes;

  bool _mapReady = false;
  bool _loadingCity = true;
  bool _gettingLocation = false;
  bool _calculatingRoute = false;
  bool _useGpsAsStart = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCityCenter();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  // ------------------------------------------------
  // 1. LOAD SELECTED CITY
  // ------------------------------------------------

  Future<void> _loadCityCenter() async {
    try {
      final searchQuery = widget.country.trim().isEmpty
          ? widget.city.trim()
          : '${widget.city.trim()}, ${widget.country.trim()}';

      final location = await _geocode(searchQuery);

      if (!mounted) return;

      setState(() {
        _cityCenter = location;
        _loadingCity = false;
        _errorMessage = null;
      });

      if (_mapReady) {
        _mapController.move(location, 12);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loadingCity = false;
        _errorMessage =
            'Unable to load ${widget.city}. Check the city name and internet connection.';
      });
    }
  }

  // ------------------------------------------------
  // 2. SEARCH A PLACE USING PHOTON GEOCODING
  // ------------------------------------------------

  Future<LatLng> _geocode(
    String query, {
    LatLng? bias,
    bool requireCityArea = false,
  }) async {
    final parameters = <String, String>{
      'q': query,
      'limit': '10',
      'lang': 'en',
    };

    if (bias != null) {
      parameters['lat'] = bias.latitude.toString();
      parameters['lon'] = bias.longitude.toString();
      parameters['zoom'] = '12';
      parameters['location_bias_scale'] = '0.2';
    }

    final uri = Uri.https(
      'photon.komoot.io',
      '/api/',
      parameters,
    );

    final response = await http
        .get(uri)
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Place search service is unavailable.');
    }

    final data =
        jsonDecode(response.body) as Map<String, dynamic>;

    final features = data['features'] as List?;

    if (features == null || features.isEmpty) {
      throw Exception('No matching place was found for "$query".');
    }

    LatLng? bestLocation;
    double bestDistance = double.infinity;

    for (final item in features) {
      final feature = item as Map<String, dynamic>;

      final properties =
          feature['properties'] as Map<String, dynamic>? ?? {};

      // Prefer places belonging to the selected country.
      final resultCountry =
          (properties['country'] ?? '').toString().toLowerCase();

      final selectedCountry = widget.country.trim().toLowerCase();

      if (selectedCountry.isNotEmpty &&
          resultCountry.isNotEmpty &&
          !resultCountry.contains(selectedCountry) &&
          !selectedCountry.contains(resultCountry)) {
        continue;
      }

      final geometry =
          feature['geometry'] as Map<String, dynamic>;

      final coordinates = geometry['coordinates'] as List;

      final point = LatLng(
        (coordinates[1] as num).toDouble(),
        (coordinates[0] as num).toDouble(),
      );

      double distance = 0;

      if (bias != null) {
        distance = Geolocator.distanceBetween(
          bias.latitude,
          bias.longitude,
          point.latitude,
          point.longitude,
        );

        // Reject results too far from the selected city.
        if (requireCityArea && distance > 80000) {
          continue;
        }
      }

      if (distance < bestDistance) {
        bestDistance = distance;
        bestLocation = point;
      }
    }

    if (bestLocation == null) {
      throw Exception(
        'Could not find "$query" near ${widget.city}. '
        'Please enter another nearby place.',
      );
    }

    return bestLocation;
  }

  // ------------------------------------------------
  // 3. SEARCH A PLACE INSIDE THE SELECTED CITY
  // ------------------------------------------------

  Future<LatLng> _searchInsideCity(String place) async {
    if (_cityCenter == null) {
      throw Exception('Selected city is not available.');
    }

    final query = widget.country.trim().isEmpty
        ? '$place, ${widget.city}'
        : '$place, ${widget.city}, ${widget.country}';

    return _geocode(
      query,
      bias: _cityCenter,
      requireCityArea: true,
    );
  }

  // ------------------------------------------------
  // 4. GET DEVICE LOCATION WHEN USER REQUESTS IT
  // ------------------------------------------------

  Future<void> _useCurrentLocation() async {
    setState(() {
      _gettingLocation = true;
      _errorMessage = null;
    });

    try {
      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception(
          'Please enable location services on your device.',
        );
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception(
          'Please allow location access in your browser or device settings.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );

      final current = LatLng(
        position.latitude,
        position.longitude,
      );

      if (_cityCenter != null) {
        final distance = Geolocator.distanceBetween(
          current.latitude,
          current.longitude,
          _cityCenter!.latitude,
          _cityCenter!.longitude,
        );

        // Do not allow a route from another country to this city.
        if (distance > 80000) {
          throw Exception(
            'You appear to be outside ${widget.city}. '
            'Enter a starting place inside ${widget.city} instead.',
          );
        }
      }

      if (!mounted) return;

      setState(() {
        _startLocation = current;
        _useGpsAsStart = true;
        _fromController.text = 'My current location';

        _routePoints.clear();
        _distanceKm = null;
        _durationMinutes = null;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              e.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _gettingLocation = false;
        });
      }
    }
  }

  // ------------------------------------------------
  // 5. SHOW ROUTE BETWEEN SELECTED PLACES
  // ------------------------------------------------

  Future<void> _showRoute() async {
    final from = _fromController.text.trim();
    final to = _toController.text.trim();

    if (from.isEmpty || to.isEmpty) {
      _showMessage('Enter both starting place and destination.');
      return;
    }

    if (from.toLowerCase() == to.toLowerCase()) {
      _showMessage('Choose two different places.');
      return;
    }

    setState(() {
      _calculatingRoute = true;
      _errorMessage = null;
      _routePoints.clear();
      _distanceKm = null;
      _durationMinutes = null;
      _destination = null;
    });

    try {
      final LatLng start;

      if (_useGpsAsStart && _startLocation != null) {
        start = _startLocation!;
      } else {
        start = await _searchInsideCity(from);
      }

      final end = await _searchInsideCity(to);

      await _calculateRoute(start, end);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              e.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _calculatingRoute = false;
        });
      }
    }
  }

  // ------------------------------------------------
  // 6. CALCULATE DRIVING ROUTE USING OSRM
  // ------------------------------------------------

  Future<void> _calculateRoute(
    LatLng start,
    LatLng end,
  ) async {
    final url =
        'https://router.project-osrm.org/route/v1/driving/'
        '${start.longitude},${start.latitude};'
        '${end.longitude},${end.latitude}'
        '?overview=full&geometries=geojson';

    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception('Driving route service is unavailable.');
    }

    final data =
        jsonDecode(response.body) as Map<String, dynamic>;

    final routes = data['routes'] as List?;

    if (data['code'] != 'Ok' ||
        routes == null ||
        routes.isEmpty) {
      throw Exception(
        'No road route found between these two places.',
      );
    }

    final route = routes.first as Map<String, dynamic>;

    final geometry =
        route['geometry'] as Map<String, dynamic>;

    final coordinates = geometry['coordinates'] as List;

    final points = coordinates.map<LatLng>((coordinate) {
      return LatLng(
        (coordinate[1] as num).toDouble(),
        (coordinate[0] as num).toDouble(),
      );
    }).toList();

    if (!mounted) return;

    setState(() {
      _startLocation = start;
      _destination = end;
      _routePoints = points;

      _distanceKm =
          (route['distance'] as num).toDouble() / 1000;

      _durationMinutes =
          (route['duration'] as num).toDouble() / 60;
    });

    _moveToRoute();
  }

  // ------------------------------------------------
  // 7. CENTER THE MAP
  // ------------------------------------------------

  void _moveToRoute() {
    if (!_mapReady) return;

    if (_startLocation == null || _destination == null) {
      if (_cityCenter != null) {
        _mapController.move(_cityCenter!, 12);
      }
      return;
    }

    final center = LatLng(
      (_startLocation!.latitude +
              _destination!.latitude) /
          2,
      (_startLocation!.longitude +
              _destination!.longitude) /
          2,
    );

    final double distance = _distanceKm ?? 0;

    final double zoom = distance > 30
        ? 10.5
        : distance > 10
            ? 11.5
            : distance > 3
                ? 12.5
                : 14.0;

    _mapController.move(center, zoom);
  }

  // ------------------------------------------------
  // 8. CLEAR AND RESET
  // ------------------------------------------------

  void _clearRoute() {
    setState(() {
      _fromController.clear();
      _toController.clear();

      _startLocation = null;
      _destination = null;

      _routePoints.clear();

      _distanceKm = null;
      _durationMinutes = null;

      _useGpsAsStart = false;
      _errorMessage = null;
    });

    if (_mapReady && _cityCenter != null) {
      _mapController.move(_cityCenter!, 12);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ------------------------------------------------
  // 9. MAIN SCREEN
  // ------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Map & Distance',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: purple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _loadingCity
          ? const Center(
              child: CircularProgressIndicator(
                color: purple,
              ),
            )
          : _buildContent(),
    );
  }

  // ------------------------------------------------
  // 10. SCREEN CONTENT
  // ------------------------------------------------

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _buildHeader(),

        const SizedBox(height: 20),

        _buildPlacesCard(),

        const SizedBox(height: 22),

        const Text(
          'Your City Map',
          style: TextStyle(
            color: ink,
            fontWeight: FontWeight.w800,
            fontSize: 21,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Select places to display their route.',
          style: TextStyle(
            color: Color(0xFF777184),
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 13),

        _buildMap(),

        const SizedBox(height: 7),

        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            '© OpenStreetMap contributors',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
        ),

        const SizedBox(height: 20),

        _buildDistanceCard(),

        const SizedBox(height: 18),

        _buildInformationCard(),

        const SizedBox(height: 25),
      ],
    );
  }

  // ------------------------------------------------
  // 11. HEADER
  // ------------------------------------------------

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6442C4),
            Color(0xFF9679E9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(alpha: 0.18),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.explore_rounded,
            color: Colors.white,
            size: 43,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EXPLORE YOUR CITY',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  widget.city,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                if (widget.country.isNotEmpty)
                  Text(
                    widget.country,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------
  // 12. START AND DESTINATION INPUT CARD
  // ------------------------------------------------

  Widget _buildPlacesCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFEAE5F3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plan Your Local Journey',
            style: TextStyle(
              color: ink,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Choose two locations in ${widget.city}.',
            style: const TextStyle(
              color: Color(0xFF777184),
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 18),

          _buildInputField(
            controller: _fromController,
            title: 'Starting Place',
            hint: 'Example: Shinjuku Station',
            icon: Icons.my_location_rounded,
            color: purple,
            onChanged: (_) {
              _useGpsAsStart = false;

              setState(() {
                _startLocation = null;
                _routePoints.clear();
                _distanceKm = null;
                _durationMinutes = null;
              });
            },
          ),

          const SizedBox(height: 16),

          _buildInputField(
            controller: _toController,
            title: 'Destination',
            hint: 'Example: Tokyo Tower',
            icon: Icons.location_on_rounded,
            color: const Color(0xFFE49A55),
            onChanged: (_) {
              setState(() {
                _destination = null;
                _routePoints.clear();
                _distanceKm = null;
                _durationMinutes = null;
              });
            },
          ),

          const SizedBox(height: 15),

          OutlinedButton.icon(
            onPressed:
                _gettingLocation ? null : _useCurrentLocation,
            icon: _gettingLocation
                ? const SizedBox(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.gps_fixed_rounded),
            label: const Text('Use My Current Location'),
            style: OutlinedButton.styleFrom(
              foregroundColor: purple,
              minimumSize: const Size(
                double.infinity,
                47,
              ),
              side: const BorderSide(color: purple),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 53,
            child: FilledButton.icon(
              onPressed:
                  _calculatingRoute ? null : _showRoute,
              icon: _calculatingRoute
                  ? const SizedBox(
                      height: 19,
                      width: 19,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.route_rounded),
              label: Text(
                _calculatingRoute
                    ? 'Calculating Route...'
                    : 'Show Route',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          TextButton.icon(
            onPressed: _clearRoute,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Clear and Start Again'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF777184),
            ),
          ),

          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ------------------------------------------------
  // 13. INPUT FIELD DESIGN
  // ------------------------------------------------

  Widget _buildInputField({
    required TextEditingController controller,
    required String title,
    required String hint,
    required IconData icon,
    required Color color,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: ink,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          onChanged: onChanged,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: color,
            ),
            filled: true,
            fillColor: background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------
  // 14. REAL MAP
  // ------------------------------------------------

  Widget _buildMap() {
    final center = _cityCenter ?? const LatLng(20, 0);

    final markers = <Marker>[];

    if (_startLocation != null) {
      markers.add(
        Marker(
          point: _startLocation!,
          width: 90,
          height: 75,
          child: const Column(
            children: [
              Icon(
                Icons.my_location_rounded,
                color: purple,
                size: 34,
              ),
              Text(
                'START',
                style: TextStyle(
                  color: purple,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_destination != null) {
      markers.add(
        Marker(
          point: _destination!,
          width: 110,
          height: 75,
          child: const Column(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: Color(0xFFE49A55),
                size: 36,
              ),
              Text(
                'DESTINATION',
                style: TextStyle(
                  color: ink,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 370,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E9E0),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFEAE5F3),
        ),
      ),
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: center,
          initialZoom: 12,
          onMapReady: () {
            _mapReady = true;

            if (_cityCenter != null) {
              _mapController.move(_cityCenter!, 12);
            }
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.travel_nest',
          ),

          if (_routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: _routePoints,
                  strokeWidth: 5,
                  color: purple,
                ),
              ],
            ),

          MarkerLayer(
            markers: markers,
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------
  // 15. DISTANCE AND TIME DETAILS
  // ------------------------------------------------

  Widget _buildDistanceCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: const Color(0xFFEAE5F3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Route Details',
            style: TextStyle(
              color: ink,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _metric(
                  Icons.route_rounded,
                  'Distance',
                  _distanceKm == null
                      ? '--'
                      : '${_distanceKm!.toStringAsFixed(1)} km',
                ),
              ),

              Expanded(
                child: _metric(
                  Icons.access_time_rounded,
                  'Estimated Time',
                  _durationMinutes == null
                      ? '--'
                      : _formatDuration(_durationMinutes!),
                ),
              ),
            ],
          ),

          if (_routePoints.isEmpty) ...[
            const SizedBox(height: 14),
            const Text(
              'Enter your starting place and destination, '
              'then tap Show Route to calculate your journey.',
              style: TextStyle(
                color: Color(0xFF777184),
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _metric(
    IconData icon,
    String title,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: purple,
          size: 25,
        ),

        const SizedBox(height: 8),

        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 11,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          value,
          style: const TextStyle(
            color: ink,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatDuration(double minutes) {
    final totalMinutes = minutes.round();
    final hours = totalMinutes ~/ 60;
    final remaining = totalMinutes % 60;

    if (hours == 0) {
      return '$remaining min';
    }

    return '$hours hr $remaining min';
  }

  // ------------------------------------------------
  // 16. INFORMATION CARD
  // ------------------------------------------------

  Widget _buildInformationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFECE5FC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: purple,
            size: 23,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Choose two places inside your selected city. '
              'You can also use your GPS location when you '
              'are physically in that city. This prototype '
              'calculates driving routes only. Travel time '
              'is an estimate and does not include live traffic.',
              style: TextStyle(
                color: Color(0xFF625B70),
                fontSize: 11,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
