
import 'package:flutter/material.dart';

class AIPhotoGuideScreen extends StatefulWidget {
  const AIPhotoGuideScreen({
    super.key,
    required this.city,
    this.country = '',
  });

  final String city;
  final String country;

  @override
  State<AIPhotoGuideScreen> createState() =>
      _AIPhotoGuideScreenState();
}

class _AIPhotoGuideScreenState extends State<AIPhotoGuideScreen> {
  String selectedScene = 'Landscape';

  final List<Map<String, dynamic>> scenes = [
    {
      'title': 'Landscape',
      'icon': Icons.landscape_rounded,
      'description': 'Mountains, beaches and scenic views',
    },
    {
      'title': 'Portrait',
      'icon': Icons.portrait_rounded,
      'description': 'People and travel portraits',
    },
    {
      'title': 'Street',
      'icon': Icons.location_city_rounded,
      'description': 'Buildings and city streets',
    },
    {
      'title': 'Night',
      'icon': Icons.nightlight_round,
      'description': 'Night views and city lights',
    },
    {
      'title': 'Food',
      'icon': Icons.restaurant_rounded,
      'description': 'Local food and cafes',
    },
    {
      'title': 'Wildlife',
      'icon': Icons.pets_rounded,
      'description': 'Animals and distant subjects',
    },
  ];

  Map<String, String> get recommendation {
    switch (selectedScene) {
      case 'Portrait':
        return {
          'camera':
              'Recommended: Mirrorless or DSLR camera with a 50mm or 85mm lens.',
          'phone':
              'Use Portrait mode, tap the face to focus, and use soft natural light.',
          'settings':
              'Try a wide aperture such as f/1.8–f/2.8 if your camera supports it. Keep the eyes in focus.',
          'tip':
              'Place your subject near a window or in soft shade. Avoid harsh direct sunlight.',
        };

      case 'Street':
        return {
          'camera':
              'Recommended: Mirrorless or DSLR camera with a 24–35mm lens.',
          'phone':
              'Use the main 1× camera, enable grid lines, and tap your subject to focus.',
          'settings':
              'Use a faster shutter speed for moving subjects. Keep ISO low when possible.',
          'tip':
              'Look for reflections, interesting architecture, colorful signs, and everyday moments.',
        };

      case 'Night':
        return {
          'camera':
              'Recommended: A camera with good low-light performance and a wide-aperture lens.',
          'phone':
              'Use Night mode, hold your phone steady, and avoid digital zoom.',
          'settings':
              'Use a tripod if available. Longer exposures can brighten scenes but may blur moving subjects.',
          'tip':
              'Rest your phone on a stable surface and photograph illuminated buildings or street lights.',
        };

      case 'Food':
        return {
          'camera':
              'Recommended: A 35mm or 50mm lens. A close-focus lens can also be useful.',
          'phone':
              'Use the main camera, tap the food to focus, and photograph near a window.',
          'settings':
              'Avoid flash close to the food. Keep the camera steady and adjust exposure if needed.',
          'tip':
              'Try a top-down or 45-degree angle. Keep the background simple and uncluttered.',
        };

      case 'Wildlife':
        return {
          'camera':
              'Recommended: A camera with a telephoto lens, such as a 70–300mm lens.',
          'phone':
              'Use optical telephoto zoom if your phone has it. Stabilize the phone before taking a photo.',
          'settings':
              'Use a fast shutter speed for moving animals. Avoid excessive digital zoom.',
          'tip':
              'Keep a safe, respectful distance. Never disturb or feed animals for a photograph.',
        };

      default:
        return {
          'camera':
              'Recommended: Mirrorless or DSLR camera with a wide-angle lens, around 16–35mm.',
          'phone':
              'Use your main 1× camera, enable grid lines, and clean the camera lens.',
          'settings':
              'In daylight, use a low ISO when possible. Tap to focus on the main subject.',
          'tip':
              'Keep the horizon straight and include an object in the foreground to add depth.',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final advice = recommendation;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FC),
      appBar: AppBar(
        title: const Text(
          'AI Photo Guide',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF7046C7),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF7046C7),
                    Color(0xFF9871E3),
                    Color(0xFFDCA0D0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7046C7)
                        .withValues(alpha: 0.20),
                    blurRadius: 16,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.photo_camera_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Capture Your Journey',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Photography suggestions for ${widget.city}'
                    '${widget.country.isNotEmpty ? ', ${widget.country}' : ''}.',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Choose your photo type below',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'What do you want to photograph?',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF302442),
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: scenes.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.25,
              ),
              itemBuilder: (context, index) {
                final scene = scenes[index];
                final title = scene['title'] as String;
                final isSelected = selectedScene == title;

                return Material(
                  color: isSelected
                      ? const Color(0xFFECE4FF)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      setState(() {
                        selectedScene = title;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF7046C7)
                              : const Color(0xFFE8E1F0),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            scene['icon'] as IconData,
                            color: const Color(0xFF7046C7),
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF302442),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            scene['description'] as String,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF777080),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Camera Recommendations',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF302442),
              ),
            ),
            const SizedBox(height: 12),
            _recommendationCard(
              icon: Icons.camera_alt_rounded,
              title: 'Camera and Lens',
              text: advice['camera']!,
              color: const Color(0xFFECE4FF),
            ),
            _recommendationCard(
              icon: Icons.phone_android_rounded,
              title: 'Phone Camera Settings',
              text: advice['phone']!,
              color: const Color(0xFFFFE8F0),
            ),
            _recommendationCard(
              icon: Icons.tune_rounded,
              title: 'Suggested Settings',
              text: advice['settings']!,
              color: const Color(0xFFE1F3FF),
            ),
            _recommendationCard(
              icon: Icons.lightbulb_outline_rounded,
              title: 'Photography Tip',
              text: advice['tip']!,
              color: const Color(0xFFFFF0D9),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFF7046C7),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'These are general photography recommendations, '
                      'not live AI analysis. Camera settings vary by device. '
                      'This screen does not open the camera.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: Color(0xFF71697B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _recommendationCard({
    required IconData icon,
    required String title,
    required String text,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF7046C7),
              size: 24,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF302442),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Color(0xFF71697B),
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
