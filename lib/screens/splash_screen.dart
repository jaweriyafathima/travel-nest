
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'welcome_screen.dart';
import 'home_screen.dart';
import 'admin_dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Color purple = Color(0xFF7B2CBF);

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    try {
      User? user = FirebaseAuth.instance.currentUser;

      // No saved login session.
      if (user == null) {
        _goTo(const WelcomeScreen());
        return;
      }

      // Refresh authentication information.
      await user.reload();

      if (!mounted) return;

      user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        _goTo(const WelcomeScreen());
        return;
      }

      // Check whether this account is an administrator.
      final adminDocument = await FirebaseFirestore.instance
          .collection('admins')
          .doc(user.uid)
          .get();

      if (!mounted) return;

      final adminData = adminDocument.data();

      if (adminDocument.exists &&
          adminData != null &&
          adminData['role'] == 'superAdmin') {
        _goTo(const AdminDashboardScreen());
        return;
      }

      // Normal users must verify their email.
      if (!user.emailVerified) {
        await FirebaseAuth.instance.signOut();

        if (!mounted) return;

        _goTo(const WelcomeScreen());
        return;
      }

      // Already logged-in verified user.
      _goTo(const HomeScreen());
    } catch (e) {
      if (!mounted) return;

      // If the account is verified, allow the user to continue
      // when an administrator lookup temporarily fails.
      final user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        _goTo(const HomeScreen());
      } else {
        _goTo(const WelcomeScreen());
      }
    }
  }

  void _goTo(Widget screen) {
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => screen),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF7B2CBF),
              Color(0xFF9D4EDD),
              Color(0xFFE0AAFF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: const Icon(
                  Icons.flight_takeoff,
                  size: 65,
                  color: purple,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Travel Nest',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Plan • Explore • Travel',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
