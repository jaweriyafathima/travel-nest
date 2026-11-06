
import 'package:flutter/material.dart';

import '../data/image_data.dart';
import 'city_selection_screen.dart';

class CountrySelectionScreen extends StatefulWidget {
  final String initialSearch;

  const CountrySelectionScreen({
    super.key,
    this.initialSearch = '',
  });

  @override
  State<CountrySelectionScreen> createState() =>
      _CountrySelectionScreenState();
}

class _CountrySelectionScreenState
    extends State<CountrySelectionScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  final List<Map<String, String>> countries = [
    {
      'name': 'Japan',
      'flag': '🇯🇵',
      'description': 'Cherry blossoms & modern wonders',
      'image': ImageData.japan,
    },
    {
      'name': 'France',
      'flag': '🇫🇷',
      'description': 'Romance, art & endless beauty',
      'image': ImageData.france,
    },
    {
      'name': 'Italy',
      'flag': '🇮🇹',
      'description': 'History, culture & la dolce vita',
      'image': ImageData.italy,
    },
    {
      'name': 'Thailand',
      'flag': '🇹🇭',
      'description': 'Beaches, temples & exotic adventures',
      'image': ImageData.thailand,
    },
    {
      'name': 'Switzerland',
      'flag': '🇨🇭',
      'description': 'Snowy peaks & scenic beauty',
      'image': ImageData.switzerland,
    },
    {
      'name': 'Australia',
      'flag': '🇦🇺',
      'description': 'Wildlife, beaches & endless horizons',
      'image': ImageData.australia,
    },
    {
      'name': 'India',
      'flag': '🇮🇳',
      'description': 'Culture, heritage & incredible diversity',
      'image': 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=800',
    },
  ];

  String searchQuery = '';

  static const Color purple = Color(0xFF7B2CBF);

  @override
  void initState() {
    super.initState();

    searchQuery = widget.initialSearch;
    _searchController.text = widget.initialSearch;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get filteredCountries {
    if (searchQuery.trim().isEmpty) {
      return countries;
    }

    return countries.where((country) {
      return country['name']!
          .toLowerCase()
          .contains(searchQuery.trim().toLowerCase());
    }).toList();
  }

  void openCountry(Map<String, String> country) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CitySelectionScreen(
          country: country['name']!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredCountries;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F3FC),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -70,
              right: -60,
              child: Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8D8F7).withOpacity(0.65),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              top: 180,
              left: -80,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDCE8).withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TOP BAR
                  Row(
                    children: [
                      _topIcon(
                        Icons.arrow_back_rounded,
                        () => Navigator.pop(context),
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
                          Icons.travel_explore_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                      _topIcon(Icons.public_rounded, null),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // TITLE
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
                          Icons.location_on_rounded,
                          color: purple,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Choose a Country',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3D2352),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Select your dream destination and start planning your next adventure!',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Color(0xFF806A8C),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // INFORMATION BANNER
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFEEE0FF),
                          Color(0xFFFFE5EE),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: purple,
                          ),
                        ),
                        SizedBox(width: 13),
                        Expanded(
                          child: Text(
                            'Discover amazing places, new cultures and unforgettable experiences around the world.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.45,
                              color: Color(0xFF5D416A),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // SEARCH FIELD
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.07),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search a country...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF927E9C),
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: purple,
                        ),
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    searchQuery = '';
                                  });
                                },
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Color(0xFF927E9C),
                                ),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 17),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // COUNTRY COUNT
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Popular Destinations',
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
                          '${filtered.length} Countries',
                          style: const TextStyle(
                            fontSize: 11,
                            color: purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // COUNTRY GRID
                  if (filtered.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: Color(0xFFB565D9),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No country found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3D2352),
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Try searching for another country.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF927E9C),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.70,
                      ),
                      itemBuilder: (context, index) {
                        final country = filtered[index];

                        return _CountryCard(
                          name: country['name']!,
                          flag: country['flag']!,
                          description: country['description']!,
                          image: country['image']!,
                          onTap: () => openCountry(country),
                        );
                      },
                    ),

                  const SizedBox(height: 25),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '✈️  Choose your destination and let the adventure begin!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF806A8C),
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _topIcon(IconData icon, VoidCallback? onTap) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        icon: Icon(icon, color: const Color(0xFF4A3157)),
      ),
    );
  }
}

class _CountryCard extends StatelessWidget {
  final String name;
  final String flag;
  final String description;
  final String image;
  final VoidCallback onTap;

  const _CountryCard({
    required this.name,
    required this.flag,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
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
                            Icons.landscape_rounded,
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
                      top: 10,
                      left: 10,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            flag,
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13,
                      right: 10,
                      bottom: 10,
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
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(13, 10, 10, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            height: 1.35,
                            color: Color(0xFF806A8C),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0E2FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Color(0xFF7B2CBF),
                          size: 17,
                        ),
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
