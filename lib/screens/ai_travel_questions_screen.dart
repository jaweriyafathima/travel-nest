import 'package:flutter/material.dart';
import 'ai_processing_screen.dart';

class AITravelQuestionsScreen extends StatefulWidget {
  final String country;
  final String city;

  const AITravelQuestionsScreen({
    super.key,
    required this.country,
    required this.city,
  });

  @override
  State<AITravelQuestionsScreen> createState() =>
      _AITravelQuestionsScreenState();
}

class _AITravelQuestionsScreenState
    extends State<AITravelQuestionsScreen> {
  int numberOfDays = 3;

  String budget = 'Moderate';
  String travelWith = 'Friends';
  String interests = 'Sightseeing';
  String foodPreference = 'Any Food';
  String travelStyle = 'Balanced';

  final List<String> budgetOptions = [
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

  final List<String> interestOptions = [
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

  final List<String> travelStyleOptions = [
    'Relaxed',
    'Balanced',
    'Fast Paced',
  ];

  // Go to AI Processing Screen
  void generateTrip() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AIProcessingScreen(
          country: widget.country,
          city: widget.city,
          numberOfDays: numberOfDays,
          budget: budget,
          travelWith: travelWith,
          interests: interests,
          foodPreference: foodPreference,
          travelStyle: travelStyle,
        ),
      ),
    );
  }

  // Section heading
  Widget sectionTitle(
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF35204D),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // Dropdown
  Widget dropdownCard({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5D9F2),
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
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF7B2CBF),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4B3A59),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Selection chip
  Widget choiceChip({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 200,
        ),
        margin: const EdgeInsets.only(
          right: 8,
          bottom: 8,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF7B2CBF)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color(0xFF7B2CBF)
                : const Color(0xFFE2D8EC),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF7B2CBF)
                        .withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected
                ? Colors.white
                : const Color(0xFF4B3A59),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FC),

      // App Bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF35204D),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Plan Your Trip',
          style: TextStyle(
            color: Color(0xFF35204D),
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            35,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =========================================
              // AI HEADER
              // =========================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFEADCF8),
                      Color(0xFFFCE5EF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [

                    // AI Icon
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Color(0xFF7B2CBF),
                        size: 29,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Let AI plan your journey ✨',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF35204D),
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            '${widget.city}, ${widget.country}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // =========================================
              // TITLE
              // =========================================

              const Text(
                'Tell us about your trip',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF35204D),
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'Answer a few questions and Travel Nest AI will create a personalized travel experience for you.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              // =========================================
              // 1. NUMBER OF DAYS
              // =========================================

              sectionTitle(
                'How many days will you travel?',
                'Choose the duration of your trip.',
              ),

              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFE5D9F2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [

                    Text(
                      '$numberOfDays Days',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7B2CBF),
                      ),
                    ),

                    Slider(
                      value: numberOfDays.toDouble(),
                      min: 1,
                      max: 15,
                      divisions: 14,
                      activeColor:
                          const Color(0xFF7B2CBF),
                      inactiveColor:
                          const Color(0xFFE7DDF0),
                      onChanged: (value) {
                        setState(() {
                          numberOfDays =
                              value.round();
                        });
                      },
                    ),

                    const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '1 Day',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '15 Days',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // =========================================
              // 2. BUDGET
              // =========================================

              sectionTitle(
                'What is your budget?',
                'Choose the budget for your trip.',
              ),

              dropdownCard(
                value: budget,
                items: budgetOptions,
                onChanged: (value) {
                  setState(() {
                    budget = value!;
                  });
                },
              ),

              const SizedBox(height: 28),

              // =========================================
              // 3. TRAVEL WITH
              // =========================================

              sectionTitle(
                'Who are you travelling with?',
                'Tell us who will join your journey.',
              ),

              const SizedBox(height: 13),

              Wrap(
                children:
                    travelWithOptions.map((item) {
                  return choiceChip(
                    title: item,
                    selected:
                        travelWith == item,
                    onTap: () {
                      setState(() {
                        travelWith = item;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // =========================================
              // 4. INTERESTS
              // =========================================

              sectionTitle(
                'What are your interests?',
                'Choose what you would like to explore.',
              ),

              const SizedBox(height: 13),

              Wrap(
                children:
                    interestOptions.map((item) {
                  return choiceChip(
                    title: item,
                    selected:
                        interests == item,
                    onTap: () {
                      setState(() {
                        interests = item;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // =========================================
              // 5. FOOD PREFERENCE
              // =========================================

              sectionTitle(
                'What is your food preference?',
                'This helps us suggest suitable food.',
              ),

              dropdownCard(
                value: foodPreference,
                items: foodOptions,
                onChanged: (value) {
                  setState(() {
                    foodPreference = value!;
                  });
                },
              ),

              const SizedBox(height: 28),

              // =========================================
              // 6. TRAVEL STYLE
              // =========================================

              sectionTitle(
                'What is your travel style?',
                'Choose how you want your trip to feel.',
              ),

              const SizedBox(height: 13),

              Wrap(
                children:
                    travelStyleOptions.map((item) {
                  return choiceChip(
                    title: item,
                    selected:
                        travelStyle == item,
                    onTap: () {
                      setState(() {
                        travelStyle = item;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 35),

              // =========================================
              // CREATE TRIP BUTTON
              // =========================================

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: generateTrip,

                  icon: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 22,
                  ),

                  label: const Text(
                    'Create My Travel Plan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF7B2CBF),
                    elevation: 4,
                    shadowColor:
                        const Color(0xFF7B2CBF)
                            .withOpacity(0.3),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 13),

              // Bottom information
              const Center(
                child: Text(
                  '✨ Travel Nest AI will use your preferences to personalize your trip',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                    height: 1.4,
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