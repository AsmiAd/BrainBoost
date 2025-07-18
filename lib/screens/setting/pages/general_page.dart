import 'package:flutter/material.dart';

class GeneralSettingsPage extends StatefulWidget {
  @override
  _GeneralSettingsPageState createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  String _selectedLanguage = 'English';
  bool _studyReminder = true;
  bool _autoSaveProgress = false;

  final List<String> _languages = ['English', 'Nepali', 'Hindi', 'Korean'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("General Settings"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Language",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          DropdownButtonFormField<String>(
            value: _selectedLanguage,
            icon: Icon(Icons.arrow_drop_down, size: 20),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
            items: _languages
                .map((lang) => DropdownMenuItem(
                      value: lang,
                      child: Text(lang),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
            },
          ),
          const SizedBox(height: 24),

          const Text(
            "Daily Study Reminder",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text("Enable Study Reminders", style: TextStyle(fontSize: 14)),
            subtitle: Text("Receive daily study push notifications", style: TextStyle(fontSize: 12)),
            trailing: Transform.scale(
              scale: 0.75, // 👈 smaller toggle
              child: Switch(
                value: _studyReminder,
                onChanged: (val) {
                  setState(() {
                    _studyReminder = val;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            "Auto-Save Progress",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text("Save learning progress automatically", style: TextStyle(fontSize: 14)),
            subtitle: Text("No need to manually press save", style: TextStyle(fontSize: 12)),
            trailing: Transform.scale(
              scale: 0.75, // 👈 smaller toggle
              child: Switch(
                value: _autoSaveProgress,
                onChanged: (val) {
                  setState(() {
                    _autoSaveProgress = val;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
