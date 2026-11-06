
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'famous_places_screen.dart';
import 'street_food_screen.dart';
import 'shopping_screen.dart';
import 'map_distance_screen.dart';
import 'budget_planner_screen.dart';
import 'ai_itinerary_screen.dart';
import 'ai_photo_guide_screen.dart';
import 'weather_screen.dart';
import 'additional_features_screen.dart';

class PersonalizedTripDashboardScreen extends StatefulWidget {
  final String country;
  final String city;
  final dynamic numberOfDays;
  final dynamic budget;
  final String travelWith;
  final dynamic interests;
  final String foodPreference;
  final String travelStyle;

  const PersonalizedTripDashboardScreen({
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
  State<PersonalizedTripDashboardScreen> createState() =>
      _PersonalizedTripDashboardScreenState();
}

class _PersonalizedTripDashboardScreenState
    extends State<PersonalizedTripDashboardScreen> {
  bool isSaving = false;

  static const Color purple = Color(0xFF7355A5);
  static const Color background = Color(0xFFF8F5FC);

  void openScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  Future<void> completeTrip() async {
    if (isSaving) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in first.')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_trips')
          .add({
        'country': widget.country,
        'city': widget.city,
        'numberOfDays': widget.numberOfDays,
        'budget': widget.budget,
        'travelWith': widget.travelWith,
        'interests': widget.interests,
        'foodPreference': widget.foodPreference,
        'travelStyle': widget.travelStyle,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'completed',
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trip saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not save trip: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  Widget detailChip(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget tripHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF8065B5),
            Color(0xFFB28BCB),
            Color(0xFFE4A6BD),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'YOUR PERSONALIZED TRIP',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${widget.city}, ${widget.country}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 9,
            runSpacing: 9,
            children: [
              detailChip(
                Icons.calendar_month,
                '${widget.numberOfDays} days',
              ),
              detailChip(
                Icons.currency_rupee,
                '${widget.budget}',
              ),
              detailChip(
                Icons.people,
                widget.travelWith,
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'Your travel experience is ready! Explore the features below and enjoy planning your journey.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget featureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 47,
                width: 47,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: purple,
                  size: 26,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF302442),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 7),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Explore',
                    style: TextStyle(
                      color: purple,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    color: purple,
                    size: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Your Trip Dashboard',
          style: TextStyle(
            color: Color(0xFF302442),
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: purple),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(17, 8, 17, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tripHeader(),

                    const SizedBox(height: 24),

                    const Text(
                      'Explore Your Trip',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF302442),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Discover useful travel features for ${widget.city}.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 13,
                      mainAxisSpacing: 13,
                      childAspectRatio: 0.91,
                      children: [
                        featureCard(
                          icon: Icons.auto_awesome,
                          title: 'AI Itinerary',
                          description: 'View your AI-generated daily travel plan.',
                          color: const Color(0xFFECE3FF),
                          onTap: () {
                            openScreen(
                              AIItineraryScreen(
                                country: widget.country,
                                city: widget.city,
                                numberOfDays: widget.numberOfDays,
                                budget: widget.budget,
                                travelWith: widget.travelWith,
                                interests: widget.interests,
                                foodPreference: widget.foodPreference,
                                travelStyle: widget.travelStyle,
                              ),
                            );
                          },
                        ),

                        featureCard(
                          icon: Icons.place,
                          title: 'Famous Places',
                          description: 'Discover attractions and landmarks.',
                          color: const Color(0xFFFFE5EC),
                          onTap: () {
                            openScreen(
                              FamousPlacesScreen(
                                city: widget.city,
                                country: widget.country,
                              ),
                            );
                          },
                        ),

                        featureCard(
                          icon: Icons.restaurant,
                          title: 'Street Food',
                          description: 'Explore local food and famous dishes.',
                          color: const Color(0xFFFFEBD5),
                          onTap: () {
                            openScreen(
                              StreetFoodScreen(
                                city: widget.city,
                                country: widget.country,
                              ),
                            );
                          },
                        ),

                        featureCard(
                          icon: Icons.shopping_bag,
                          title: 'Shopping Places',
                          description: 'Find markets and shopping destinations.',
                          color: const Color(0xFFE0F4EA),
                          onTap: () {
                            openScreen(
                              ShoppingScreen(
                                city: widget.city,
                                country: widget.country,
                              ),
                            );
                          },
                        ),

                        featureCard(
                          icon: Icons.map,
                          title: 'Map & Distance',
                          description: 'Explore locations and distances.',
                          color: const Color(0xFFE1ECFF),
                          onTap: () {
                            openScreen(
                              MapDistanceScreen(
                                city: widget.city,
                                country: widget.country,
                              ),
                            );
                          },
                        ),

                        featureCard(
                          icon: Icons.account_balance_wallet,
                          title: 'Budget Planner',
                          description: 'Manage your estimated trip expenses.',
                          color: const Color(0xFFFFF1CC),
                          onTap: () {
                            openScreen(
                              BudgetPlannerScreen(
                                country: widget.country,
                                city: widget.city,
                                numberOfDays: widget.numberOfDays,
                                budget: widget.budget,
                              ),
                            );
                          },
                        ),

                        featureCard(
                          icon: Icons.camera_alt,
                          title: 'AI Photo Guide',
                          description: 'Get photo ideas and travel poses.',
                          color: const Color(0xFFFFE4F0),
                          onTap: () {
                            openScreen(
                              AIPhotoGuideScreen(
                                city: widget.city,
                                country: widget.country,
                              ),
                            );
                          },
                        ),

                        featureCard(
                          icon: Icons.cloud,
                          title: 'Weather',
                          description: 'Check weather information for your destination.',
                          color: const Color(0xFFE1F3FF),
                          onTap: () {
                            openScreen(
                              WeatherScreen(
                                city: widget.city,
                                country: widget.country,
                              ),
                            );
                          },
                        ),

                        featureCard(
                          icon: Icons.support_agent,
                          title: 'Smart Travel Assistance',
                          description: 'Emergency help, currency converter, packing and smart tools.',
                          color: const Color(0xFFECE3FF),
                          onTap: () {
                            openScreen(
                              const AdditionalFeaturesScreen(),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECE3FF),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.lightbulb,
                            color: purple,
                            size: 28,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Explore all the features before completing your trip.',
                              style: TextStyle(
                                color: Color(0xFF49345F),
                                fontSize: 13,
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
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: isSaving ? null : completeTrip,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    disabledBackgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: isSaving
                      ? const SizedBox(
                          height: 23,
                          width: 23,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            ),
                            SizedBox(width: 9),
                            Text(
                              'DONE - SAVE MY TRIP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
