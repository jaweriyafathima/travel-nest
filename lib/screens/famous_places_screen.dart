
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FamousPlacesScreen extends StatelessWidget {
  final String city;
  final String country;

  const FamousPlacesScreen({
    super.key,
    required this.city,
    this.country = '',
  });

  static const Color purple = Color(0xFF7652C8);
  static const Color background = Color(0xFFF8F6FC);

  List<Map<String, dynamic>> get places {
    final name = city.toLowerCase();

    if (name.contains('tokyo')) {
      return [
        _place(
          'Tokyo Tower',
          'Iconic city landmark',
          'https://images.unsplash.com/photo-1536098561742-ca998e48cbcc?w=900',
          'Enjoy panoramic views of Tokyo and its surrounding skyline.',
          'Visit near sunset for beautiful city views.',
          4.7,
        ),
        _place(
          'Senso-ji Temple',
          'Historic Buddhist temple',
          'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=900',
          'Explore traditional architecture, temple grounds and nearby streets.',
          'Arrive early to enjoy a quieter visit.',
          4.8,
        ),
        _place(
          'Shibuya Crossing',
          'Famous city crossing',
          'https://images.unsplash.com/photo-1542051841857-5f90071e7989?w=900',
          'Experience one of Tokyo’s best-known busy pedestrian crossings.',
          'The surrounding streets are great for shopping and food.',
          4.6,
        ),
      ];
    }

    if (name.contains('kyoto')) {
      return [
        _place(
          'Fushimi Inari Shrine',
          'Iconic red torii gates',
          'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=900',
          'Walk through the striking red gates along a forested mountain path.',
          'Start early if you prefer fewer crowds.',
          4.9,
        ),
        _place(
          'Arashiyama Bamboo Grove',
          'Peaceful nature walk',
          'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?w=900',
          'Enjoy a walk among tall bamboo stalks in a scenic setting.',
          'Wear comfortable shoes for exploring the area.',
          4.7,
        ),
      ];
    }

    if (name.contains('paris')) {
      return [
        _place(
          'Eiffel Tower',
          'Paris landmark',
          'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=900',
          'See the famous iron tower and enjoy views across Paris.',
          'Check official ticket availability before visiting.',
          4.8,
        ),
        _place(
          'Louvre Museum',
          'Art and culture',
          'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?w=900',
          'Discover renowned artworks and the museum’s historic architecture.',
          'Allow enough time for the galleries you want to see.',
          4.8,
        ),
        _place(
          'Arc de Triomphe',
          'Historic monument',
          'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=900',
          'Visit the monumental arch at the end of the Champs-Élysées.',
          'Use the designated pedestrian access to reach the monument.',
          4.7,
        ),
      ];
    }

    if (name.contains('rome')) {
      return [
        _place(
          'Colosseum',
          'Ancient Roman landmark',
          'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=900',
          'Explore the famous amphitheatre from the days of ancient Rome.',
          'Book entry in advance when possible.',
          4.9,
        ),
        _place(
          'Trevi Fountain',
          'Historic fountain',
          'https://images.unsplash.com/photo-1525874684015-58379d421a52?w=900',
          'Admire the ornate fountain in a lively historic neighbourhood.',
          'Early morning can be less crowded.',
          4.7,
        ),
      ];
    }

    if (name.contains('bangalore') || name.contains('bengaluru')) {
      return [
        _place(
          'Lalbagh Botanical Garden',
          'Nature and gardens',
          'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?w=900',
          'Explore landscaped gardens, plant collections and walking paths.',
          'Check garden timings before travelling.',
          4.5,
        ),
        _place(
          'Bengaluru Palace',
          'Historic architecture',
          'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=900',
          'Discover palace architecture and the history of the city.',
          'Check visitor access and photography rules.',
          4.4,
        ),
        _place(
          'Cubbon Park',
          'Green city escape',
          'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=900',
          'Enjoy a green retreat with shaded paths in the city.',
          'A comfortable option for a relaxed walk.',
          4.5,
        ),
      ];
    }

    return [
      _place(
        'City Landmark',
        'A place to explore',
        'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=900',
        'Discover a well-known landmark and learn more about the local area.',
        'Check local visitor information before your trip.',
        4.5,
      ),
      _place(
        'Nature Escape',
        'Scenic outdoor spot',
        'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?w=900',
        'Take a break from busy streets and enjoy the surrounding scenery.',
        'Check weather and opening hours before leaving.',
        4.4,
      ),
      _place(
        'Historic District',
        'Culture and heritage',
        'https://images.unsplash.com/photo-1511818966892-d7d671e672a2?w=900',
        'Explore local architecture, culture and interesting streets.',
        'Allow time to walk around and explore nearby places.',
        4.3,
      ),
    ];
  }

  static Map<String, dynamic> _place(
    String title,
    String category,
    String image,
    String description,
    String tip,
    double rating,
  ) {
    return {
      'title': title,
      'category': category,
      'image': image,
      'description': description,
      'tip': tip,
      'rating': rating,
    };
  }

  @override
  Widget build(BuildContext context) {
    final destination = country.isEmpty ? city : '$city, $country';

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: const Color(0xFF28223A),
        elevation: 0,
        title: const Text(
          'Famous Places',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7652C8), Color(0xFFA78BFA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.explore_rounded,
                  color: Colors.white,
                  size: 34,
                ),
                const SizedBox(height: 14),
                const Text(
                  'Explore amazing places',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Discover memorable places in $destination.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Places to discover',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF28223A),
                ),
          ),
          const SizedBox(height: 5),
          Text(
            'Tap a card to explore more details.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          ...places.map(
            (place) => _PlaceCard(
              place: place,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FamousPlaceDetailsScreen(
                      place: place,
                      city: city,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final Map<String, dynamic> place;
  final VoidCallback onTap;

  const _PlaceCard({
    required this.place,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: Colors.white,
      elevation: 3,
      shadowColor: const Color(0x227652C8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  place['image'] as String,
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: 190,
                      color: const Color(0xFFECE5FA),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF7652C8),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    height: 190,
                    color: const Color(0xFFECE5FA),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 42,
                        color: Color(0xFF7652C8),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      place['category'] as String,
                      style: const TextStyle(
                        color: Color(0xFF7652C8),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 15, 16, 17),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place['title'] as String,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF28223A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFFB547),
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              (place['rating'] as double).toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                '•  ${place['category']}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  const CircleAvatar(
                    backgroundColor: Color(0xFFF0E9FC),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: Color(0xFF7652C8),
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

class FamousPlaceDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> place;
  final String city;

  const FamousPlaceDetailsScreen({
    super.key,
    required this.place,
    required this.city,
  });

  Future<void> _openVideo(BuildContext context) async {
    final query = Uri.encodeComponent(
      '${place['title']} $city travel guide',
    );
    final uri = Uri.parse(
      'https://www.youtube.com/results?search_query=$query',
    );

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open video search.')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open video search.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FC),
      appBar: AppBar(
        title: const Text('Place Details'),
        backgroundColor: const Color(0xFFF8F6FC),
        foregroundColor: const Color(0xFF28223A),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 28),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              place['image'] as String,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 250,
                color: const Color(0xFFECE5FA),
                child: const Icon(
                  Icons.landscape_rounded,
                  size: 60,
                  color: Color(0xFF7652C8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            place['title'] as String,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: Color(0xFF28223A),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: Color(0xFF7652C8),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  city,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ),
              const Icon(Icons.star_rounded, color: Color(0xFFFFB547)),
              Text(
                (place['rating'] as double).toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _sectionTitle('About this place'),
          const SizedBox(height: 8),
          Text(
            place['description'] as String,
            style: const TextStyle(
              fontSize: 15,
              height: 1.7,
              color: Color(0xFF5F596D),
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle('Travel tip'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Color(0xFF7652C8),
                  size: 25,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    place['tip'] as String,
                    style: const TextStyle(height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle('Explore more'),
          const SizedBox(height: 12),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => _openVideo(context),
              icon: const Icon(Icons.play_circle_outline_rounded),
              label: const Text('Find travel videos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7652C8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.rate_review_outlined,
                  color: Color(0xFF7652C8),
                  size: 25,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Visitor reviews',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Reviews are not connected to a live review service yet.',
                        style: TextStyle(
                          color: Color(0xFF777080),
                          height: 1.5,
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
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
        color: Color(0xFF28223A),
      ),
    );
  }
}
