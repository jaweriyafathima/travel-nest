
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SmartTravelAssistanceScreen extends StatefulWidget {
  final String city;
  final String country;

  final int? numberOfDays;
  final double? budget;
  final String? travelWith;
  final String? interests;
  final String? foodPreference;
  final String? travelStyle;

  const SmartTravelAssistanceScreen({
    super.key,
    required this.city,
    required this.country,
    this.numberOfDays,
    this.budget,
    this.travelWith,
    this.interests,
    this.foodPreference,
    this.travelStyle,
  });

  @override
  State<SmartTravelAssistanceScreen> createState() =>
      _SmartTravelAssistanceScreenState();
}

class _SmartTravelAssistanceScreenState
    extends State<SmartTravelAssistanceScreen> {
  static const Color purple = Color(0xFF7046C7);
  static const Color background = Color(0xFFF7F5FC);

  final TextEditingController amountController =
      TextEditingController(text: '10');

  bool converting = false;
  bool loadingWeather = false;
  bool loadingEmergency = false;

  double? convertedAmount;
  double? exchangeRate;

  String? currencyError;
  String? rateUpdated;

  Map<String, dynamic>? weatherData;

  List<Map<String, dynamic>> emergencyPlaces = [];

  late String selectedCurrency;
  late String currencySymbol;
  late String currencyName;

  // DESTINATION COUNTRY AND CURRENCY
  List<String> get destinationCurrency {
    final Map<String, List<String>> currencies = {
      'japan': ['JPY', '¥', 'Japanese Yen'],
      'france': ['EUR', '€', 'Euro'],
      'germany': ['EUR', '€', 'Euro'],
      'italy': ['EUR', '€', 'Euro'],
      'spain': ['EUR', '€', 'Euro'],
      'thailand': ['THB', '฿', 'Thai Baht'],
      'usa': ['USD', r'$', 'US Dollar'],
      'united states': ['USD', r'$', 'US Dollar'],
      'uk': ['GBP', '£', 'British Pound'],
      'united kingdom': ['GBP', '£', 'British Pound'],
      'singapore': ['SGD', r'S$', 'Singapore Dollar'],
      'malaysia': ['MYR', 'RM', 'Malaysian Ringgit'],
      'uae': ['AED', 'د.إ', 'UAE Dirham'],
      'united arab emirates': ['AED', 'د.إ', 'UAE Dirham'],
      'canada': ['CAD', r'C$', 'Canadian Dollar'],
      'australia': ['AUD', r'A$', 'Australian Dollar'],
      'switzerland': ['CHF', 'CHF', 'Swiss Franc'],
      'south korea': ['KRW', '₩', 'South Korean Won'],
      'indonesia': ['IDR', 'Rp', 'Indonesian Rupiah'],
      'india': ['INR', '₹', 'Indian Rupee'],
      'china': ['CNY', '¥', 'Chinese Yuan'],
      'nepal': ['NPR', 'Rs', 'Nepalese Rupee'],
      'sri lanka': ['LKR', 'Rs', 'Sri Lankan Rupee'],
      'vietnam': ['VND', '₫', 'Vietnamese Dong'],
    };

    return currencies[widget.country.toLowerCase().trim()] ??
        <String>['USD', r'$', 'US Dollar'];
  }

  @override
  void initState() {
    super.initState();

    final currency = destinationCurrency;

    selectedCurrency = currency[0];
    currencySymbol = currency[1];
    currencyName = currency[2];
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  // 1. CURRENCY CONVERTER
  Future<void> convertCurrency() async {
    final amount = double.tryParse(amountController.text.trim());

    if (amount == null || amount <= 0) {
      setState(() {
        currencyError = 'Enter a valid amount.';
        convertedAmount = null;
      });
      return;
    }

    setState(() {
      converting = true;
      currencyError = null;
    });

    try {
      final url = Uri.parse(
        'https://open.er-api.com/v6/latest/INR',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode != 200) {
        throw Exception('Exchange rate unavailable');
      }

      final data = jsonDecode(response.body);

      if (data['result'] != 'success') {
        throw Exception('Exchange rate unavailable');
      }

      final rates = data['rates'] as Map<String, dynamic>;
      final rate = (rates[selectedCurrency] as num?)?.toDouble();

      if (rate == null) {
        throw Exception('Currency not supported');
      }

      if (!mounted) return;

      setState(() {
        exchangeRate = rate;
        convertedAmount = amount * rate;
        rateUpdated = data['time_last_update_utc']?.toString();
        converting = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        converting = false;
        currencyError =
            'Unable to load the exchange rate. Check your internet and try again.';
      });
    }
  }

  void openCurrencyConverter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: background,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, updateSheet) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                25,
                20,
                MediaQuery.of(context).viewInsets.bottom + 25,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    sectionTitle('Currency Converter'),

                    Text(
                      'India (INR) → ${widget.country} ($selectedCurrency)',
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller: amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Enter Indian Rupees',
                        prefixText: '₹ ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(15),
                        ),
                        onPressed: () async {
                          updateSheet(() {
                            converting = true;
                            currencyError = null;
                          });

                          await convertCurrency();

                          updateSheet(() {});
                        },
                        child: const Text('Convert Money'),
                      ),
                    ),

                    const SizedBox(height: 18),

                    if (converting)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),

                    if (currencyError != null)
                      Text(
                        currencyError!,
                        style: const TextStyle(color: Colors.red),
                      ),

                    if (convertedAmount != null &&
                        exchangeRate != null) ...[
                      infoCard(
                        Column(
                          children: [
                            const Text('Converted Amount'),
                            const SizedBox(height: 8),
                            Text(
                              '$currencySymbol${convertedAmount!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 30,
                                color: purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(currencyName),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      infoCard(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'How is it calculated?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '₹1 = $currencySymbol${exchangeRate!.toStringAsFixed(5)}',
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '₹${amountController.text} × ${exchangeRate!.toStringAsFixed(5)}',
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '= $currencySymbol${convertedAmount!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (rateUpdated != null) ...[
                              const SizedBox(height: 10),
                              Text(
                                'Last updated: $rateUpdated',
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                            const SizedBox(height: 8),
                            const Text(
                              'Source: ExchangeRate-API. Actual bank rates '
                              'may differ because of fees.',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 2. TRIP SUMMARY
  void openTripSummary() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                sectionTitle('Your Trip Summary'),

                Text(
                  'Your destination is ${widget.city}, ${widget.country}.',
                ),

                const SizedBox(height: 12),

                if (widget.numberOfDays != null)
                  Text('Trip duration: ${widget.numberOfDays} days'),

                if (widget.budget != null)
                  Text('Your budget: ₹${widget.budget}'),

                if (widget.travelWith?.isNotEmpty == true)
                  Text('Travelling with: ${widget.travelWith}'),

                if (widget.interests?.isNotEmpty == true)
                  Text('Your interests: ${widget.interests}'),

                if (widget.foodPreference?.isNotEmpty == true)
                  Text('Food preference: ${widget.foodPreference}'),

                if (widget.travelStyle?.isNotEmpty == true)
                  Text('Travel style: ${widget.travelStyle}'),

                const SizedBox(height: 15),

                infoCard(
                  const Text(
                    'Travel reminder: Check your accommodation, '
                    'transportation, travel documents and weather '
                    'before starting your journey.',
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  // 3. WEATHER AND SMART ALERTS
  Future<void> loadWeather() async {
    setState(() {
      loadingWeather = true;
      weatherData = null;
    });

    try {
      final locationUrl = Uri.https(
        'geocoding-api.open-meteo.com',
        '/v1/search',
        {
          'name': widget.city,
          'count': '1',
          'language': 'en',
          'format': 'json',
        },
      );

      final locationResponse = await http.get(locationUrl);

      final locationData = jsonDecode(locationResponse.body);
      final results = locationData['results'];

      if (results == null || results.isEmpty) {
        throw Exception('City not found');
      }

      final latitude = results[0]['latitude'];
      final longitude = results[0]['longitude'];

      final forecastUrl = Uri.https(
        'api.open-meteo.com',
        '/v1/forecast',
        {
          'latitude': '$latitude',
          'longitude': '$longitude',
          'current':
              'temperature_2m,relative_humidity_2m,precipitation,weather_code,wind_speed_10m',
          'daily':
              'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
          'forecast_days': '7',
          'timezone': 'auto',
        },
      );

      final response = await http.get(forecastUrl);

      if (response.statusCode != 200) {
        throw Exception('Weather unavailable');
      }

      if (!mounted) return;

      setState(() {
        weatherData = jsonDecode(response.body);
        loadingWeather = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadingWeather = false;
      });
    }
  }

  String weatherDescription(int code) {
    if (code == 0) return 'Clear sky';
    if (code <= 3) return 'Partly cloudy';
    if (code <= 48) return 'Foggy';
    if (code <= 67) return 'Rain';
    if (code <= 77) return 'Snow';
    if (code <= 82) return 'Rain showers';
    if (code <= 86) return 'Snow showers';
    if (code >= 95) return 'Thunderstorm';
    return 'Variable weather';
  }

  void openWeatherAlerts() async {
    await loadWeather();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        if (weatherData == null) {
          return const Padding(
            padding: EdgeInsets.all(25),
            child: Text(
              'Weather information could not be loaded. '
              'Please check your internet connection.',
            ),
          );
        }

        final current = weatherData!['current'];
        final daily = weatherData!['daily'];

        final code = (current['weather_code'] as num).toInt();
        final temperature = current['temperature_2m'];
        final rain = (current['precipitation'] as num).toDouble();
        final wind = (current['wind_speed_10m'] as num).toDouble();

        return Padding(
          padding: const EdgeInsets.all(22),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                sectionTitle('Smart Weather Alerts'),

                Text('Weather in ${widget.city}'),

                const SizedBox(height: 12),

                infoCard(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$temperature°C',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: purple,
                        ),
                      ),
                      Text(weatherDescription(code)),
                      Text('Humidity: ${current['relative_humidity_2m']}%'),
                      Text('Wind speed: $wind km/h'),
                      Text('Precipitation: $rain mm'),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                if (code >= 51 || rain > 0)
                  const Text(
                    '☔ Rain alert: Carry an umbrella and check outdoor plans.',
                  ),

                if (code >= 95)
                  const Text(
                    '⚠️ Thunderstorm conditions: Avoid exposed outdoor areas.',
                  ),

                if (wind >= 40)
                  const Text(
                    '⚠️ Strong wind: Take extra care outdoors.',
                  ),

                const SizedBox(height: 15),

                const Text(
                  '7-Day Forecast',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                ...List.generate(
                  (daily['time'] as List).length,
                  (index) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(daily['time'][index].toString()),
                    subtitle: Text(
                      'Min ${daily['temperature_2m_min'][index]}°C - '
                      'Max ${daily['temperature_2m_max'][index]}°C',
                    ),
                    trailing: Text(
                      '${daily['precipitation_probability_max'][index]}% rain',
                    ),
                  ),
                ),

                const Text(
                  'Weather source: Open-Meteo. '
                  'Forecasts are not official emergency warnings.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 4. AI PACKING ASSISTANT
  Future<void> openPackingAssistant() async {
    if (weatherData == null) {
      await loadWeather();
    }

    if (!mounted) return;

    final current = weatherData?['current'];

    final temperature =
        (current?['temperature_2m'] as num?)?.toDouble();

    final code =
        (current?['weather_code'] as num?)?.toInt() ?? 0;

    final rain =
        (current?['precipitation'] as num?)?.toDouble() ?? 0;

    final cold = temperature != null && temperature < 15;
    final hot = temperature != null && temperature >= 28;
    final rainy = code >= 51 || rain > 0;

    final days = widget.numberOfDays ?? 3;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                sectionTitle('AI Packing Assistant'),

                Text('Packing list for ${widget.city}, ${widget.country}'),

                const SizedBox(height: 10),

                if (temperature != null)
                  Text('Current temperature: $temperature°C'),

                const SizedBox(height: 15),

                const Text(
                  'Clothing Checklist',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                if (cold) ...[
                  const Text('• Warm jacket'),
                  const Text('• Sweaters'),
                  const Text('• Full-length trousers'),
                  const Text('• Warm socks'),
                ] else if (hot) ...[
                  const Text('• Lightweight cotton clothes'),
                  const Text('• Breathable shirts'),
                  const Text('• Hat or cap'),
                  const Text('• Sunglasses'),
                ] else ...[
                  const Text('• Comfortable everyday clothes'),
                  const Text('• Light jacket'),
                  const Text('• Comfortable trousers and tops'),
                ],

                if (rainy) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Rainy Weather Items',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text('• Umbrella or raincoat'),
                  const Text('• Water-resistant footwear'),
                ],

                const SizedBox(height: 12),

                const Text(
                  'Essential Travel Items',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const Text('• Passport and travel documents'),
                const Text('• Phone and charger'),
                const Text('• Power bank and travel adapter'),
                const Text('• Personal medicines'),
                const Text('• Toiletries'),
                const Text('• Comfortable walking shoes'),

                const SizedBox(height: 12),

                Text('Trip duration: $days days'),
                Text('Suggested clothing sets: ${days + 1}'),

                const SizedBox(height: 10),

                const Text(
                  'Check the forecast again before travelling. '
                  'Weather can change during your trip.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 5. EMERGENCY ASSISTANCE
  Future<void> loadEmergencyPlaces() async {
    setState(() {
      loadingEmergency = true;
      emergencyPlaces = [];
    });

    try {
      // First find the city coordinates.
      final locationUrl = Uri.https(
        'geocoding-api.open-meteo.com',
        '/v1/search',
        {
          'name': widget.city,
          'count': '1',
          'language': 'en',
          'format': 'json',
        },
      );

      final locationResponse = await http.get(locationUrl);
      final locationData = jsonDecode(locationResponse.body);

      final results = locationData['results'];

      if (results == null || results.isEmpty) {
        throw Exception('City not found');
      }

      final latitude =
          (results[0]['latitude'] as num).toDouble();

      final longitude =
          (results[0]['longitude'] as num).toDouble();

      // Search map data within 10 km of the city coordinates.
      final query = '''
[out:json][timeout:25];
(
  node(around:10000,$latitude,$longitude)["amenity"~"hospital|police"];
  way(around:10000,$latitude,$longitude)["amenity"~"hospital|police"];
  node(around:10000,$latitude,$longitude)["office"="diplomatic"];
);
out center tags 40;
''';

      final response = await http.post(
        Uri.parse('https://overpass-api.de/api/interpreter'),
        body: {'data': query},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception('Map information unavailable');
      }

      final data = jsonDecode(response.body);
      final elements = data['elements'] as List;

      final places = <Map<String, dynamic>>[];

      for (final element in elements) {
        final tags = element['tags'] ?? {};
        final name = tags['name'] ?? tags['name:en'];

        if (name == null) continue;

        places.add({
          'name': name.toString(),
          'category': (tags['amenity'] ??
                  tags['office'] ??
                  'Emergency service')
              .toString(),
          'phone': tags['phone'] ?? tags['contact:phone'],
          'address': tags['addr:street'] ?? 'Address not listed',
        });
      }

      if (!mounted) return;

      setState(() {
        emergencyPlaces = places;
        loadingEmergency = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadingEmergency = false;
      });
    }
  }

  void openEmergencyAssistance() async {
    await loadEmergencyPlaces();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle('Emergency Assistance'),

                Text('Services near ${widget.city}, ${widget.country}'),

                const SizedBox(height: 10),

                const Text(
                  'Map data is provided by OpenStreetMap. '
                  'Listings may be incomplete; check details before use.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 12),

                if (loadingEmergency)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (emergencyPlaces.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No matching services were found in the map data. '
                        'This does not mean services are unavailable.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: emergencyPlaces.length,
                      itemBuilder: (context, index) {
                        final place = emergencyPlaces[index];

                        return Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.location_on,
                              color: purple,
                            ),
                            title: Text(place['name']),
                            subtitle: Text(
                              '${place['category']}\n'
                              '${place['address']}\n'
                              'Phone: ${place['phone'] ?? 'Not listed'}',
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
                  ),

                const Text(
                  'For immediate danger, contact the official local '
                  'emergency service. Do not rely only on this map.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // COMMON UI COMPONENTS
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF302442),
        ),
      ),
    );
  }

  Widget infoCard(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: child,
    );
  }

  Widget featureCard(
    IconData icon,
    String title,
    String description,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 13),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(19),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: Container(
          height: 53,
          width: 53,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: purple,
            size: 27,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF302442),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(description),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  // MAIN SCREEN
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Smart Travel Assistance',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: purple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [purple, Color(0xFFAD83E9)],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.travel_explore_rounded,
                  color: Colors.white,
                  size: 38,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Travel smarter and safer!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Smart assistance for ${widget.city}, ${widget.country}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          sectionTitle('Your Smart Travel Tools'),

          const Text(
            'Choose a feature to get destination-based assistance.',
            style: TextStyle(color: Colors.black54),
          ),

          const SizedBox(height: 18),

          featureCard(
            Icons.emergency_rounded,
            'Emergency Assistance',
            'Find map-listed hospitals and police stations.',
            const Color(0xFFFFE3E3),
            openEmergencyAssistance,
          ),

          featureCard(
            Icons.currency_exchange_rounded,
            'Currency Converter',
            'Convert Indian Rupees into your destination currency.',
            const Color(0xFFDDF5E8),
            openCurrencyConverter,
          ),

          featureCard(
            Icons.rate_review_rounded,
            'Trip Review Summary',
            'See your selected trip details and preferences.',
            const Color(0xFFE9E3FF),
            openTripSummary,
          ),

          featureCard(
            Icons.notifications_active_rounded,
            'Smart Alerts',
            'Check destination weather and rain conditions.',
            const Color(0xFFFFF0D5),
            openWeatherAlerts,
          ),

          featureCard(
            Icons.luggage_rounded,
            'AI Packing Assistant',
            'Get packing suggestions based on destination weather.',
            const Color(0xFFDDF1FF),
            openPackingAssistant,
          ),
        ],
      ),
    );
  }
}
