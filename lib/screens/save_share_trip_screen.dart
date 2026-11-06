
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class SaveShareTripScreen extends StatefulWidget {
  final String country;
  final String city;
  final int numberOfDays;
  final String budget;
  final String travelWith;
  final List<String> interests;
  final String foodPreference;
  final String travelStyle;

  const SaveShareTripScreen({
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
  State<SaveShareTripScreen> createState() =>
      _SaveShareTripScreenState();
}

class _SaveShareTripScreenState extends State<SaveShareTripScreen> {
  bool isSaving = false;

  final Color purple = const Color(0xFF7356C9);
  final Color background = const Color(0xFFF8F5FC);

  String get tripDescription {
    return '''
Travel Nest - My Travel Plan

Destination: ${widget.city}, ${widget.country}
Duration: ${widget.numberOfDays} days
Budget: ${widget.budget}
Travelling with: ${widget.travelWith}
Interests: ${widget.interests.join(', ')}
Food preference: ${widget.foodPreference}
Travel style: ${widget.travelStyle}

Plan your journey and enjoy your trip with Travel Nest!
''';
  }

  Future<void> saveTrip() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to save your trip.'),
        ),
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
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trip saved successfully! ❤️'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save trip: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  Future<void> downloadPdf() async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (context) => pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'TRAVEL NEST',
                  style: pw.TextStyle(
                    fontSize: 26,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'My Personalized Travel Plan',
                  style: const pw.TextStyle(fontSize: 17),
                ),
                pw.Divider(),
                pw.SizedBox(height: 16),
                pw.Text(
                  'Destination: ${widget.city}, ${widget.country}',
                ),
                pw.SizedBox(height: 12),
                pw.Text('Duration: ${widget.numberOfDays} days'),
                pw.SizedBox(height: 12),
                pw.Text('Budget: ${widget.budget}'),
                pw.SizedBox(height: 12),
                pw.Text('Travelling with: ${widget.travelWith}'),
                pw.SizedBox(height: 12),
                pw.Text(
                  'Interests: ${widget.interests.join(', ')}',
                ),
                pw.SizedBox(height: 12),
                pw.Text(
                  'Food preference: ${widget.foodPreference}',
                ),
                pw.SizedBox(height: 12),
                pw.Text('Travel style: ${widget.travelStyle}'),
                pw.Spacer(),
                pw.Text('Created using Travel Nest'),
              ],
            ),
          ),
        ),
      );

      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF error: $e')),
      );
    }
  }

  Future<void> shareTrip() async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: tripDescription,
          subject: 'My Travel Nest Trip Plan',
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sharing failed: $e')),
      );
    }
  }

  Widget actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool loading = false,
  }) {
    return InkWell(
      onTap: loading ? null : onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.10),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF34263F),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (loading)
              const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(Icons.arrow_forward_ios,
                  size: 17, color: color),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Save & Share Trip',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: purple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF7556CA),
                    Color(0xFF9A76E8),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your journey, your memories!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${widget.city}, ${widget.country}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${widget.numberOfDays} days • ${widget.travelWith}',
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Manage Your Trip',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF34263F),
              ),
            ),
            const SizedBox(height: 16),
            actionCard(
              icon: Icons.favorite_rounded,
              title: 'Save Trip',
              subtitle: 'Save your trip to your Firebase account',
              color: const Color(0xFFE85B83),
              onTap: saveTrip,
              loading: isSaving,
            ),
            const SizedBox(height: 14),
            actionCard(
              icon: Icons.picture_as_pdf_rounded,
              title: 'Download PDF',
              subtitle: 'Create a PDF of your trip details',
              color: const Color(0xFFE56A55),
              onTap: downloadPdf,
            ),
            const SizedBox(height: 14),
            actionCard(
              icon: Icons.share_rounded,
              title: 'Share Trip',
              subtitle: 'Share your travel plan with friends',
              color: const Color(0xFF438EDB),
              onTap: shareTrip,
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield_outlined,
                      color: Color(0xFF7356C9)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your saved trips are stored under your account.',
                      style: TextStyle(
                        color: Color(0xFF665B70),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
