
import 'package:flutter/material.dart';

class BudgetPlannerScreen extends StatefulWidget {
  final String country;
  final String city;
  final int numberOfDays;
  final String budget;

  const BudgetPlannerScreen({
    super.key,
    required this.country,
    required this.city,
    required this.numberOfDays,
    required this.budget,
  });

  @override
  State<BudgetPlannerScreen> createState() =>
      _BudgetPlannerScreenState();
}

class _BudgetPlannerScreenState extends State<BudgetPlannerScreen> {
  static const Color purple = Color(0xFF7653D6);
  static const Color background = Color(0xFFF7F5FC);
  static const Color ink = Color(0xFF29233A);

  final List<Map<String, dynamic>> expenses = [
    {
      'name': 'Accommodation',
      'description': 'Hotels and stays',
      'icon': Icons.hotel_rounded,
      'color': const Color(0xFF7653D6),
      'amount': 300.0,
    },
    {
      'name': 'Food & Dining',
      'description': 'Meals and drinks',
      'icon': Icons.restaurant_rounded,
      'color': const Color(0xFFE49A55),
      'amount': 150.0,
    },
    {
      'name': 'Transport',
      'description': 'Local travel and taxis',
      'icon': Icons.directions_car_rounded,
      'color': const Color(0xFF4D9CBB),
      'amount': 100.0,
    },
    {
      'name': 'Activities',
      'description': 'Tickets and experiences',
      'icon': Icons.local_activity_rounded,
      'color': const Color(0xFF51A99B),
      'amount': 120.0,
    },
    {
      'name': 'Shopping',
      'description': 'Souvenirs and gifts',
      'icon': Icons.shopping_bag_rounded,
      'color': const Color(0xFFD879A2),
      'amount': 80.0,
    },
  ];

  double get totalExpenses => expenses.fold<double>(
        0,
        (sum, item) => sum + (item['amount'] as double),
      );

  double get dailyExpenses {
    final days = widget.numberOfDays;
    return days > 0 ? totalExpenses / days : totalExpenses;
  }

  double get plannedBudget {
    final cleaned = widget.budget.replaceAll(',', '').trim();
    final match = RegExp(r'\d+(\.\d+)?').firstMatch(cleaned);
    if (match == null) return 1500;
    final parsed = double.tryParse(match.group(0)!);
    return parsed != null && parsed > 0 ? parsed : 1500;
  }

  double get remainingBudget => plannedBudget - totalExpenses;

  double get progress {
    if (plannedBudget <= 0) return 0;
    return (totalExpenses / plannedBudget).clamp(0.0, 1.0);
  }

  String money(double amount) => '\$${amount.toStringAsFixed(0)}';

  void changeAmount(int index, double change) {
    setState(() {
      final current = expenses[index]['amount'] as double;
      expenses[index]['amount'] =
          (current + change).clamp(0.0, 100000.0).toDouble();
    });
  }

  void editAmount(int index) {
    final controller = TextEditingController(
      text: (expenses[index]['amount'] as double).toStringAsFixed(0),
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(expenses[index]['name'] as String),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          decoration: const InputDecoration(
            labelText: 'Estimated amount (USD)',
            prefixText: '\$ ',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: purple,
            ),
            onPressed: () {
              final value = double.tryParse(controller.text.trim());
              if (value == null || value < 0) return;
              setState(() {
                expenses[index]['amount'] = value;
              });
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Budget Planner',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: purple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          _buildBudgetCard(),
          const SizedBox(height: 25),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Expense breakdown',
                  style: TextStyle(
                    color: ink,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFECE5FC),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '${expenses.length} categories',
                  style: const TextStyle(
                    color: purple,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          const Text(
            'Adjust the estimates to match your travel style.',
            style: TextStyle(
              color: Color(0xFF777184),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            expenses.length,
            (index) => _buildExpenseCard(index),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(23),
              border: Border.all(color: const Color(0xFFE9E2F6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trip cost overview',
                  style: TextStyle(
                    color: ink,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                _summaryRow('Destination', widget.city),
                _summaryRow('Country', widget.country),
                _summaryRow('Trip duration', '${widget.numberOfDays} days'),
                const Divider(height: 25),
                _summaryRow(
                  'Estimated total',
                  money(totalExpenses),
                  bold: true,
                ),
                _summaryRow(
                  'Estimated per day',
                  money(dailyExpenses),
                  bold: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 54,
            child: FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Your budget summary is ready to review!',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.check_circle_outline_rounded),
              label: const Text(
                'Review My Budget',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Illustrative estimates in USD. Actual travel costs vary by destination.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF91899F),
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCard() {
    final isOverBudget = remainingBudget < 0;

    return Container(
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6442C4),
            Color(0xFF8C6BE7),
            Color(0xFFA996F2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(alpha: 0.23),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white70,
                size: 22,
              ),
              SizedBox(width: 9),
              Text(
                'YOUR TRAVEL BUDGET',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            widget.city.isEmpty ? 'Your next adventure' : widget.city,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${widget.numberOfDays} days  •  ${widget.country}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'ESTIMATED SPENDING',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
              letterSpacing: 1.1,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            money(totalExpenses),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 37,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverBudget
                    ? const Color(0xFFFFC0B8)
                    : const Color(0xFFFFE49A),
              ),
            ),
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Planned budget',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              Text(
                money(plannedBudget),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Icon(
                  isOverBudget
                      ? Icons.warning_amber_rounded
                      : Icons.savings_outlined,
                  color: isOverBudget
                      ? const Color(0xFFFFD4C9)
                      : const Color(0xFFFFE49A),
                  size: 26,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isOverBudget ? 'Over planned budget' : 'Budget remaining',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        money(remainingBudget.abs()),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseCard(int index) {
    final item = expenses[index];
    final color = item['color'] as Color;
    final amount = item['amount'] as double;

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF0ECF7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(item['icon'] as IconData, color: color, size: 26),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] as String,
                      style: const TextStyle(
                        color: ink,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['description'] as String,
                      style: const TextStyle(
                        color: Color(0xFF91899F),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit amount',
                onPressed: () => editAmount(index),
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 19,
                  color: purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Text(
                money(amount),
                style: const TextStyle(
                  color: ink,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              _amountButton(
                icon: Icons.remove,
                onTap: () => changeAmount(index, -25),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'USD',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              _amountButton(
                icon: Icons.add,
                onTap: () => changeAmount(index, 25),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _amountButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFFF0ECF9),
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: SizedBox(
          width: 36,
          height: 34,
          child: Icon(icon, size: 18, color: purple),
        ),
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: bold ? ink : const Color(0xFF777184),
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: ink,
                fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
