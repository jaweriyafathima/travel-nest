import 'dart:async';

import 'package:flutter/material.dart';

import 'personalized_trip_dashboard_screen.dart';

class AIProcessingScreen extends StatefulWidget {
  final String country;
  final String city;
  final int numberOfDays;
  final String budget;
  final String travelWith;
  final String interests;
  final String foodPreference;
  final String travelStyle;

  const AIProcessingScreen({
    super.key,
    required this.country,
    required this.city,
    required this.numberOfDays,
    required this.budget,
    required this.travelWith,
    required this.interests,
    required this.foodPreference,
    required this.travelStyle,
  });

  @override
  State<AIProcessingScreen> createState() =>
      _AIProcessingScreenState();
}

class _AIProcessingScreenState
    extends State<AIProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  Timer? _timer;

  int currentStep = 0;

  final List<String> processingSteps = [
    'Understanding your travel preferences...',
    'Finding the best places to visit...',
    'Checking food and experiences...',
    'Creating your personalized itinerary...',
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _startProcessing();
  }

  void _startProcessing() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 700),
      (timer) {
        if (!mounted) return;

        if (currentStep < processingSteps.length - 1) {
          setState(() {
            currentStep++;
          });
        } else {
          timer.cancel();

          _goToDashboard();
        }
      },
    );
  }

  void _goToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PersonalizedTripDashboardScreen(
          country: widget.country,
          city: widget.city,
          numberOfDays: widget.numberOfDays,
          budget: widget.budget,
          travelWith: widget.travelWith,
          interests: widget.interests,
          foodPreference: widget.foodPreference,
          travelStyle: widget.travelStyle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6FC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ---------------------------------------------
                // AI LABEL
                // ---------------------------------------------

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE4F8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 18,
                        color: Color(0xFF7B2CBF),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'TRAVEL NEST AI',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Color(0xFF5B3A78),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // ---------------------------------------------
                // ROBOT
                // ---------------------------------------------

                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final scale =
                        1.0 +
                        (_animationController.value * 0.05);

                    return Transform.scale(
                      scale: scale,
                      child: child,
                    );
                  },
                  child: Container(
                    height: 145,
                    width: 145,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFE7FA),
                      borderRadius: BorderRadius.circular(38),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7B2CBF)
                              .withOpacity(0.12),
                          blurRadius: 25,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.smart_toy_rounded,
                      size: 82,
                      color: Color(0xFF6C2BB9),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ---------------------------------------------
                // TITLE
                // ---------------------------------------------

                const Text(
                  'Creating Your Perfect Trip',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF29213A),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Our AI is planning your journey to ${widget.city}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 35),

                // ---------------------------------------------
                // PROGRESS BAR
                // ---------------------------------------------

                SizedBox(
                  width: 260,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      minHeight: 8,
                      value:
                          (currentStep + 1) /
                          processingSteps.length,
                      backgroundColor:
                          const Color(0xFFE4DCEB),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(
                        Color(0xFF7B2CBF),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // ---------------------------------------------
                // PROCESSING TEXT
                // ---------------------------------------------

                AnimatedSwitcher(
                  duration:
                      const Duration(milliseconds: 250),
                  child: Text(
                    processingSteps[currentStep],
                    key: ValueKey(currentStep),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),

                const SizedBox(height: 45),

                // ---------------------------------------------
                // DESTINATION
                // ---------------------------------------------

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFF7B2CBF),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.city}, ${widget.country}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF40374D),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Text(
                  'Please wait while Travel Nest AI prepares your trip ✨',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}