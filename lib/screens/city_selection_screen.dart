import 'package:flutter/material.dart';

import '../data/image_data.dart';
import 'ai_travel_questions_screen.dart';

class CitySelectionScreen extends StatelessWidget {
  final String country;

  const CitySelectionScreen({
    super.key,
    required this.country,
  });

  List<Map<String, String>> getCities() {
    switch (country) {
      case 'Japan':
        return [
          {
            'name': 'Tokyo',
            'description': 'Modern city life & iconic attractions',
            'image': ImageData.tokyo,
          },
          {
            'name': 'Osaka',
            'description': 'Food, nightlife & exciting adventures',
            'image': ImageData.osaka,
          },
          {
            'name': 'Kyoto',
            'description': 'Temples, traditions & cherry blossoms',
            'image': ImageData.kyoto,
          },
          {
            'name': 'Sapporo',
            'description': 'Snow festivals & beautiful nature',
            'image': ImageData.sapporo,
          },
        ];

      case 'France':
        return [
          {
            'name': 'Paris',
            'description': 'Eiffel Tower, art & romantic streets',
            'image': ImageData.france,
          },
          {
            'name': 'Nice',
            'description': 'Sunny beaches & Mediterranean beauty',
            'image': ImageData.france,
          },
          {
            'name': 'Lyon',
            'description': 'History, food & beautiful architecture',
            'image': ImageData.france,
          },
          {
            'name': 'Marseille',
            'description': 'Coastal views, culture & old port',
            'image': ImageData.france,
          },
        ];

      case 'Italy':
        return [
          {
            'name': 'Rome',
            'description': 'Ancient history & world-famous landmarks',
            'image': ImageData.italy,
          },
          {
            'name': 'Milan',
            'description': 'Fashion, shopping & modern lifestyle',
            'image': ImageData.italy,
          },
          {
            'name': 'Venice',
            'description': 'Canals, gondolas & romantic streets',
            'image': ImageData.italy,
          },
          {
            'name': 'Florence',
            'description': 'Renaissance art & beautiful architecture',
            'image': ImageData.italy,
          },
        ];

      case 'Thailand':
        return [
          {
            'name': 'Bangkok',
            'description': 'Temples, markets & vibrant city life',
            'image': ImageData.thailand,
          },
          {
            'name': 'Phuket',
            'description': 'Beautiful beaches & island adventures',
            'image': ImageData.thailand,
          },
          {
            'name': 'Chiang Mai',
            'description': 'Temples, mountains & local culture',
            'image': ImageData.thailand,
          },
          {
            'name': 'Pattaya',
            'description': 'Beaches, entertainment & nightlife',
            'image': ImageData.thailand,
          },
        ];

      case 'Switzerland':
        return [
          {
            'name': 'Zurich',
            'description': 'Lakes, shopping & modern city life',
            'image': ImageData.switzerland,
          },
          {
            'name': 'Geneva',
            'description': 'Lake views, culture & international charm',
            'image': ImageData.switzerland,
          },
          {
            'name': 'Lucerne',
            'description': 'Mountains, lakes & charming old town',
            'image': ImageData.switzerland,
          },
          {
            'name': 'Interlaken',
            'description': 'Alps, adventure & breathtaking scenery',
            'image': ImageData.switzerland,
          },
        ];

      case 'Australia':
        return [
          {
            'name': 'Sydney',
            'description': 'Opera House, beaches & harbour views',
            'image': ImageData.australia,
          },
          {
            'name': 'Melbourne',
            'description': 'Art, cafés, culture & city experiences',
            'image': ImageData.australia,
          },
          {
            'name': 'Brisbane',
            'description': 'Sunny weather, river views & attractions',
            'image': ImageData.australia,
          },
          {
            'name': 'Gold Coast',
            'description': 'Beaches, theme parks & coastal adventures',
            'image': ImageData.australia,
          },
        ];

      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final cities = getCities();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F3FC),
      body: SafeArea(
        child: Stack(
          children: [
            // ================================================
            // BACKGROUND DECORATION
            // ================================================

            Positioned(
              top: -70,
              right: -50,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9D8F7).withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              top: 300,
              left: -90,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDDE9).withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // ================================================
            // MAIN CONTENT
            // ================================================

            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ============================================
                  // TOP BAR
                  // ============================================

                  Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.10),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF4A3157),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF7B2CBF),
                              Color(0xFFB565D9),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.location_city_rounded,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Travel Nest',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3D2352),
                              ),
                            ),
                            Text(
                              'Explore • Plan • Experience',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF927E9C),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.flight_takeoff_rounded,
                          color: Color(0xFF7B2CBF),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ============================================
                  // SELECTED COUNTRY
                  // ============================================

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFEDE0FA),
                          Color(0xFFFFE6EE),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.public_rounded,
                            color: Color(0xFF7B2CBF),
                            size: 26,
                          ),
                        ),

                        const SizedBox(width: 13),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Selected Country',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF927E9C),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                country,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A3157),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF7B2CBF),
                          size: 25,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ============================================
                  // TITLE
                  // ============================================

                  Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE0FA),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.location_city_rounded,
                          color: Color(0xFF7B2CBF),
                          size: 25,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Text(
                          'Choose a City',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3D2352),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  const Padding(
                    padding: EdgeInsets.only(left: 57),
                    child: Text(
                      'Pick a city you would love to explore and we will plan your perfect trip.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Color(0xFF806A8C),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ============================================
                  // CITY COUNT
                  // ============================================

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Popular Cities',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3D2352),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE0FA),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${cities.length} Cities',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF7B2CBF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // ============================================
                  // CITY CARDS
                  // ============================================

                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      final city = cities[index];

                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16,
                        ),
                        child: _CityCard(
                          name: city['name']!,
                          description: city['description']!,
                          image: city['image']!,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AITravelQuestionsScreen(
                                  country: country,
                                  city: city['name']!,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // ============================================
                  // BOTTOM MESSAGE
                  // ============================================

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          color: Color(0xFF7B2CBF),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'After selecting your city, Travel Nest will ask a few questions to personalize your trip.',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: Color(0xFF806A8C),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CITY CARD
// ============================================================

class _CityCard extends StatelessWidget {
  final String name;
  final String description;
  final String image;
  final VoidCallback onTap;

  const _CityCard({
    required this.name,
    required this.description,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 145,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Row(
            children: [
              // ==============================================
              // CITY IMAGE
              // ==============================================

              SizedBox(
                width: 145,
                height: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFB565D9),
                                Color(0xFFFFB4A2),
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.location_city_rounded,
                            color: Colors.white70,
                            size: 50,
                          ),
                        );
                      },
                    ),

                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.45),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      left: 12,
                      bottom: 12,
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ==============================================
              // CITY DETAILS
              // ==============================================

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A3157),
                              ),
                            ),
                          ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0E2FF),
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Color(0xFF7B2CBF),
                              size: 18,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Expanded(
                        child: Text(
                          description,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.45,
                            color: Color(0xFF806A8C),
                          ),
                        ),
                      ),

                      const Row(
                        children: [
                          Icon(
                            Icons.explore_outlined,
                            size: 15,
                            color: Color(0xFF7B2CBF),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Explore this city',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF7B2CBF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}