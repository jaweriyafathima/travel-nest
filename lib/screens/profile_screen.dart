
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/app_theme.dart';
import 'personalized_trip_dashboard_screen.dart';

// ============================================================
// PROFILE SCREEN
// ============================================================

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color purple = Color(0xFF7B2CBF);

  final User? user = FirebaseAuth.instance.currentUser;

  bool get isDark =>
      AppTheme.themeMode.value == ThemeMode.dark;

  Color get cardColor =>
      isDark ? const Color(0xFF292331) : Colors.white;

  Color get textColor =>
      isDark ? Colors.white : const Color(0xFF392D48);

  Color get subtitleColor =>
      isDark ? Colors.white60 : Colors.grey;

  void refreshScreen() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final name = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!
        : 'Traveler';

    final email = user?.email ?? 'No email available';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Profile & Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: textColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
        children: [
          // PROFILE HEADER
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7B2CBF),
                  Color(0xFFB565D9),
                ],
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 39,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person_rounded,
                    size: 43,
                    color: purple,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Travel Nest Member ✈',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 27),

          _sectionTitle('MY ACCOUNT'),

          _menuCard(
            icon: Icons.luggage_rounded,
            title: 'My Trips',
            subtitle: 'View your saved travel plans',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MyTripsPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 23),

          _sectionTitle('APP PREFERENCES'),

          _menuCard(
            icon: Icons.settings_rounded,
            title: 'Settings',
            subtitle: 'Manage your app preferences',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsPage(),
                ),
              );
            },
          ),

          _menuCard(
            icon: Icons.language_rounded,
            title: 'Language',
            subtitle: AppTheme.language,
            onTap: _showLanguageDialog,
          ),

          _menuCard(
            icon: Icons.currency_exchange_rounded,
            title: 'Currency',
            subtitle: AppTheme.currency,
            onTap: _showCurrencyDialog,
          ),

          _menuCard(
            icon: Icons.dark_mode_rounded,
            title: 'Dark Mode',
            subtitle: isDark ? 'Enabled' : 'Disabled',
            trailing: Switch(
              value: isDark,
              activeColor: purple,
              onChanged: (value) async {
                await AppTheme.setDarkMode(value);
                refreshScreen();
              },
            ),
            onTap: () async {
              await AppTheme.setDarkMode(!isDark);
              refreshScreen();
            },
          ),

          const SizedBox(height: 23),

          _sectionTitle('SUPPORT'),

          _menuCard(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            subtitle: 'FAQs and assistance',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HelpSupportPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 25),

          Center(
            child: Text(
              'TRAVEL NEST',
              style: TextStyle(
                color: subtitleColor,
                fontSize: 12,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 5),

          Center(
            child: Text(
              'Explore • Plan • Experience',
              style: TextStyle(
                color: subtitleColor,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 11,
        left: 4,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: subtitleColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: isDark
              ? Colors.white10
              : const Color(0xFFEDE5F5),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        leading: Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: purple.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: purple),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: subtitleColor,
            fontSize: 12,
          ),
        ),
        trailing: trailing ??
            Icon(
              Icons.chevron_right_rounded,
              color: subtitleColor,
            ),
      ),
    );
  }

  Future<void> _showLanguageDialog() async {
    const languages = [
      'English',
      'Hindi',
      'Tamil',
      'Telugu',
      'Kannada',
      'Malayalam',
    ];

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Choose Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((language) {
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: AppTheme.language,
                activeColor: purple,
                onChanged: (value) async {
                  if (value == null) return;

                  await AppTheme.setLanguage(value);

                  if (!dialogContext.mounted) return;

                  Navigator.pop(dialogContext);
                  refreshScreen();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$value selected'),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _showCurrencyDialog() async {
    const currencies = [
      'INR (₹)',
      'USD (\$)',
      'EUR (€)',
      'GBP (£)',
      'JPY (¥)',
      'AED (د.إ)',
    ];

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Choose Currency'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: currencies.map((currency) {
              return RadioListTile<String>(
                title: Text(currency),
                value: currency,
                groupValue: AppTheme.currency,
                activeColor: purple,
                onChanged: (value) async {
                  if (value == null) return;

                  await AppTheme.setCurrency(value);

                  if (!dialogContext.mounted) return;

                  Navigator.pop(dialogContext);
                  refreshScreen();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$value selected'),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

// ============================================================
// MY TRIPS PAGE - FIRESTORE
// ============================================================

class MyTripsPage extends StatelessWidget {
  const MyTripsPage({super.key});

  static const Color purple = Color(0xFF7B2CBF);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Trips')),
        body: const Center(
          child: Text('Please log in to view your trips.'),
        ),
      );
    }

    final tripsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('saved_trips')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FC),
      appBar: AppBar(
        title: const Text(
          'My Trips',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: purple,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: tripsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: purple,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Unable to load your trips.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final documents = snapshot.data?.docs ?? [];

          if (documents.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.luggage_rounded,
                      size: 85,
                      color: purple,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'No Trips Saved Yet!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF392D48),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Complete your trip planning and save '
                      'your journey. Your trips will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              final trip = document.data();

              final country =
                  trip['country']?.toString() ?? 'Unknown Country';

              final city =
                  trip['city']?.toString() ?? 'Unknown City';

              final days = trip['numberOfDays'] is num
                  ? (trip['numberOfDays'] as num).toInt()
                  : 1;

              final budget =
                  trip['budget']?.toString() ?? 'Not specified';

              final travelWith =
                  trip['travelWith']?.toString() ?? 'Not specified';

              final interests = trip['interests'] is List
                  ? (trip['interests'] as List)
                      .map((item) => item.toString())
                      .join(', ')
                  : trip['interests']?.toString() ?? '';

              final foodPreference =
                  trip['foodPreference']?.toString() ??
                      'Not specified';

              final travelStyle =
                  trip['travelStyle']?.toString() ??
                      'Not specified';

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    _openTripDashboard(
                      context,
                      country: country,
                      city: city,
                      days: days,
                      budget: budget,
                      travelWith: travelWith,
                      interests: interests,
                      foodPreference: foodPreference,
                      travelStyle: travelStyle,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(17),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                color: purple.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.flight_takeoff_rounded,
                                color: purple,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    city,
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF392D48),
                                    ),
                                  ),
                                  Text(
                                    country,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: purple,
                              size: 18,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_rounded,
                              color: purple,
                              size: 19,
                            ),
                            const SizedBox(width: 8),
                            Text('$days days'),
                            const SizedBox(width: 20),
                            const Icon(
                              Icons.account_balance_wallet_rounded,
                              color: purple,
                              size: 19,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                budget,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: purple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              _openTripDashboard(
                                context,
                                country: country,
                                city: city,
                                days: days,
                                budget: budget,
                                travelWith: travelWith,
                                interests: interests,
                                foodPreference: foodPreference,
                                travelStyle: travelStyle,
                              );
                            },
                            icon: const Icon(Icons.explore_rounded),
                            label: const Text('Open Trip Dashboard'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openTripDashboard(
    BuildContext context, {
    required String country,
    required String city,
    required int days,
    required String budget,
    required String travelWith,
    required String interests,
    required String foodPreference,
    required String travelStyle,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PersonalizedTripDashboardScreen(
          country: country,
          city: city,
          numberOfDays: days,
          budget: budget,
          travelWith: travelWith,
          interests: interests,
          foodPreference: foodPreference,
          travelStyle: travelStyle,
        ),
      ),
    );
  }
}

// ============================================================
// SETTINGS PAGE
// ============================================================

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const ListTile(
            leading: Icon(Icons.language_rounded),
            title: Text('Language'),
            subtitle: Text('Choose your preferred language'),
          ),
          ListTile(
            leading: const Icon(Icons.language_rounded),
            title: Text(AppTheme.language),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.currency_exchange_rounded),
            title: const Text('Currency'),
            subtitle: Text(AppTheme.currency),
          ),
          const Divider(),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: AppTheme.themeMode,
            builder: (context, mode, child) {
              return SwitchListTile(
                secondary: const Icon(Icons.dark_mode_rounded),
                title: const Text('Dark Mode'),
                value: mode == ThemeMode.dark,
                activeColor: const Color(0xFF7B2CBF),
                onChanged: AppTheme.setDarkMode,
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HELP AND SUPPORT PAGE
// ============================================================

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'question': 'How can I plan a trip?',
        'answer':
            'Open Explore Countries, select your destination, '
            'and answer the travel questions to generate your trip plan.',
      },
      {
        'question': 'How does AI itinerary work?',
        'answer':
            'Travel Nest AI uses your destination, budget, interests, '
            'and travel preferences to prepare a suggested itinerary.',
      },
      {
        'question': 'Can I change my currency?',
        'answer':
            'Yes. Open Profile & Settings and select Currency.',
      },
      {
        'question': 'How do I enable Dark Mode?',
        'answer':
            'Open Profile & Settings and turn on the Dark Mode switch.',
      },
      {
        'question': 'Where can I find my trips?',
        'answer':
            'Open Profile & Settings and select My Trips to see '
            'the trips saved to your account.',
      },
      {
        'question': 'Can I download or share my trip?',
        'answer':
            'Open the Save and Share Trip feature to save, download, '
            'or share your travel plan.',
      },
      {
        'question': 'Can I change my itinerary?',
        'answer':
            'You can review your generated itinerary and make changes '
            'using the available trip planning features.',
      },
      {
        'question': 'Is an internet connection required?',
        'answer':
            'An internet connection is required for Firebase account '
            'features, live weather, and AI-powered services.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: const Color(0xFF7B2CBF),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Icon(
            Icons.support_agent_rounded,
            size: 75,
            color: Color(0xFF7B2CBF),
          ),
          const SizedBox(height: 12),
          const Text(
            'How can we help you?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Find answers to common questions about Travel Nest.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 25),
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...faqs.map((faq) {
            return Card(
              margin: const EdgeInsets.only(bottom: 9),
              child: ExpansionTile(
                leading: const Icon(
                  Icons.help_outline_rounded,
                  color: Color(0xFF7B2CBF),
                ),
                title: Text(
                  faq['question']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                childrenPadding: const EdgeInsets.fromLTRB(
                  16, 0, 16, 15,
                ),
                children: [
                  Text(
                    faq['answer']!,
                    style: const TextStyle(
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          const Card(
            child: ListTile(
              leading: Icon(
                Icons.info_outline_rounded,
                color: Color(0xFF7B2CBF),
              ),
              title: Text('Travel Nest Support'),
              subtitle: Text(
                'For assistance, contact your project administrator.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
