
import 'package:flutter/material.dart';

class ShoppingScreen extends StatelessWidget {
  final String city;
  final String country;

  const ShoppingScreen({
    super.key,
    required this.city,
    this.country = '',
  });

  static const Color purple = Color(0xFF7652C8);
  static const Color background = Color(0xFFF8F6FC);

  List<Map<String, dynamic>> get products {
    final destination = '$city $country'.toLowerCase();

    if (destination.contains('tokyo') ||
        destination.contains('japan')) {
      return [
        _product(
          'Traditional Japanese Fan',
          'Souvenirs',
          'https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=900',
          'A decorative fan inspired by traditional Japanese designs.',
          '¥500–¥2,500',
          'Look for local craft shops and gift stores.',
        ),
        _product(
          'Japanese Ceramics',
          'Handicrafts',
          'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=900',
          'Ceramic cups, bowls and decorative pieces in a range of styles.',
          '¥1,000–¥5,000',
          'Wrap fragile items securely before travelling.',
        ),
        _product(
          'Japanese Snacks',
          'Local Gifts',
          'https://images.unsplash.com/photo-1589365278144-c9e705f843ba?w=900',
          'Packaged regional sweets and snacks that make easy gifts.',
          '¥300–¥2,000',
          'Check ingredients, expiry dates and customs restrictions.',
        ),
      ];
    }

    if (destination.contains('paris') ||
        destination.contains('france')) {
      return [
        _product(
          'French Perfume',
          'Beauty',
          'https://images.unsplash.com/photo-1541643600914-78b084683601?w=900',
          'Explore fragrances from independent perfumeries and established brands.',
          '€15–€100+',
          'Compare bottle sizes and prices before purchasing.',
        ),
        _product(
          'French Pastries and Chocolates',
          'Food Gifts',
          'https://images.unsplash.com/photo-1548907040-4d42faa7b9e5?w=900',
          'Sweet treats that can make thoughtful gifts for friends and family.',
          '€5–€30',
          'Check storage needs and food import rules.',
        ),
        _product(
          'French Fashion Accessories',
          'Fashion',
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=900',
          'Discover scarves, bags and accessories at local boutiques.',
          '€10–€100+',
          'Check the return policy before buying.',
        ),
      ];
    }

    if (destination.contains('rome') ||
        destination.contains('italy')) {
      return [
        _product(
          'Italian Leather Goods',
          'Fashion',
          'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=900',
          'Explore leather bags, wallets and other accessories.',
          '€20–€150+',
          'Ask about materials and keep your receipt.',
        ),
        _product(
          'Italian Ceramics',
          'Handicrafts',
          'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=900',
          'Decorative pottery and tableware in traditional and modern designs.',
          '€10–€80+',
          'Confirm that delicate items are packed for travel.',
        ),
        _product(
          'Italian Food Gifts',
          'Local Gifts',
          'https://images.unsplash.com/photo-1556761223-4c4282c73f77?w=900',
          'Explore packaged regional foods and specialty ingredients.',
          '€5–€40',
          'Check ingredient labels and import restrictions.',
        ),
      ];
    }

    if (destination.contains('bangalore') ||
        destination.contains('bengaluru') ||
        destination.contains('india')) {
      return [
        _product(
          'Handmade Crafts',
          'Handicrafts',
          'https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=900',
          'Discover handmade decorative items and gifts inspired by local craft traditions.',
          '₹200–₹3,000',
          'Compare quality and ask about the maker.',
        ),
        _product(
          'Traditional Textiles',
          'Fashion',
          'https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?w=900',
          'Explore colourful fabrics, scarves and traditional clothing.',
          '₹300–₹5,000+',
          'Check fabric details and care instructions.',
        ),
        _product(
          'Local Sweets and Snacks',
          'Food Gifts',
          'https://images.unsplash.com/photo-1589365278144-c9e705f843ba?w=900',
          'Find packaged regional treats to share with friends and family.',
          '₹100–₹1,000',
          'Check freshness, ingredients and packaging.',
        ),
      ];
    }

    if (destination.contains('bangkok') ||
        destination.contains('thailand')) {
      return [
        _product(
          'Thai Handmade Souvenirs',
          'Souvenirs',
          'https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=900',
          'Explore handmade keepsakes and decorative pieces.',
          '฿100–฿1,500',
          'Compare prices at more than one shop.',
        ),
        _product(
          'Thai Silk and Textiles',
          'Fashion',
          'https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?w=900',
          'Discover colourful fabrics, scarves and clothing.',
          '฿200–฿3,000+',
          'Ask about fabric composition and care.',
        ),
        _product(
          'Thai Snack Gifts',
          'Food Gifts',
          'https://images.unsplash.com/photo-1589365278144-c9e705f843ba?w=900',
          'Packaged snacks and sweets are convenient gifts for your trip home.',
          '฿50–฿800',
          'Check food import restrictions for your destination.',
        ),
      ];
    }

    return [
      _product(
        'Local Souvenirs',
        'Souvenirs',
        'https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=900',
        'Find memorable keepsakes that reflect the culture of your destination.',
        'Check locally',
        'Explore craft shops and compare prices.',
      ),
      _product(
        'Fashion and Accessories',
        'Fashion',
        'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=900',
        'Browse locally popular clothing, bags and accessories.',
        'Check locally',
        'Check sizing and return policies before purchasing.',
      ),
      _product(
        'Regional Food Gifts',
        'Food Gifts',
        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=900',
        'Discover packaged regional treats and specialty products.',
        'Check locally',
        'Check ingredients, expiry dates and travel restrictions.',
      ),
    ];
  }

  static Map<String, dynamic> _product(
    String name,
    String category,
    String image,
    String description,
    String price,
    String tip,
  ) {
    return {
      'name': name,
      'category': category,
      'image': image,
      'description': description,
      'price': price,
      'tip': tip,
    };
  }

  @override
  Widget build(BuildContext context) {
    final destination = country.isEmpty ? city : '$city, $country';

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Shopping',
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
                  Icons.shopping_bag_rounded,
                  color: Colors.white,
                  size: 35,
                ),
                const SizedBox(height: 14),
                const Text(
                  'Discover local treasures',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Explore souvenirs, fashion and local products in $destination.',
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
            'Shopping inspiration',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF28223A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Find something special to remember your trip.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          ...products.map(
            (product) => _ShoppingCard(
              product: product,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ShoppingDetailsScreen(
                      product: product,
                      city: city,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Prices are illustrative estimates, not live shop prices.',
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

class _ShoppingCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;

  const _ShoppingCard({
    required this.product,
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
                  product['image'] as String,
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
                        Icons.shopping_bag_outlined,
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
                      product['category'] as String,
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
                          product['name'] as String,
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
                              Icons.sell_outlined,
                              size: 18,
                              color: Color(0xFF7652C8),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                product['price'] as String,
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

class ShoppingDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  final String city;

  const ShoppingDetailsScreen({
    super.key,
    required this.product,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FC),
      appBar: AppBar(
        title: const Text('Shopping Details'),
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
              product['image'] as String,
              height: 245,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 245,
                color: const Color(0xFFECE5FA),
                child: const Icon(
                  Icons.shopping_bag_rounded,
                  size: 60,
                  color: Color(0xFF7652C8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            product['name'] as String,
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
                Icons.sell_outlined,
                color: Color(0xFF7652C8),
              ),
              const SizedBox(width: 4),
              Text(
                product['price'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'About this product',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF28223A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product['description'] as String,
            style: const TextStyle(
              fontSize: 15,
              height: 1.7,
              color: Color(0xFF5F596D),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Shopping tip',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF28223A),
            ),
          ),
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
                    product['tip'] as String,
                    style: const TextStyle(height: 1.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFF0E9FC),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFF7652C8),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'This is a travel inspiration guide. It does not list verified shop addresses or live prices.',
                    style: TextStyle(height: 1.5),
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
