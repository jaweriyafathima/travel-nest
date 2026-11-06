
import 'package:flutter/material.dart';

class AdditionalFeaturesScreen extends StatefulWidget {
  const AdditionalFeaturesScreen({super.key});

  @override
  State<AdditionalFeaturesScreen> createState() =>
      _AdditionalFeaturesScreenState();
}

class _AdditionalFeaturesScreenState
    extends State<AdditionalFeaturesScreen> {
  static const Color purple = Color(0xFF7356C9);
  static const Color background = Color(0xFFF8F5FC);

  final TextEditingController amountController =
      TextEditingController(text: '100');

  String fromCurrency = 'USD';
  String toCurrency = 'INR';
  double convertedAmount = 0;

  final Map<String, double> rates = {
    'USD': 1,
    'INR': 83.5,
    'EUR': 0.92,
    'GBP': 0.79,
    'JPY': 149.5,
  };

  final List<String> packingItems = [
    'Travel documents and ID',
    'Clothes and footwear',
    'Mobile phone and charger',
    'Power bank',
    'Toiletries',
    'Medicines and first aid',
    'Sunglasses and sunscreen',
    'Travel accessories',
  ];

  final Set<String> packedItems = {};

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void convertCurrency() {
    final amount = double.tryParse(amountController.text);

    if (amount == null || amount < 0) {
      showMessage('Please enter a valid amount.');
      return;
    }

    setState(() {
      convertedAmount =
          amount / rates[fromCurrency]! * rates[toCurrency]!;
    });
  }

  Widget featureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(19),
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 49,
              width: 49,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 25),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF34263F),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Smart Travel Tools',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: purple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 25),

            _title('Travel Assistance'),
            const SizedBox(height: 13),

            featureCard(
              icon: Icons.emergency_rounded,
              title: 'Emergency Assistance',
              description: 'Important emergency contacts and safety tips',
              color: Colors.red,
              onTap: () => _showEmergency(),
            ),
            const SizedBox(height: 12),

            featureCard(
              icon: Icons.currency_exchange_rounded,
              title: 'Currency Converter',
              description: 'Convert between popular currencies',
              color: Colors.green,
              onTap: () => _showCurrencyConverter(),
            ),
            const SizedBox(height: 12),

            featureCard(
              icon: Icons.rate_review_rounded,
              title: 'Review Summary',
              description: 'Write and view your travel experience',
              color: Colors.orange,
              onTap: () => _showReview(),
            ),
            const SizedBox(height: 12),

            featureCard(
              icon: Icons.notifications_active_rounded,
              title: 'Smart Alerts',
              description: 'Travel reminders and important updates',
              color: Colors.blue,
              onTap: () => _showAlerts(),
            ),
            const SizedBox(height: 12),

            featureCard(
              icon: Icons.backpack_rounded,
              title: 'Packing Assistant',
              description: 'Prepare your travel packing checklist',
              color: purple,
              onTap: () => _showPacking(),
            ),
            const SizedBox(height: 25),

            _title('Quick Travel Tip'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF7862CE),
                    Color(0xFFAA88E6),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.white,
                    size: 29,
                  ),
                  SizedBox(width: 13),
                  Expanded(
                    child: Text(
                      'Keep your travel documents, emergency contacts and important belongings ready before starting your journey.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.5,
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

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7356C9),
            Color(0xFFA786E4),
          ],
        ),
        borderRadius: BorderRadius.circular(23),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.travel_explore_rounded,
            color: Colors.white,
            size: 35,
          ),
          SizedBox(height: 13),
          Text(
            'Travel Smarter!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Everything you need for a safer and easier journey.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
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
        color: Color(0xFF34263F),
      ),
    );
  }

  void _showEmergency() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Emergency Assistance',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 13),
              const Text(
                'Keep these contacts ready before travelling. Emergency numbers vary by country.',
              ),
              const SizedBox(height: 15),
              _emergencyRow(
                Icons.local_police,
                'Police',
                'Use the verified local emergency number',
              ),
              _emergencyRow(
                Icons.local_hospital,
                'Medical assistance',
                'Find the nearest hospital or emergency service',
              ),
              _emergencyRow(
                Icons.contact_phone,
                'Trusted contact',
                'Keep your family contact information available',
              ),
              const SizedBox(height: 12),
              const Text(
                'This is an informational screen. Live emergency calling and location services are not connected yet.',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emergencyRow(
    IconData icon,
    String title,
    String description,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(title),
      subtitle: Text(description),
    );
  }

  void _showCurrencyConverter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, updateSheet) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                22,
                22,
                22,
                MediaQuery.of(context).viewInsets.bottom + 22,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Currency Converter',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Enter amount',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: fromCurrency,
                            decoration: const InputDecoration(
                              labelText: 'From',
                              border: OutlineInputBorder(),
                            ),
                            items: rates.keys.map((currency) {
                              return DropdownMenuItem(
                                value: currency,
                                child: Text(currency),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                updateSheet(() => fromCurrency = value);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: toCurrency,
                            decoration: const InputDecoration(
                              labelText: 'To',
                              border: OutlineInputBorder(),
                            ),
                            items: rates.keys.map((currency) {
                              return DropdownMenuItem(
                                value: currency,
                                child: Text(currency),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                updateSheet(() => toCurrency = value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final amount = double.tryParse(
                            amountController.text,
                          );

                          if (amount == null || amount < 0) {
                            return;
                          }

                          updateSheet(() {
                            convertedAmount = amount /
                                rates[fromCurrency]! *
                                rates[toCurrency]!;
                          });
                        },
                        child: const Text('Convert'),
                      ),
                    ),
                    const SizedBox(height: 13),
                    Text(
                      'Converted amount: ${convertedAmount.toStringAsFixed(2)} $toCurrency',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0xFF7356C9),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Preview only: exchange rates are sample values, not live market rates.',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showReview() {
    final controller = TextEditingController();
    int rating = 5;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, updateDialog) => AlertDialog(
          title: const Text('Your Travel Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('How was your travel experience?'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      updateDialog(() => rating = index + 1);
                    },
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                  );
                }),
              ),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Write your experience...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                showMessage(
                  'Review preview: $rating stars. Firebase storage will be connected later.',
                );
                controller.dispose();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlerts() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Smart Travel Alerts',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.flight, color: Colors.blue),
                title: Text('Flight reminder'),
                subtitle: Text('Check your departure details before travel.'),
              ),
              ListTile(
                leading: Icon(Icons.cloud, color: Colors.orange),
                title: Text('Weather update'),
                subtitle: Text('Check the forecast before outdoor activities.'),
              ),
              ListTile(
                leading: Icon(Icons.calendar_month, color: Colors.green),
                title: Text('Trip reminder'),
                subtitle: Text('Review your itinerary and reservations.'),
              ),
              Text(
                'Automatic notifications will be connected later.',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPacking() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, updateSheet) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Packing Assistant',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('${packedItems.length}/${packingItems.length} items packed'),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: packedItems.length / packingItems.length,
                    color: purple,
                    backgroundColor: Colors.grey.shade200,
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: packingItems.map((item) {
                        return CheckboxListTile(
                          title: Text(item),
                          value: packedItems.contains(item),
                          activeColor: purple,
                          onChanged: (checked) {
                            updateSheet(() {
                              if (checked == true) {
                                packedItems.add(item);
                              } else {
                                packedItems.remove(item);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
