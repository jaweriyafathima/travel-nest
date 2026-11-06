
import 'package:flutter/material.dart';

class StreetFoodScreen extends StatelessWidget {
  final String city;
  final String country;

  const StreetFoodScreen({
    super.key,
    required this.city,
    this.country = '',
  });

  static const Color purple = Color(0xFF7652C8);
  static const Color background = Color(0xFFF8F6FC);

  List<Map<String, dynamic>> get foods {
    final destination = '$city $country'.toLowerCase();

    if (destination.contains('tokyo') ||
        destination.contains('japan')) {
      return [
        _food(
          'Takoyaki',
          'Popular Japanese street snack',
          'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=900',
          'Round, savoury batter balls traditionally filled with octopus.',
          'Ask about the filling if you have seafood allergies.',
          '¥400–¥800',
          'Non-vegetarian',
        ),
        _food(
          'Taiyaki',
          'Sweet Japanese treat',
          'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=900',
          'Fish-shaped cakes commonly filled with sweet red bean paste or custard.',
          'Ask which filling is available at the stall.',
          '¥200–¥500',
          'Vegetarian options may be available',
        ),
        _food(
          'Yakitori',
          'Grilled skewers',
          'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=900',
          'Grilled skewers, often made with chicken and seasoned with sauce or salt.',
          'Check the ingredients in sauces if you avoid certain foods.',
          '¥150–¥500 per skewer',
          'Usually non-vegetarian',
        ),
      ];
    }

    if (destination.contains('paris') ||
        destination.contains('france')) {
      return [
        _food(
          'French Crêpes',
          'Sweet or savoury snack',
          'https://images.unsplash.com/photo-1519676867240-f03562e64548?w=900',
          'Thin pancakes served with fillings such as chocolate, fruit or cheese.',
          'Ask whether the batter and toppings meet your dietary needs.',
          '€4–€10',
          'Vegetarian options available',
        ),
        _food(
          'Croissant',
          'Classic French pastry',
          'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=900',
          'A buttery, flaky pastry often enjoyed for breakfast or as a snack.',
          'Try a freshly baked one from a local bakery.',
          '€1.50–€4',
          'Usually vegetarian',
        ),
        _food(
          'Falafel Sandwich',
          'Popular quick meal',
          'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=900',
          'A sandwich with chickpea fritters, vegetables and sauces.',
          'Ask about sauces and whether the food is cooked separately.',
          '€6–€12',
          'Often vegetarian',
        ),
      ];
    }

    if (destination.contains('rome') ||
        destination.contains('italy')) {
      return [
        _food(
          'Pizza al Taglio',
          'Roman-style pizza',
          'https://images.unsplash.com/photo-1579751626657-72bc17010498?w=900',
          'Pizza baked in rectangular trays and sold by the slice or weight.',
          'Ask for the price by slice or by weight before ordering.',
          '€3–€8',
          'Vegetarian options available',
        ),
        _food(
          'Supplì',
          'Crispy rice snack',
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=900',
          'A fried rice croquette traditionally filled with tomato rice and mozzarella.',
          'Check the filling if you have dietary restrictions.',
          '€2–€5',
          'Usually vegetarian',
        ),
        _food(
          'Gelato',
          'Italian frozen dessert',
          'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=900',
          'Italian-style ice cream available in many fruit, chocolate and cream flavours.',
          'Ask about dairy, nuts and other allergens.',
          '€3–€7',
          'Vegetarian options available',
        ),
      ];
    }

    if (destination.contains('bangalore') ||
        destination.contains('bengaluru') ||
        destination.contains('india')) {
      return [
        _food(
          'Masala Dosa',
          'South Indian favourite',
          'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=900',
          'A crisp fermented rice-and-lentil crepe filled with spiced potato.',
          'Try it with sambar and chutney; ask about ingredients.',
          '₹60–₹180',
          'Vegetarian',
        ),
        _food(
          'Pani Puri',
          'Tangy street snack',
          'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=900',
          'Crisp puris filled with flavoured water, chutneys and savoury fillings.',
          'Choose a hygienic stall with clean water and fresh ingredients.',
          '₹30–₹100',
          'Often vegetarian',
        ),
        _food(
          'Mangalore Buns',
          'Sweet fried bread',
          'https://images.unsplash.com/photo-1601050690117-94f5f6fa8bd7?w=900',
          'Soft, slightly sweet fried bread popular in Karnataka.',
          'Ask whether the preparation suits your dietary needs.',
          '₹40–₹120',
          'Usually vegetarian',
        ),
      ];
    }

    if (destination.contains('bangkok') ||
        destination.contains('thailand')) {
      return [
        _food(
          'Pad Thai',
          'Thai noodle dish',
          'https://images.unsplash.com/photo-1559314809-0d155014e29e?w=900',
          'Stir-fried rice noodles commonly served with egg, vegetables and sauces.',
          'Ask about fish sauce, peanuts and seafood before ordering.',
          '฿60–฿150',
          'Vegetarian version may be available',
        ),
        _food(
          'Mango Sticky Rice',
          'Sweet Thai dessert',
          'https://images.unsplash.com/photo-1621293954908-907159247fc8?w=900',
          'Sweet sticky rice served with ripe mango and coconut sauce.',
          'Best enjoyed when the mango is ripe and fresh.',
          '฿60–฿150',
          'Usually vegetarian',
        ),
        _food(
          'Thai Satay',
          'Grilled street food',
          'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=900',
          'Grilled skewers served with a flavourful dipping sauce.',
          'Check the protein and sauce ingredients before ordering.',
          '฿40–฿120',
          'Often non-vegetarian',
        ),
      ];
    }

    return [
      _food(
        'Local Street Snack',
        'Discover regional flavours',
        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=900',
        'Explore a popular snack and discover the flavours of the destination.',
        'Ask local vendors about ingredients and preparation.',
        'Check locally',
        'Ask the vendor',
      ),
      _food(
        'Traditional Main Dish',
        'A local favourite',
        'https://images.unsplash.com/photo-1547592180-85f173990554?w=900',
        'Look for traditional dishes made with ingredients from the region.',
        'Ask about spice levels and allergens before ordering.',
        'Check locally',
        'Ask the vendor',
      ),
      _food(
        'Local Sweet Treat',
        'Something sweet',
        'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=900',
        'Finish your food walk with a dessert or sweet snack.',
        'Check ingredients if you have dietary restrictions.',
        'Check locally',
        'Ask the vendor',
      ),
    ];
  }

  static Map<String, dynamic> _food(
    String name,
    String category,
    String image,
    String description,
    String tip,
    String price,
    String dietary,
  ) {
    return {
      'name': name,
      'category': category,
      'image': image,
      'description': description,
      'tip': tip,
      'price': price,
      'dietary': dietary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final destination = country.isEmpty ? city : '$city, $country';

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Street Food',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: background,
        foregroundColor: const Color(0xFF28223A),
        elevation: 0,
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
                  Icons.restaurant_rounded,
                  color: Colors.white,
                  size: 35,
                ),
                const SizedBox(height: 14),
                const Text(
                  'Taste the local culture',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover street food and local flavours in $destination.',
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
          const Text(
            'Must-try flavours',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF28223A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap any dish to learn more.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          ...foods.map(
            (food) => _FoodCard(
              food: food,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StreetFoodDetailsScreen(
                      food: food,
                      city: city,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Prices are approximate examples and may vary by vendor and location.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF777080),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodCard extends StatelessWidget {
  final Map<String, dynamic> food;
  final VoidCallback onTap;

  const _FoodCard({
    required this.food,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 3,
      shadowColor: const Color(0x227652C8),
      color: Colors.white,
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
                  food['image'] as String,
                  height: 185,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: 185,
                      color: const Color(0xFFECE5FA),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF7652C8),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    height: 185,
                    color: const Color(0xFFECE5FA),
                    child: const Center(
                      child: Icon(
                        Icons.restaurant_rounded,
                        size: 45,
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
                      food['category'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7652C8),
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
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food['name'] as String,
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
                              Icons.currency_exchange_rounded,
                              color: Color(0xFF7652C8),
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                food['price'] as String,
                                style: const TextStyle(
                                  color: Color(0xFF5F596D),
                                  fontWeight: FontWeight.w600,
                                ),
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

class StreetFoodDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> food;
  final String city;

  const StreetFoodDetailsScreen({
    super.key,
    required this.food,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FC),
      appBar: AppBar(
        title: const Text('Food Details'),
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
              food['image'] as String,
              height: 245,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 245,
                color: const Color(0xFFECE5FA),
                child: const Icon(
                  Icons.restaurant_rounded,
                  size: 60,
                  color: Color(0xFF7652C8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            food['name'] as String,
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
              const Icon(
                Icons.currency_exchange_rounded,
                color: Color(0xFF7652C8),
              ),
              const SizedBox(width: 4),
              Text(
                food['price'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _title('About this dish'),
          const SizedBox(height: 8),
          Text(
            food['description'] as String,
            style: const TextStyle(
              fontSize: 15,
              height: 1.7,
              color: Color(0xFF5F596D),
            ),
          ),
          const SizedBox(height: 24),
          _title('Dietary information'),
          const SizedBox(height: 10),
          _infoCard(
            Icons.eco_outlined,
            food['dietary'] as String,
          ),
          const SizedBox(height: 24),
          _title('Food tip'),
          const SizedBox(height: 10),
          _infoCard(
            Icons.lightbulb_outline_rounded,
            food['tip'] as String,
          ),
          const SizedBox(height: 24),
          _infoCard(
            Icons.info_outline_rounded,
            'Check ingredients, food hygiene and current prices with the vendor. Dietary labels are general guidance, not a guarantee about preparation or allergens.',
          ),
        ],
      ),
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
        color: Color(0xFF28223A),
      ),
    );
  }

  Widget _infoCard(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF7652C8), size: 25),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
