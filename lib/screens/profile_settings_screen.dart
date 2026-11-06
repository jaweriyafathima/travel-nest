
import 'package:flutter/material.dart';

import '../services/app_language.dart';
import '../services/app_theme.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool notifications = true;
  String selectedCurrency = 'INR (₹)';

  static const Color purple = Color(0xFF6956C8);
  static const Color background = Color(0xFFF8F6FF);

  String tr(String key) => AppLanguage.tr(key);

  @override
  void initState() {
    super.initState();
    selectedCurrency = AppTheme.currency;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.language,
      builder: (context, language, child) {
        return Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            title: Text(
              tr('profile'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: purple,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              _profileCard(),
              const SizedBox(height: 24),

              _sectionTitle(tr('account')),

              _settingsTile(
                Icons.person_outline,
                'Edit Profile',
                'Update your personal information',
                () => _showMessage('Profile editing will be connected soon.'),
              ),

              _settingsTile(
                Icons.luggage_outlined,
                tr('my_trips'),
                'View your saved travel plans',
                () => _showMessage('Your trips will appear here.'),
              ),

              const SizedBox(height: 20),

              _sectionTitle(tr('preferences')),

              _settingsTile(
                Icons.language,
                tr('language'),
                language,
                _chooseLanguage,
              ),

              _settingsTile(
                Icons.currency_exchange,
                tr('currency'),
                selectedCurrency,
                _chooseCurrency,
              ),

              ValueListenableBuilder<ThemeMode>(
                valueListenable: AppTheme.themeMode,
                builder: (context, themeMode, child) {
                  return SwitchListTile(
                    secondary: const Icon(Icons.dark_mode_outlined),
                    title: Text(tr('dark_mode')),
                    subtitle: const Text('Change app appearance'),
                    value: themeMode == ThemeMode.dark,
                    onChanged: (value) async {
                      await AppTheme.setDarkMode(value);
                    },
                  );
                },
              ),

              SwitchListTile(
                secondary: const Icon(Icons.notifications_outlined),
                title: Text(tr('notifications')),
                subtitle: const Text('Receive travel updates'),
                value: notifications,
                onChanged: (value) {
                  setState(() => notifications = value);
                },
              ),

              const SizedBox(height: 20),

              _sectionTitle(tr('support')),

              _settingsTile(
                Icons.help_outline,
                tr('help'),
                'Get assistance with Travel Nest',
                () => _showMessage('Help & Support'),
              ),

              _settingsTile(
                Icons.privacy_tip_outlined,
                'Privacy Policy',
                'Learn how your information is used',
                () => _showMessage('Privacy Policy'),
              ),

              _settingsTile(
                Icons.info_outline,
                'About Travel Nest',
                'AI Powered Travel Planner',
                _showAbout,
              ),

              const SizedBox(height: 20),

              OutlinedButton.icon(
                onPressed: _showLogoutDialog,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: Text(
                  tr('logout'),
                  style: const TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  side: const BorderSide(color: Colors.red),
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  'Travel Nest • Plan Smart, Travel Better',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7664D8), Color(0xFFB18BEA)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 39,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 45,
              color: purple,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            tr('welcome'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Your Travel Nest account',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: purple,
        ),
      ),
    );
  }

  Widget _settingsTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: purple.withValues(alpha: 0.12),
          child: Icon(icon, color: purple),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _chooseLanguage() {
    _showChoiceDialog(
      title: 'Choose Language',
      options: const [
        'English',
        'Hindi',
        'Tamil',
        'Telugu',
        'Kannada',
        'Malayalam',
      ],
      selectedValue: AppLanguage.language.value,
      onSelected: (value) async {
        AppLanguage.changeLanguage(value);
        await AppTheme.setLanguage(value);
        _showMessage('Language changed to $value');
      },
    );
  }

  void _chooseCurrency() {
    _showChoiceDialog(
      title: 'Choose Currency',
      options: const [
        'INR (₹)',
        'USD',
        'EUR',
        'GBP',
        'JPY',
      ],
      selectedValue: selectedCurrency,
      onSelected: (value) async {
        await AppTheme.setCurrency(value);
        setState(() => selectedCurrency = value);
      },
    );
  }

  void _showChoiceDialog({
    required String title,
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              return ListTile(
                title: Text(option),
                trailing: selectedValue == option
                    ? const Icon(Icons.check, color: purple)
                    : null,
                onTap: () {
                  onSelected(option);
                  Navigator.pop(dialogContext);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Travel Nest',
      applicationVersion: '1.0.0',
      applicationLegalese: 'AI Powered Travel Planner',
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(tr('logout')),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _showMessage('Connect this action to Firebase Auth later.');
            },
            child: Text(
              tr('logout'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
