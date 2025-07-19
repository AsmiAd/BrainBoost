import 'package:brain_boost/core/constants/app_colors.dart';
import 'package:brain_boost/screens/setting/pages/apperance_page.dart';
import 'package:brain_boost/screens/setting/pages/general_page.dart';
import 'package:brain_boost/screens/setting/pages/notification_page.dart';
import 'package:brain_boost/screens/setting/pages/reviewing_page.dart';
import 'package:flutter/material.dart';


class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<SettingsItem> settingsItems = [
    SettingsItem(
      icon: Icons.settings,
      title: 'General',
      subtitle: 'Language • Studying • System-wide',
    ),
    SettingsItem(
      icon: Icons.tv,
      title: 'Reviewing',
      subtitle: 'Scheduling • Automatic display answer',
    ),
    SettingsItem(
      icon: Icons.notifications,
      title: 'Notifications',
      subtitle: 'Notify when • Vibrate • Blink light',
    ),
    SettingsItem(
      icon: Icons.palette,
      title: 'Appearance',
      subtitle: 'Themes • Reviewer',
    ),
  ];

  void navigateToSettings(int index) {
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (_) => GeneralSettingsPage()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) => ReviewingSettingsPage()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsSettingsPage()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (_) => AppearanceSettingsPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
      backgroundColor: AppColors.primary,
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        leading: const BackButton(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.blueAccent,
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: settingsItems.length,
              itemBuilder: (context, index) {
                final item = settingsItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Icon(item.icon, color: Colors.blueAccent),
                      title: Text(item.title, style: const TextStyle(color: Colors.black)),
                      subtitle: Text(item.subtitle, style: const TextStyle(color: Colors.black54)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      onTap: () => navigateToSettings(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsItem {
  final IconData icon;
  final String title;
  final String subtitle;

  SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
