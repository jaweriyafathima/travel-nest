
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  static const Color purple = Color(0xFF7B2CBF);
  static const Color background = Color(0xFFF8F5FC);

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  Widget statisticCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 15),
            Text(
              value,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14, top: 25),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adminEmail =
        FirebaseAuth.instance.currentUser?.email ?? 'Admin';

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: purple,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Travel Nest Admin',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Admin Logout',
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Unable to load user information.\n'
                'Please check Firestore permissions.',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: purple),
            );
          }

          final users = snapshot.data?.docs ?? [];
          final totalUsers = users.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF7B2CBF),
                        Color(0xFF9D4EDD),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.admin_panel_settings,
                        color: Colors.white,
                        size: 42,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Welcome, Admin!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        adminEmail,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Manage your Travel Nest application',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                sectionTitle('Dashboard Overview'),

                GridView.count(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.25,
                  children: [
                    statisticCard(
                      icon: Icons.people,
                      title: 'Registered Users',
                      value: '$totalUsers',
                      color: purple,
                    ),
                    statisticCard(
                      icon: Icons.flight_takeoff,
                      title: 'Travel Platform',
                      value: 'Active',
                      color: Colors.green,
                    ),
                    statisticCard(
                      icon: Icons.security,
                      title: 'Admin Access',
                      value: 'Active',
                      color: Colors.orange,
                    ),
                    statisticCard(
                      icon: Icons.storage,
                      title: 'Database',
                      value: 'Firebase',
                      color: Colors.blue,
                    ),
                  ],
                ),

                sectionTitle('User Management'),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(0xFFEADCF8),
                          child: Icon(
                            Icons.people,
                            color: purple,
                          ),
                        ),
                        title: Text(
                          'Registered Users',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'View users registered in Travel Nest',
                        ),
                      ),
                      const Divider(height: 1),
                      ...users.map((user) {
                        final data = user.data();
                        final name =
                            data['name']?.toString() ?? 'No name';
                        final email =
                            data['email']?.toString() ?? 'No email';

                        return ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(name),
                          subtitle: Text(email),
                        );
                      }),
                      if (users.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(18),
                          child: Text('No registered users found.'),
                        ),
                    ],
                  ),
                ),

                sectionTitle('System Information'),

                Card(
                  child: const Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.cloud_done, color: Colors.green),
                        title: Text('Backend Service'),
                        subtitle: Text('Firebase'),
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.storage, color: purple),
                        title: Text('Database Service'),
                        subtitle: Text('Cloud Firestore'),
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.verified_user, color: purple),
                        title: Text('Authentication'),
                        subtitle: Text('Firebase Authentication'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => logout(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout from Admin'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),
              ],
            ),
          );
        },
      ),
    );
  }
}
