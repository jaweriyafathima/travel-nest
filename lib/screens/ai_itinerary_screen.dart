
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/ai_itinerary_service.dart';

class AIItineraryScreen extends StatefulWidget {
  final String country;
  final String city;
  final int numberOfDays;
  final String budget;
  final String travelWith;
  final String interests;
  final String foodPreference;
  final String travelStyle;

  const AIItineraryScreen({
    super.key,
    required this.country,
    required this.city,
    required this.numberOfDays,
    required this.budget,
    required this.travelWith,
    required this.interests,
    required this.foodPreference,
    required this.travelStyle,
  });

  @override
  State<AIItineraryScreen> createState() => _AIItineraryScreenState();
}

class _AIItineraryScreenState extends State<AIItineraryScreen> {
  static const Color purple = Color(0xFF7355A5);
  static const Color background = Color(0xFFF8F5FC);

  bool isLoading = true;
  String? errorMessage;
  String itineraryText = '';
  List<_DayPlan> days = [];

  bool weatherLoading = true;
  String? weatherError;
  _WeatherInfo? weather;

  @override
  void initState() {
    super.initState();
    _generateItinerary();
    _loadWeather();
  }

  // ---------------------------------------------------------
  // GENERATE ITINERARY USING YOUR EXISTING GEMINI SERVICE
  // ---------------------------------------------------------

  Future<void> _generateItinerary() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await AIItineraryService().generateItinerary(
        country: widget.country,
        city: widget.city,
        numberOfDays: widget.numberOfDays,
        budget: widget.budget,
        travelWith: widget.travelWith,
        interests: widget.interests,
        foodPreference: widget.foodPreference,
        travelStyle: widget.travelStyle,
      );

      if (!mounted) return;

      setState(() {
        itineraryText = result;
        days = _parseItinerary(result);
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString().replaceFirst('Exception: ', '');
        isLoading = false;
      });
    }
  }

  // ---------------------------------------------------------
  // CONVERT GEMINI TEXT INTO DAY AND TIME CARDS
  // ---------------------------------------------------------

  List<_DayPlan> _parseItinerary(String text) {
    final result = <_DayPlan>[];
    _DayPlan? currentDay;
    _TimePlan? currentTime;

    final lines = text.split('\n');

    final dayPattern = RegExp(
      r'\bDay\s+(\d+)\s*[:\-–]?\s*(.*)',
      caseSensitive: false,
    );

    final timePattern = RegExp(
      r'\b(Morning|Afternoon|Evening|Night)\b\s*[:：]?',
      caseSensitive: false,
    );

    for (final originalLine in lines) {
      String line = _cleanText(originalLine);

      if (line.isEmpty || line == '---') continue;

      final dayMatch = dayPattern.firstMatch(line);

      if (dayMatch != null) {
        currentDay = _DayPlan(
          number: int.tryParse(dayMatch.group(1) ?? '') ?? result.length + 1,
          title: _cleanText(dayMatch.group(2) ?? ''),
        );

        result.add(currentDay);
        currentTime = null;
        continue;
      }

      if (currentDay == null) {
        currentDay = _DayPlan(
          number: 1,
          title: 'Your Travel Experience',
        );
        result.add(currentDay);
      }

      final timeMatch = timePattern.firstMatch(line);

      if (timeMatch != null) {
        final timeName = timeMatch.group(1) ?? 'Activity';

        currentTime = _TimePlan(
          title: timeName,
          description: '',
        );

        currentDay.activities.add(currentTime);

        final remaining = line
            .substring(timeMatch.end)
            .replaceFirst(RegExp(r'^[\s:：\-–*]+'), '')
            .trim();

        if (remaining.isNotEmpty) {
          currentTime.description = remaining;
        }
      } else {
        if (currentTime != null) {
          currentTime.description =
              '${currentTime.description} $line'.trim();
        } else {
          currentDay.activities.add(
            _TimePlan(
              title: 'Suggested Activity',
              description: line,
            ),
          );
        }
      }
    }

    return result;
  }

  String _cleanText(String value) {
    return value
        .replaceAll(RegExp(r'^\s*#{1,6}\s*'), '')
        .replaceAll('**', '')
        .replaceAll('__', '')
        .replaceAll('*', '')
        .replaceAll(RegExp(r'^\s*[-•]\s*'), '')
        .trim();
  }

  // ---------------------------------------------------------
  // FETCH CURRENT WEATHER FROM OPEN-METEO
  // ---------------------------------------------------------

  Future<void> _loadWeather() async {
    setState(() {
      weatherLoading = true;
      weatherError = null;
    });

    try {
      final searchUri = Uri.https(
        'geocoding-api.open-meteo.com',
        '/v1/search',
        {
          'name': widget.city,
          'count': '10',
          'language': 'en',
          'format': 'json',
        },
      );

      final searchResponse = await http
          .get(searchUri)
          .timeout(const Duration(seconds: 15));

      if (searchResponse.statusCode != 200) {
        throw Exception('Could not find the city location.');
      }

      final searchData = jsonDecode(searchResponse.body);
      final locations = searchData['results'] as List?;

      if (locations == null || locations.isEmpty) {
        throw Exception('Weather location was not found.');
      }

      // Prefer a matching country when available.
      final matchingLocations = locations.where((location) {
        final locationCountry =
            (location['country'] ?? '').toString().toLowerCase();
        return locationCountry == widget.country.toLowerCase();
      }).toList();

      final selectedLocation = matchingLocations.isNotEmpty
          ? matchingLocations.first
          : locations.first;

      final latitude = selectedLocation['latitude'];
      final longitude = selectedLocation['longitude'];

      final weatherUri = Uri.https(
        'api.open-meteo.com',
        '/v1/forecast',
        {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          'current':
              'temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m',
          'timezone': 'auto',
        },
      );

      final weatherResponse = await http
          .get(weatherUri)
          .timeout(const Duration(seconds: 15));

      if (weatherResponse.statusCode != 200) {
        throw Exception('Could not load current weather.');
      }

      final weatherData = jsonDecode(weatherResponse.body);
      final current = weatherData['current'];

      if (current == null) {
        throw Exception('Current weather information is unavailable.');
      }

      if (!mounted) return;

      setState(() {
        weather = _WeatherInfo(
          temperature: (current['temperature_2m'] as num).toDouble(),
          feelsLike:
              (current['apparent_temperature'] as num).toDouble(),
          humidity: (current['relative_humidity_2m'] as num).toInt(),
          windSpeed: (current['wind_speed_10m'] as num).toDouble(),
          description: _weatherDescription(
            (current['weather_code'] as num).toInt(),
          ),
          icon: _weatherIcon(
            (current['weather_code'] as num).toInt(),
          ),
        );

        weatherLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        weatherError = e.toString().replaceFirst('Exception: ', '');
        weatherLoading = false;
      });
    }
  }

  String _weatherDescription(int code) {
    if (code == 0) return 'Clear sky';
    if (code <= 3) return 'Partly cloudy';
    if (code == 45 || code == 48) return 'Foggy';
    if (code >= 51 && code <= 57) return 'Drizzle';
    if (code >= 61 && code <= 67) return 'Rainy';
    if (code >= 71 && code <= 77) return 'Snow';
    if (code >= 80 && code <= 82) return 'Rain showers';
    if (code >= 85 && code <= 86) return 'Snow showers';
    if (code >= 95) return 'Thunderstorm';
    return 'Variable weather';
  }

  IconData _weatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny_rounded;
    if (code <= 3) return Icons.cloud_rounded;
    if (code == 45 || code == 48) return Icons.foggy;
    if (code >= 51 && code <= 67) return Icons.grain_rounded;
    if (code >= 71 && code <= 86) return Icons.ac_unit_rounded;
    if (code >= 95) return Icons.thunderstorm_rounded;
    return Icons.cloud_queue_rounded;
  }

  // ---------------------------------------------------------
  // MAIN SCREEN
  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: RefreshIndicator(
                color: purple,
                onRefresh: () async {
                  await Future.wait([
                    _generateItinerary(),
                    _loadWeather(),
                  ]);
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
                  children: [
                    _buildWelcomeHeader(),
                    const SizedBox(height: 18),
                    _buildWeatherCard(),
                    const SizedBox(height: 20),
                    _buildTripSummary(),
                    const SizedBox(height: 24),
                    _buildSectionTitle(
                      'Your Day-by-Day Plan',
                      'Personalized for your journey',
                      Icons.calendar_month_rounded,
                    ),
                    const SizedBox(height: 14),
                    _buildItineraryContent(),
                    const SizedBox(height: 20),
                    _buildTravelTip(),
                    const SizedBox(height: 18),
                    _buildPoweredBy(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 18, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: const Color(0xFF392D48),
          ),
          const SizedBox(width: 5),
          const Expanded(
            child: Text(
              'AI Travel Itinerary',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF392D48),
              ),
            ),
          ),
          IconButton(
            onPressed: _generateItinerary,
            tooltip: 'Regenerate itinerary',
            icon: const Icon(Icons.refresh_rounded),
            color: purple,
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF8065B5),
            Color(0xFFB28BCB),
            Color(0xFFE4A6BD),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your next adventure starts here!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.city}, ${widget.country}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${widget.numberOfDays} days of discovery ✨',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.flight_takeoff_rounded,
            color: Colors.white,
            size: 55,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // WEATHER CARD
  // ---------------------------------------------------------

  Widget _buildWeatherCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEDE5F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.wb_cloudy_rounded,
                color: purple,
                size: 22,
              ),
              const SizedBox(width: 9),
              const Expanded(
                child: Text(
                  'Current Weather',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF392D48),
                  ),
                ),
              ),
              Text(
                widget.city,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (weatherLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(color: purple),
              ),
            )
          else if (weather != null)
            _buildWeatherDetails()
          else
            _buildWeatherError(),
          const SizedBox(height: 10),
          const Text(
            'Live weather data • Open-Meteo',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    final info = weather!;

    return Column(
      children: [
        Row(
          children: [
            Icon(
              info.icon,
              size: 54,
              color: const Color(0xFFE9A83D),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${info.temperature.round()}°C',
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF392D48),
                  ),
                ),
                Text(
                  info.description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _weatherMetric(
                Icons.thermostat_rounded,
                'Feels like',
                '${info.feelsLike.round()}°C',
              ),
            ),
            Expanded(
              child: _weatherMetric(
                Icons.water_drop_rounded,
                'Humidity',
                '${info.humidity}%',
              ),
            ),
            Expanded(
              child: _weatherMetric(
                Icons.air_rounded,
                'Wind',
                '${info.windSpeed.round()} km/h',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherMetric(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: purple, size: 21),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFF392D48),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherError() {
    return Column(
      children: [
        const Icon(
          Icons.cloud_off_rounded,
          color: Colors.grey,
          size: 36,
        ),
        const SizedBox(height: 8),
        Text(
          weatherError ?? 'Weather information is unavailable.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        TextButton.icon(
          onPressed: _loadWeather,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Try again'),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // TRIP SUMMARY
  // ---------------------------------------------------------

  Widget _buildTripSummary() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EAF8),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trip Overview',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Color(0xFF392D48),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  Icons.calendar_today_rounded,
                  'Duration',
                  '${widget.numberOfDays} Days',
                ),
              ),
              Expanded(
                child: _summaryItem(
                  Icons.people_alt_rounded,
                  'Travel with',
                  widget.travelWith,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  Icons.account_balance_wallet_rounded,
                  'Budget',
                  widget.budget,
                ),
              ),
              Expanded(
                child: _summaryItem(
                  Icons.explore_rounded,
                  'Travel style',
                  widget.travelStyle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFFDCD1EA)),
          const SizedBox(height: 8),
          const Text(
            'Your interests',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.interests,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF51445F),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Food preference: ${widget.foodPreference}',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF51445F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: purple, size: 21),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF392D48),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // ITINERARY SECTION
  // ---------------------------------------------------------

  Widget _buildSectionTitle(
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFECE3F6),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: purple),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF392D48),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItineraryContent() {
    if (isLoading) {
      return Container(
        padding: const EdgeInsets.all(35),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          children: [
            CircularProgressIndicator(color: purple),
            SizedBox(height: 16),
            Text(
              'Travel Nest AI is planning your trip...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF51445F),
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Please wait while your day-by-day plan is prepared.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 42,
            ),
            const SizedBox(height: 12),
            const Text(
              'Unable to generate your itinerary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: _generateItinerary,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: purple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (days.isEmpty) {
      return const Text('No itinerary details were returned.');
    }

    return Column(
      children: days.map(_buildDayCard).toList(),
    );
  }

  Widget _buildDayCard(_DayPlan day) {
    return Container(
      margin: const EdgeInsets.only(bottom: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: const Color(0xFFECE5F4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 15,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF8065B5),
                  Color(0xFFB18BCB),
                ],
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${day.number}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DAY ${day.number}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        day.title.isEmpty
                            ? 'Your Day ${day.number} Adventure'
                            : day.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.location_on_rounded,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          if (day.activities.isEmpty)
            const Padding(
              padding: EdgeInsets.all(18),
              child: Text('Activities will appear here.'),
            )
          else
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: day.activities
                    .map(_buildActivity)
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActivity(_TimePlan activity) {
    final details = _activityStyle(activity.title);

    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: details.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              details.icon,
              color: details.color,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF392D48),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  activity.description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Color(0xFF6D6475),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _ActivityStyle _activityStyle(String title) {
    switch (title.toLowerCase()) {
      case 'morning':
        return _ActivityStyle(
          Icons.wb_sunny_rounded,
          const Color(0xFFE6A33A),
        );
      case 'afternoon':
        return _ActivityStyle(
          Icons.light_mode_rounded,
          const Color(0xFFED8B45),
        );
      case 'evening':
        return _ActivityStyle(
          Icons.wb_twilight_rounded,
          const Color(0xFFB16AB8),
        );
      case 'night':
        return _ActivityStyle(
          Icons.nightlight_round,
          const Color(0xFF6575B9),
        );
      default:
        return _ActivityStyle(
          Icons.place_rounded,
          purple,
        );
    }
  }

  Widget _buildTravelTip() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_rounded,
            color: Color(0xFFE5A03A),
            size: 25,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Travel Nest Tip',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF72502D),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Check local weather before leaving and confirm attraction opening hours before your visit.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: Color(0xFF80694F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoweredBy() {
    return const Center(
      child: Text(
        'Made with Travel Nest AI ✈',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// DATA CLASSES
// ---------------------------------------------------------

class _DayPlan {
  final int number;
  final String title;
  final List<_TimePlan> activities = [];

  _DayPlan({
    required this.number,
    required this.title,
  });
}

class _TimePlan {
  final String title;
  String description;

  _TimePlan({
    required this.title,
    required this.description,
  });
}

class _WeatherInfo {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final IconData icon;

  _WeatherInfo({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
  });
}

class _ActivityStyle {
  final IconData icon;
  final Color color;

  _ActivityStyle(this.icon, this.color);
}
