import 'package:brain_boost/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppearanceSettingsPage extends StatefulWidget {
  @override
  _AppearanceSettingsPageState createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettingsPage> {
  String _selectedTheme = 'System Default';
  String _selectedAccentColor = 'Blue';
  double _fontSize = 14.0;

  final List<String> _themes = ['Light', 'Dark', 'System Default'];
  final List<String> _accentColors = ['Blue', 'Green', 'Orange', 'Purple'];

  Color getAccentColor(String colorName) {
    switch (colorName) {
      case 'Green':
        return Colors.green;
      case 'Orange':
        return Colors.orange;
      case 'Purple':
        return Colors.purple;
      case 'Blue':
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appearance Settings"),
      backgroundColor: AppColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Theme",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          DropdownButtonFormField<String>(
            value: _selectedTheme,
            icon: Icon(Icons.arrow_drop_down, size: 20),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
            items: _themes.map((theme) {
              return DropdownMenuItem(
                value: theme,
                child: Text(theme),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedTheme = value!;
              });
            },
          ),
          const SizedBox(height: 24),

          const Text(
            "Accent Color",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          DropdownButtonFormField<String>(
            value: _selectedAccentColor,
            icon: Icon(Icons.arrow_drop_down, size: 20),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
            items: _accentColors.map((color) {
              return DropdownMenuItem(
                value: color,
                child: Row(
                  children: [
                    CircleAvatar(backgroundColor: getAccentColor(color), radius: 8),
                    const SizedBox(width: 8),
                    Text(color),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedAccentColor = value!;
              });
            },
          ),
          const SizedBox(height: 24),

          const Text(
            "Font Size",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _fontSize,
            min: 12,
            max: 20,
            divisions: 8,
            label: "${_fontSize.toStringAsFixed(0)}",
            onChanged: (value) {
              setState(() {
                _fontSize = value;
              });
            },
          ),
          Text(
            "Preview text with size ${_fontSize.toStringAsFixed(0)}",
            style: TextStyle(fontSize: _fontSize),
          ),
        ],
      ),
    );
  }
}
