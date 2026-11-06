import 'package:flutter/material.dart';

import 'signup_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6FC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 20,
            ),
            child: Column(
              children: [

                // =====================================================
                // TOP TITLE
                // =====================================================

                const SizedBox(height: 25),

                const Text(
                  'Your next adventure\nstarts here ✈️',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    color: Color(0xFF29213A),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Discover beautiful places and create unforgettable memories.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 35),

                // =====================================================
                // TRAVEL IMAGE
                // =====================================================

                Container(
                  height: 210,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=1200&q=80',
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFEDE4F7),
                          child: const Icon(
                            Icons.travel_explore_rounded,
                            size: 70,
                            color: Color(0xFF7B2CBF),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // =====================================================
                // MAIN TITLE
                // =====================================================

                const Text(
                  'Plan Smart. Travel Better.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF29213A),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Let Travel Nest help you discover destinations, '
                  'plan your perfect trip and experience the world.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 30),

                // =====================================================
                // FEATURES
                // =====================================================

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    _featureItem(
                      icon: Icons.explore_outlined,
                      title: 'Explore',
                      subtitle: 'Destinations',
                    ),

                    _featureItem(
                      icon: Icons.auto_awesome,
                      title: 'AI Plan',
                      subtitle: 'Smart Trips',
                    ),

                    _featureItem(
                      icon: Icons.map_outlined,
                      title: 'Discover',
                      subtitle: 'New Places',
                    ),
                  ],
                ),

                const SizedBox(height: 38),

                // =====================================================
                // GET STARTED BUTTON
                // =====================================================

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SignupScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF7B2CBF),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor:
                          const Color(0xFF7B2CBF)
                              .withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // =====================================================
                // LOGIN BUTTON
                // =====================================================

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          const Color(0xFF7B2CBF),
                      side: const BorderSide(
                        color: Color(0xFFBBA6D9),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'I Already Have an Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // =====================================================
                // FOOTER
                // =====================================================

                Text(
                  'AI Powered Travel Planner',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // FEATURE ITEM
  // ===============================================================

  Widget _featureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFEDE5F8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF7B2CBF),
            size: 26,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF40374D),
          ),
        ),

        const SizedBox(height: 3),

        Text(
          subtitle,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}