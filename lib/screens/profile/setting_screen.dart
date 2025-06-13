import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
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
      icon: Icons.sync,
      title: 'Sync',
      subtitle: 'AnkiWeb account • Automatic synchronization',
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
    SettingsItem(
      icon: Icons.gamepad,
      title: 'Controls',
      subtitle: 'Gestures • Keyboard • Bluetooth',
    ),
    SettingsItem(
      icon: Icons.accessibility_new,
      title: 'Accessibility',
      subtitle: 'Card zoom • Answer button size',
    ),
    SettingsItem(
      icon: Icons.backup,
      title: 'Backups',
      subtitle: 'Frequency • Lifetime',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Settings', style: TextStyle(color: Colors.white)),
        leading: BackButton(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[900],
                prefixIcon: Icon(Icons.search, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: settingsItems.length,
              itemBuilder: (context, index) {
                final item = settingsItems[index];
                return ListTile(
                  leading: Icon(item.icon, color: Colors.white),
                  title: Text(item.title, style: TextStyle(color: Colors.white)),
                  subtitle: Text(item.subtitle, style: TextStyle(color: Colors.white70)),
                  onTap: () {
                    // Handle navigation or settings logic here
                  },
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