import 'package:flutter/material.dart';

import 'personalized_trip_dashboard_screen.dart';

class TripPlanningScreen extends StatefulWidget {
  const TripPlanningScreen({super.key});

  @override
  State<TripPlanningScreen> createState() => _TripPlanningScreenState();
}

class _TripPlanningScreenState extends State<TripPlanningScreen> {
  String? selectedCountry;
  String? selectedCity;
  int? selectedDays;
  String? selectedBudget;
  String? selectedTravelWith;
  String? selectedInterest;
  String? selectedFood;
  String? selectedStyle;

  final Color purple = const Color(0xFF7B2CBF);

  final Map<String, List<String>> countryCities = {
    'Japan': [
      'Tokyo',
      'Osaka',
      'Kyoto',
      'Sapporo',
    ],
    'France': [
      'Paris',
      'Nice',
      'Lyon',
      'Marseille',
    ],
    'Italy': [
      'Rome',
      'Milan',
      'Venice',
      'Florence',
    ],
    'Thailand': [
      'Bangkok',
      'Phuket',
      'Chiang Mai',
      'Pattaya',
    ],
    'Switzerland': [
      'Zurich',
      'Geneva',
      'Lucerne',
      'Interlaken',
    ],
    'Australia': [
      'Sydney',
      'Melbourne',
      'Brisbane',
      'Gold Coast',
    ],
  };

  final List<String> countries = [
    'Japan',
    'France',
    'Italy',
    'Thailand',
    'Switzerland',
    'Australia',
  ];

  final List<int> days = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
  ];

  final List<String> budgets = [
    'Budget',
    'Moderate',
    'Luxury',
  ];

  final List<String> travelWithOptions = [
    'Solo',
    'Partner',
    'Friends',
    'Family',
  ];

  final List<String> interests = [
    'Sightseeing',
    'Adventure',
    'Nature',
    'Shopping',
    'Culture',
    'Relaxation',
  ];

  final List<String> foodOptions = [
    'Any Food',
    'Vegetarian',
    'Non-Vegetarian',
    'Vegan',
  ];

  final List<String> travelStyles = [
    'Relaxed',
    'Balanced',
    'Fast Paced',
  ];

  // ==========================================================
  // GENERATE TRIP
  // ==========================================================

  void _generateTrip() {
    if (selectedCountry == null ||
        selectedCity == null ||
        selectedDays == null ||
        selectedBudget == null ||
        selectedTravelWith == null ||
        selectedInterest == null ||
        selectedFood == null ||
        selectedStyle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please complete all trip preferences.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalizedTripDashboardScreen(
          country: selectedCountry!,
          city: selectedCity!,
          numberOfDays: selectedDays!,
          budget: selectedBudget!,
          travelWith: selectedTravelWith!,
          interests: selectedInterest!,
          foodPreference: selectedFood!,
          travelStyle: selectedStyle!,
        ),
      ),
    );
  }

  // ==========================================================
  // SECTION TITLE
  // ==========================================================

  Widget _sectionTitle(
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Color(0xFF29213A),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // DROPDOWN
  // ==========================================================

  Widget _dropdownBox<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required ValueChanged<T?>? onChanged,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Row(
            children: [
              Icon(
                icon,
                color: purple,
              ),
              const SizedBox(width: 12),
              Text(
                hint,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: purple,
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                item.toString(),
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF30263D),
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ==========================================================
  // OPTION CARD
  // ==========================================================

  Widget _optionCard({
    required String title,
    required String value,
    required String? selectedValue,
    required IconData icon,
    required Function(String) onTap,
  }) {
    final bool isSelected = value == selectedValue;

    return GestureDetector(
      onTap: () {
        onTap(value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF1E5FF)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? purple
                : Colors.grey.shade200,
            width: isSelected ? 1.7 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.035),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? purple
                  : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.w500,
                  color: isSelected
                      ? purple
                      : const Color(0xFF40394D),
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                size: 19,
                color: purple,
              ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // OPTION GRID
  // ==========================================================

  Widget _optionGrid(
    List<Widget> children,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.7,
      children: children,
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6FC),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF29213A),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Plan Your Trip',
          style: TextStyle(
            color: Color(0xFF29213A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            35,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =================================================
              // HEADER
              // =================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFEBDDFF),
                      Color(0xFFFCE7F3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 58,
                      width: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.flight_takeoff_rounded,
                        color: purple,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Plan your perfect trip ✨',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF30263D),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Tell us your preferences and let AI plan it for you.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // =================================================
              // COUNTRY
              // =================================================

              _sectionTitle(
                'Choose your country',
                'Where would you like to travel?',
              ),

              const SizedBox(height: 14),

              _dropdownBox<String>(
                hint: 'Select Country',
                value: selectedCountry,
                items: countries,
                icon: Icons.public_rounded,
                onChanged: (value) {
                  setState(() {
                    selectedCountry = value;
                    selectedCity = null;
                  });
                },
              ),

              const SizedBox(height: 28),

              // =================================================
              // CITY
              // =================================================

              _sectionTitle(
                'Choose your city',
                'Select the city you want to explore.',
              ),

              const SizedBox(height: 14),

              _dropdownBox<String>(
                hint: selectedCountry == null
                    ? 'Select country first'
                    : 'Select City',
                value: selectedCity,
                items: selectedCountry == null
                    ? <String>[]
                    : countryCities[selectedCountry!] ?? <String>[],
                icon: Icons.location_city_rounded,
                onChanged: selectedCountry == null
                    ? null
                    : (value) {
                        setState(() {
                          selectedCity = value;
                        });
                      },
              ),

              const SizedBox(height: 28),

              // =================================================
              // DAYS
              // =================================================

              _sectionTitle(
                'How many days?',
                'Choose the duration of your trip.',
              ),

              const SizedBox(height: 14),

              _dropdownBox<int>(
                hint: 'Select number of days',
                value: selectedDays,
                items: days,
                icon: Icons.calendar_month_rounded,
                onChanged: (value) {
                  setState(() {
                    selectedDays = value;
                  });
                },
              ),

              const SizedBox(height: 28),

              // =================================================
              // BUDGET
              // =================================================

              _sectionTitle(
                'What is your budget?',
                'Choose a budget that suits your travel style.',
              ),

              const SizedBox(height: 14),

              _optionGrid([
                _optionCard(
                  title: 'Budget',
                  value: 'Budget',
                  selectedValue: selectedBudget,
                  icon: Icons.savings_outlined,
                  onTap: (value) {
                    setState(() {
                      selectedBudget = value;
                    });
                  },
                ),
                _optionCard(
                  title: 'Moderate',
                  value: 'Moderate',
                  selectedValue: selectedBudget,
                  icon: Icons.account_balance_wallet_outlined,
                  onTap: (value) {
                    setState(() {
                      selectedBudget = value;
                    });
                  },
                ),
                _optionCard(
                  title: 'Luxury',
                  value: 'Luxury',
                  selectedValue: selectedBudget,
                  icon: Icons.diamond_outlined,
                  onTap: (value) {
                    setState(() {
                      selectedBudget = value;
                    });
                  },
                ),
              ]),

              const SizedBox(height: 28),

              // =================================================
              // TRAVEL WITH
              // =================================================

              _sectionTitle(
                'Who are you travelling with?',
                'Tell us who will join your journey.',
              ),

              const SizedBox(height: 14),

              _optionGrid([
                _optionCard(
                  title: 'Solo',
                  value: 'Solo',
                  selectedValue: selectedTravelWith,
                  icon: Icons.person_outline_rounded,
                  onTap: (value) {
                    setState(() {
                      selectedTravelWith = value;
                    });
                  },
                ),
                _optionCard(
                  title: 'Partner',
                  value: 'Partner',
                  selectedValue: selectedTravelWith,
                  icon: Icons.favorite_border_rounded,
                  onTap: (value) {
                    setState(() {
                      selectedTravelWith = value;
                    });
                  },
                ),
                _optionCard(
                  title: 'Friends',
                  value: 'Friends',
                  selectedValue: selectedTravelWith,
                  icon: Icons.groups_outlined,
                  onTap: (value) {
                    setState(() {
                      selectedTravelWith = value;
                    });
                  },
                ),
                _optionCard(
                  title: 'Family',
                  value: 'Family',
                  selectedValue: selectedTravelWith,
                  icon: Icons.family_restroom_rounded,
                  onTap: (value) {
                    setState(() {
                      selectedTravelWith = value;
                    });
                  },
                ),
              ]),

              const SizedBox(height: 28),

              // =================================================
              // INTEREST
              // =================================================

              _sectionTitle(
                'What are you interested in?',
                'Choose what you enjoy most while travelling.',
              ),

              const SizedBox(height: 14),

              _optionGrid([
                _optionCard(
                  title: 'Sightseeing',
                  value: 'Sightseeing',
                  selectedValue: selectedInterest,
                  icon: Icons.photo_camera_outlined,
                  onTap: (value) {
                    setState(() {
                      selectedInterest = value;
                    });
                  },
                ),
                _optionCard(
                  title: 'Adventure',
                  value: 'Adventure',
                  selectedValue: selectedInterest,
                  icon: Icons.terrain_rounded,
                  onTap: (value) {
                    setState(() {
                      selectedInterest = value;
                    });
                  },
                ),
                _optionCard(
                  title: 'Nature',
                  value: 'Nature',
                  selectedValue: selectedInterest,
                  icon: Icons.park_outlined,
                  onTap: (value) {
                    setState(() {
                      selectedInterest = value;
                    });
                  },
                ),
                _optionCard(
                  title: 'Shopping',
                  value: 'Shopping',
                  selectedValue: selectedInterest,
                  icon: Icons.shopping_bag_outlined,
                  onTap: (value) {
                    setState(() {
                      selectedInterest = value;
                    });
                  },
                ),
                _optionCard(
                  title: 'Culture',
                  value: 'Culture',
                  selectedValue: selectedInterest,
                  icon: Icons.museum_outlined,
                  onTap: (value) {
                    setState(() {
                      selectedInterest = value;
                    });
                  },
                ),
                _optionCard(
                  title: 'Relaxation',
                  value: 'Relaxation',
                  selectedValue: selectedInterest,
                  icon: Icons.spa_outlined,
                  onTap: (value) {
                    setState(() {
                      selectedInterest = value;
                    });
                  },
                ),
              ]),

              const SizedBox(height: 28),

              // =================================================
              // FOOD
              // =================================================

              _sectionTitle(
                'Food preference',
                'Choose the type of food you prefer.',
              ),

              const SizedBox(height: 14),

              _optionGrid([
                _optionCard(
                  title: 'Any Food',
                  value: 'Any Food',
                  selectedValue: selectedFood,
                  icon: Icons.restaurant_outlined,
                  onTap: (value) {
                    setState(() {
                      selectedFood = value;
                    });
                  },
                ),
                _optionCard(
                  title: 'Vegetarian',
                  value: 'Vegetarian',
                  selectedValue: selectedFood,
                  icon: Icons.eco_outlined,
                  onTap: (value) {
                    setState(() {
                      selectedFood = value;
                    });
                  },
                ),
                _optionCard(
                  title: 'Non-Vegetarian',
                  value: 'Non-Vegetarian',
                  selectedValue: selectedFood,
                  icon: Icons.dinner_dining_outlined,
                  onTap: (value) {
                    setState(() {
                      selectedFood = value;
                    });
                  },
                ),
                _optionCard(
                  title: 'Vegan',
                  value: 'Vegan',
                  selectedValue: selectedFood,
                  icon: Icons.grass_outlined,
                  onTap: (value) {
                    setState(() {
                      selectedFood = value;
                    });
                  },
                ),
              ]),

              const SizedBox(height: 28),

              // =================================================
              // TRAVEL STYLE
              // =================================================

              _sectionTitle(
                'Travel style',
                'How would you like your trip to feel?',
              ),

              const SizedBox(height: 14),

              _optionGrid([
                _optionCard(
                  title: 'Relaxed',
                  value: 'Relaxed',
                  selectedValue: selectedStyle,
                  icon: Icons.self_improvement_rounded,
                  onTap: (value) {
                    setState(() {
                      selectedStyle = value;
                    });
                  },
                ),
                _optionCard(
                  title: 'Balanced',
                  value: 'Balanced',
                  selectedValue: selectedStyle,
                  icon: Icons.balance_rounded,
                  onTap: (value) {
                    setState(() {
                      selectedStyle = value;
                    });
                  },
                ),
                _optionCard(
                  title: 'Fast Paced',
                  value: 'Fast Paced',
                  selectedValue: selectedStyle,
                  icon: Icons.speed_rounded,
                  onTap: (value) {
                    setState(() {
                      selectedStyle = value;
                    });
                  },
                ),
              ]),

              const SizedBox(height: 35),

              // =================================================
              // CREATE TRIP BUTTON
              // =================================================

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _generateTrip,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 22,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Create My Travel Plan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: Text(
                  '✨ AI will create a personalized trip for you',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
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