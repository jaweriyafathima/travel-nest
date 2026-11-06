
import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  final String city;
  final String country;

  const WeatherScreen({
    super.key,
    required this.city,
    this.country = '',
  });

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF7653D6);
    const background = Color(0xFFF7F5FC);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Travel Weather',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: purple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7653D6),
                  Color(0xFF9C83F4),
                  Color(0xFFB7A6FA),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: purple.withValues(alpha: 0.22),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white70),
                    SizedBox(width: 6),
                    Text(
                      'YOUR DESTINATION',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  city,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (country.isNotEmpty)
                  Text(
                    country,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Icon(
                      Icons.wb_sunny_rounded,
                      color: Color(0xFFFFE29A),
                      size: 70,
                    ),
                    SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weather preview',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Check the local forecast before you travel.',
                            style: TextStyle(
                              color: Colors.white70,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'Weather essentials',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xFF29233A),
            ),
          ),
          const SizedBox(height: 14),
          _weatherTip(
            icon: Icons.wb_cloudy_outlined,
            color: const Color(0xFF6C8DEB),
            title: 'Check the forecast',
            description:
                'Review temperature and rain chances before leaving.',
          ),
          _weatherTip(
            icon: Icons.checkroom_rounded,
            color: const Color(0xFFE49A55),
            title: 'Pack suitable clothes',
            description:
                'Choose clothing according to the destination’s forecast.',
          ),
          _weatherTip(
            icon: Icons.umbrella_rounded,
            color: const Color(0xFF51A99B),
            title: 'Prepare for rain',
            description:
                'Carry an umbrella or raincoat when showers are expected.',
          ),
          _weatherTip(
            icon: Icons.water_drop_outlined,
            color: const Color(0xFF6C8DEB),
            title: 'Stay hydrated',
            description:
                'Carry water, especially during outdoor sightseeing.',
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE8E1F6)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: purple),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'This screen is a design preview. Live temperature, '
                    'humidity, and forecasts require a weather API. '
                    'No live weather data is shown yet.',
                    style: TextStyle(
                      color: Color(0xFF625B70),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _weatherTip({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 27),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF29233A),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF777184),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
