
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/image_data.dart';
import '../services/app_language.dart';
import 'country_selection_screen.dart';
import 'profile_screen.dart';
import 'ai_chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String userName = 'Traveler';

  static const Color purple = Color(0xFF7B2CBF);

  bool get isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get pageColor => isDark
      ? const Color(0xFF17131D)
      : const Color(0xFFF9F5FC);

  Color get cardColor =>
      isDark ? const Color(0xFF292331) : Colors.white;

  Color get mainTextColor =>
      isDark ? Colors.white : const Color(0xFF3D2352);

  Color get secondaryTextColor =>
      isDark ? Colors.white60 : const Color(0xFF927E9C);

  String t(String key) {
    const translations = {
      'Hindi': {
        'home': 'होम',
        'explore': 'खोजें',
        'countries': 'देश',
        'my_trips': 'मेरी यात्राएँ',
        'your_plans': 'आपकी योजनाएँ',
        'saved': 'सेव किए गए',
        'favourite_trips': 'पसंदीदा यात्राएँ',
        'profile': 'प्रोफ़ाइल',
        'your_account': 'आपका खाता',
        'welcome': 'नमस्ते',
        'greeting': 'आप अगली यात्रा कहाँ करना चाहेंगे?',
        'search': 'देश या शहर खोजें',
        'quick_actions': 'आप क्या करना चाहेंगे?',
        'companion': 'आपका यात्रा साथी',
        'adventure': 'क्या आप अगले रोमांच के लिए तैयार हैं?',
        'personalized': 'Travel Nest आपके लिए एक खास यात्रा बनाएगा।',
        'plan_trip': 'नई यात्रा की योजना बनाएँ',
        'settings': 'सेटिंग्स',
        'help': 'सहायता और समर्थन',
        'saved_trips': 'सेव की गई यात्राएँ',
        'account': 'आपका खाता',
      },
      'Tamil': {
        'home': 'முகப்பு',
        'explore': 'ஆராயுங்கள்',
        'countries': 'நாடுகள்',
        'my_trips': 'எனது பயணங்கள்',
        'your_plans': 'உங்கள் திட்டங்கள்',
        'saved': 'சேமித்தவை',
        'favourite_trips': 'பிடித்த பயணங்கள்',
        'profile': 'சுயவிவரம்',
        'your_account': 'உங்கள் கணக்கு',
        'welcome': 'வணக்கம்',
        'greeting': 'அடுத்ததாக எங்கு செல்ல விரும்புகிறீர்கள்?',
        'search': 'நாடு அல்லது நகரத்தைத் தேடுங்கள்',
        'quick_actions': 'நீங்கள் என்ன செய்ய விரும்புகிறீர்கள்?',
        'companion': 'உங்கள் பயணத் துணை',
        'adventure': 'உங்கள் அடுத்த சாகசத்திற்கு தயாரா?',
        'personalized': 'Travel Nest உங்களுக்கான பயணத்தை உருவாக்கும்.',
        'plan_trip': 'புதிய பயணத்தைத் திட்டமிடுங்கள்',
        'settings': 'அமைப்புகள்',
        'help': 'உதவி மற்றும் ஆதரவு',
        'saved_trips': 'சேமித்த பயணங்கள்',
        'account': 'உங்கள் கணக்கு',
      },
      'Telugu': {
        'home': 'హోమ్',
        'explore': 'అన్వేషించండి',
        'countries': 'దేశాలు',
        'my_trips': 'నా ప్రయాణాలు',
        'your_plans': 'మీ ప్రణాళికలు',
        'saved': 'సేవ్ చేసినవి',
        'favourite_trips': 'ఇష్టమైన ప్రయాణాలు',
        'profile': 'ప్రొఫైల్',
        'your_account': 'మీ ఖాతా',
        'welcome': 'నమస్కారం',
        'greeting': 'మీ తదుపరి ప్రయాణానికి ఎక్కడికి వెళ్లాలనుకుంటున్నారు?',
        'search': 'దేశం లేదా నగరాన్ని వెతకండి',
        'quick_actions': 'మీరు ఏమి చేయాలనుకుంటున్నారు?',
        'companion': 'మీ ప్రయాణ సహచరి',
        'adventure': 'మీ తదుపరి సాహసానికి సిద్ధంగా ఉన్నారా?',
        'personalized': 'Travel Nest మీ కోసం ప్రత్యేక ప్రయాణాన్ని రూపొందిస్తుంది.',
        'plan_trip': 'కొత్త ప్రయాణాన్ని ప్లాన్ చేయండి',
        'settings': 'సెట్టింగ్‌లు',
        'help': 'సహాయం మరియు మద్దతు',
        'saved_trips': 'సేవ్ చేసిన ప్రయాణాలు',
        'account': 'మీ ఖాతా',
      },
      'Kannada': {
        'home': 'ಮುಖಪುಟ',
        'explore': 'ಅನ್ವೇಷಿಸಿ',
        'countries': 'ದೇಶಗಳು',
        'my_trips': 'ನನ್ನ ಪ್ರಯಾಣಗಳು',
        'your_plans': 'ನಿಮ್ಮ ಯೋಜನೆಗಳು',
        'saved': 'ಉಳಿಸಿದವು',
        'favourite_trips': 'ಮೆಚ್ಚಿನ ಪ್ರಯಾಣಗಳು',
        'profile': 'ಪ್ರೊಫೈಲ್',
        'your_account': 'ನಿಮ್ಮ ಖಾತೆ',
        'welcome': 'ನಮಸ್ಕಾರ',
        'greeting': 'ನಿಮ್ಮ ಮುಂದಿನ ಪ್ರಯಾಣಕ್ಕೆ ಎಲ್ಲಿಗೆ ಹೋಗಲು ಬಯಸುತ್ತೀರಿ?',
        'search': 'ದೇಶ ಅಥವಾ ನಗರವನ್ನು ಹುಡುಕಿ',
        'quick_actions': 'ನೀವು ಏನು ಮಾಡಲು ಬಯಸುತ್ತೀರಿ?',
        'companion': 'ನಿಮ್ಮ ಪ್ರಯಾಣದ ಸಂಗಾತಿ',
        'adventure': 'ನಿಮ್ಮ ಮುಂದಿನ ಸಾಹಸಕ್ಕೆ ಸಿದ್ಧರಿದ್ದೀರಾ?',
        'personalized': 'Travel Nest ನಿಮಗಾಗಿ ವಿಶೇಷ ಪ್ರಯಾಣವನ್ನು ರೂಪಿಸುತ್ತದೆ.',
        'plan_trip': 'ಹೊಸ ಪ್ರಯಾಣವನ್ನು ಯೋಜಿಸಿ',
        'settings': 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು',
        'help': 'ಸಹಾಯ ಮತ್ತು ಬೆಂಬಲ',
        'saved_trips': 'ಉಳಿಸಿದ ಪ್ರಯಾಣಗಳು',
        'account': 'ನಿಮ್ಮ ಖಾತೆ',
      },
      'Malayalam': {
        'home': 'ഹോം',
        'explore': 'പര്യവേക്ഷണം',
        'countries': 'രാജ്യങ്ങൾ',
        'my_trips': 'എന്റെ യാത്രകൾ',
        'your_plans': 'നിങ്ങളുടെ പ്ലാനുകൾ',
        'saved': 'സേവ് ചെയ്തത്',
        'favourite_trips': 'പ്രിയപ്പെട്ട യാത്രകൾ',
        'profile': 'പ്രൊഫൈൽ',
        'your_account': 'നിങ്ങളുടെ അക്കൗണ്ട്',
        'welcome': 'നമസ്കാരം',
        'greeting': 'നിങ്ങളുടെ അടുത്ത യാത്ര എവിടേക്കാണ്?',
        'search': 'രാജ്യം അല്ലെങ്കിൽ നഗരം തിരയുക',
        'quick_actions': 'നിങ്ങൾ എന്താണ് ചെയ്യാൻ ആഗ്രഹിക്കുന്നത്?',
        'companion': 'നിങ്ങളുടെ യാത്രാ സഹായി',
        'adventure': 'അടുത്ത സാഹസിക യാത്രയ്ക്ക് തയ്യാറാണോ?',
        'personalized': 'Travel Nest നിങ്ങൾക്കായി ഒരു പ്രത്യേക യാത്ര ഒരുക്കും.',
        'plan_trip': 'പുതിയ യാത്ര ആസൂത്രണം ചെയ്യുക',
        'settings': 'ക്രമീകരണങ്ങൾ',
        'help': 'സഹായവും പിന്തുണയും',
        'saved_trips': 'സേവ് ചെയ്ത യാത്രകൾ',
        'account': 'നിങ്ങളുടെ അക്കൗണ്ട്',
      },
    };

    return translations[AppLanguage.language.value]?[key] ??
        AppLanguage.tr(key);
  }

  @override
  void initState() {
    super.initState();
    loadUserName();
  }

  Future<void> loadUserName() async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    try {
      final document =
          await _firestore.collection('users').doc(user.uid).get();

      if (document.exists && document.data() != null) {
        final data = document.data()!;

        if (data['name'] != null &&
            data['name'].toString().trim().isNotEmpty) {
          if (mounted) {
            setState(() {
              userName = data['name'].toString().trim();
            });
          }
        }
      }
    } catch (_) {}
  }

  // COUNTRY SEARCH AND NAVIGATION
  void openCountries({String searchQuery = ''}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountrySelectionScreen(
          initialSearch: searchQuery,
        ),
      ),
    );
  }

  void openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
  }

  void openAIChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AIChatScreen(),
      ),
    );
  }

  void openMyTrips() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyTripsPage(),
      ),
    );
  }

  void openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      ),
    );
  }

  void openHelp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HelpSupportPage(),
      ),
    );
  }

  // SAVED TEMPORARILY OPENS MY TRIPS
  void openSavedTrips() {
    openMyTrips();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.language,
      builder: (context, selectedLanguage, child) {
        return _buildHomeScreen();
      },
    );
  }

  Widget _buildHomeScreen() {
    return Scaffold(
      backgroundColor: pageColor,
      drawer: Drawer(
        backgroundColor: cardColor,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 25),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF7B2CBF),
                      Color(0xFFB565D9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.travel_explore,
                        color: purple,
                        size: 35,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Travel Nest',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Explore • Plan • Experience',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _drawerItem(
                icon: Icons.home_outlined,
                title: t('home'),
                onTap: () => Navigator.pop(context),
              ),
              _drawerItem(
                icon: Icons.explore_outlined,
                title: '${t('explore')} ${t('countries')}',
                onTap: () {
                  Navigator.pop(context);
                  openCountries();
                },
              ),
              _drawerItem(
                icon: Icons.luggage_outlined,
                title: t('my_trips'),
                onTap: () {
                  Navigator.pop(context);
                  openMyTrips();
                },
              ),
              _drawerItem(
                icon: Icons.smart_toy_outlined,
                title: 'Travel Nest AI Chat',
                onTap: () {
                  Navigator.pop(context);
                  openAIChat();
                },
              ),
              _drawerItem(
                icon: Icons.bookmark_outline,
                title: t('saved'),
                onTap: () {
                  Navigator.pop(context);
                  openSavedTrips();
                },
              ),
              _drawerItem(
                icon: Icons.person_outline,
                title: t('profile'),
                onTap: () {
                  Navigator.pop(context);
                  openProfile();
                },
              ),
              const Spacer(),
              const Divider(),
              _drawerItem(
                icon: Icons.settings_outlined,
                title: t('settings'),
                onTap: () {
                  Navigator.pop(context);
                  openSettings();
                },
              ),
              _drawerItem(
                icon: Icons.help_outline,
                title: t('help'),
                onTap: () {
                  Navigator.pop(context);
                  openHelp();
                },
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP BAR
              Row(
                children: [
                  Builder(
                    builder: (context) {
                      return Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: Icon(
                            Icons.menu_rounded,
                            color: mainTextColor,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF7B2CBF),
                                Color(0xFFB565D9),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.flight_takeoff_rounded,
                            color: Colors.white,
                            size: 23,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Travel Nest',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: mainTextColor,
                              ),
                            ),
                            Text(
                              t('companion'),
                              style: TextStyle(
                                fontSize: 10,
                                color: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: cardColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_none_rounded,
                      color: mainTextColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // WELCOME
              Text(
                '${t('welcome')}, $userName! 👋',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: mainTextColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                t('greeting'),
                style: TextStyle(
                  fontSize: 15,
                  color: secondaryTextColor,
                ),
              ),

              const SizedBox(height: 20),

              // WORKING COUNTRY SEARCH
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextField(
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      openCountries(
                        searchQuery: value.trim(),
                      );
                    }
                  },
                  decoration: InputDecoration(
                    hintText: t('search'),
                    hintStyle: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: purple,
                    ),
                    suffixIcon: Icon(
                      Icons.tune_rounded,
                      color: secondaryTextColor,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 17,
                    ),
                  ),
                  style: TextStyle(color: mainTextColor),
                ),
              ),

              const SizedBox(height: 25),

              // QUICK ACTIONS
              Text(
                t('quick_actions'),
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: mainTextColor,
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _actionCard(
                      icon: Icons.explore_rounded,
                      title: t('explore'),
                      subtitle: t('countries'),
                      onTap: openCountries,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _actionCard(
                      icon: Icons.luggage_rounded,
                      title: t('my_trips'),
                      subtitle: t('your_plans'),
                      onTap: openMyTrips,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _actionCard(
                      icon: Icons.bookmark_rounded,
                      title: t('saved'),
                      subtitle: t('favourite_trips'),
                      onTap: openSavedTrips,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _actionCard(
                      icon: Icons.person_rounded,
                      title: t('profile'),
                      subtitle: t('your_account'),
                      onTap: openProfile,
                    ),
                  ),
                ],
              ),

              // AI CHAT CARD
              const SizedBox(height: 12),
              InkWell(
                onTap: openAIChat,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF7B2CBF),
                        Color(0xFFB565D9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: purple.withValues(alpha: 0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white24,
                        child: Icon(
                          Icons.smart_toy_rounded,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chat with Travel Nest AI',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Ask questions and get travel suggestions',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // TRAVEL IMAGE
              Container(
                height: 245,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        ImageData.homeTravel,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF7B2CBF),
                                  Color(0xFFFFB4A2),
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.flight_takeoff_rounded,
                              color: Colors.white70,
                              size: 80,
                            ),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.72),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t('adventure'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              t('personalized'),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // PLAN TRIP BUTTON
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: openCountries,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    foregroundColor: Colors.white,
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.auto_awesome_rounded, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        t('plan_trip'),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 21),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Center(
                child: Text(
                  '✈️  Travel Nest • Explore • Plan • Experience',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 125,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white10
                : const Color(0xFFEDE5F5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: purple.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFB565D9),
                size: 25,
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: mainTextColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: const Icon(
        Icons.circle,
        color: Colors.transparent,
        size: 0,
      ),
      title: Row(
        children: [
          Icon(
            icon,
            color: const Color.fromARGB(255, 163, 81, 201),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: mainTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: secondaryTextColor,
      ),
    );
  }
}
