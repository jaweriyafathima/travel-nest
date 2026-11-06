
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'services/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await AppTheme.loadPreferences();

  runApp(const TravelNestApp());
}

class TravelNestApp extends StatelessWidget {
  const TravelNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeMode,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Travel Nest',
          themeMode: currentMode,

          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: const Color(0xFF7B2CBF),
            scaffoldBackgroundColor: const Color(0xFFF8F5FC),
          ),

          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: const Color(0xFFB78AE8),
            scaffoldBackgroundColor: const Color(0xFF17131D),
            cardColor: const Color(0xFF292331),
          ),

          home: const SplashScreen(),
        );
      },
    );
  }
}
