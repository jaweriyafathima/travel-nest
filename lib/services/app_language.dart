
import 'package:flutter/material.dart';

class AppLanguage {
  static final ValueNotifier<String> language =
      ValueNotifier<String>('English');

  static const List<String> supportedLanguages = [
    'English',
    'Hindi',
    'Tamil',
    'Telugu',
    'Kannada',
    'Malayalam',
  ];

  static const Map<String, Map<String, String>> translations = {
    'English': {
      'profile': 'Profile & Settings',
      'account': 'Account',
      'preferences': 'Preferences',
      'language': 'Language',
      'currency': 'Currency',
      'dark_mode': 'Dark Mode',
      'notifications': 'Notifications',
      'support': 'Support',
      'help': 'Help & Support',
      'logout': 'Log Out',
      'welcome': 'Welcome, Traveler!',
      'home': 'Home',
      'my_trips': 'My Trips',
      'saved': 'Saved',
      'country': 'Country',
      'search': 'Search',
    },
    'Hindi': {
      'profile': 'प्रोफ़ाइल और सेटिंग्स',
      'account': 'खाता',
      'preferences': 'प्राथमिकताएँ',
      'language': 'भाषा',
      'currency': 'मुद्रा',
      'dark_mode': 'डार्क मोड',
      'notifications': 'सूचनाएँ',
      'support': 'सहायता',
      'help': 'मदद और सहायता',
      'logout': 'लॉग आउट',
      'welcome': 'स्वागत है, यात्री!',
      'home': 'होम',
      'my_trips': 'मेरी यात्राएँ',
      'saved': 'सेव किए गए',
      'country': 'देश',
      'search': 'खोजें',
    },
    'Tamil': {
      'profile': 'சுயவிவரம் மற்றும் அமைப்புகள்',
      'account': 'கணக்கு',
      'preferences': 'விருப்பங்கள்',
      'language': 'மொழி',
      'currency': 'நாணயம்',
      'dark_mode': 'இருண்ட பயன்முறை',
      'notifications': 'அறிவிப்புகள்',
      'support': 'ஆதரவு',
      'help': 'உதவி மற்றும் ஆதரவு',
      'logout': 'வெளியேறு',
      'welcome': 'வரவேற்கிறோம், பயணியே!',
      'home': 'முகப்பு',
      'my_trips': 'எனது பயணங்கள்',
      'saved': 'சேமித்தவை',
      'country': 'நாடு',
      'search': 'தேடல்',
    },
    'Telugu': {
      'profile': 'ప్రొఫైల్ మరియు సెట్టింగ్‌లు',
      'account': 'ఖాతా',
      'preferences': 'ప్రాధాన్యతలు',
      'language': 'భాష',
      'currency': 'కరెన్సీ',
      'dark_mode': 'డార్క్ మోడ్',
      'notifications': 'నోటిఫికేషన్‌లు',
      'support': 'మద్దతు',
      'help': 'సహాయం',
      'logout': 'లాగ్ అవుట్',
      'welcome': 'స్వాగతం, ప్రయాణికుడా!',
      'home': 'హోమ్',
      'my_trips': 'నా ప్రయాణాలు',
      'saved': 'సేవ్ చేసినవి',
      'country': 'దేశం',
      'search': 'వెతకండి',
    },
    'Kannada': {
      'profile': 'ಪ್ರೊಫೈಲ್ ಮತ್ತು ಸೆಟ್ಟಿಂಗ್‌ಗಳು',
      'account': 'ಖಾತೆ',
      'preferences': 'ಆದ್ಯತೆಗಳು',
      'language': 'ಭಾಷೆ',
      'currency': 'ಕರೆನ್ಸಿ',
      'dark_mode': 'ಡಾರ್ಕ್ ಮೋಡ್',
      'notifications': 'ಅಧಿಸೂಚನೆಗಳು',
      'support': 'ಬೆಂಬಲ',
      'help': 'ಸಹಾಯ ಮತ್ತು ಬೆಂಬಲ',
      'logout': 'ಲಾಗ್ ಔಟ್',
      'welcome': 'ಸ್ವಾಗತ, ಪ್ರಯಾಣಿಕರೇ!',
      'home': 'ಮುಖಪುಟ',
      'my_trips': 'ನನ್ನ ಪ್ರವಾಸಗಳು',
      'saved': 'ಉಳಿಸಿದವು',
      'country': 'ದೇಶ',
      'search': 'ಹುಡುಕಿ',
    },
    'Malayalam': {
      'profile': 'പ്രൊഫൈലും ക്രമീകരണങ്ങളും',
      'account': 'അക്കൗണ്ട്',
      'preferences': 'മുൻഗണനകൾ',
      'language': 'ഭാഷ',
      'currency': 'കറൻസി',
      'dark_mode': 'ഡാർക്ക് മോഡ്',
      'notifications': 'അറിയിപ്പുകൾ',
      'support': 'പിന്തുണ',
      'help': 'സഹായം',
      'logout': 'ലോഗ് ഔട്ട്',
      'welcome': 'സ്വാഗതം, യാത്രികാ!',
      'home': 'ഹോം',
      'my_trips': 'എന്റെ യാത്രകൾ',
      'saved': 'സേവ് ചെയ്തത്',
      'country': 'രാജ്യം',
      'search': 'തിരയുക',
    },
  };

  static String tr(String key) {
    return translations[language.value]?[key] ??
        translations['English']![key] ??
        key;
  }

  static void changeLanguage(String value) {
    if (supportedLanguages.contains(value)) {
      language.value = value;
    }
  }
}
