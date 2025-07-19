import 'package:brain_boost/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ReviewingSettingsPage extends StatefulWidget {
  @override
  _ReviewingSettingsPageState createState() => _ReviewingSettingsPageState();
}

class _ReviewingSettingsPageState extends State<ReviewingSettingsPage> {
  bool _autoShowAnswer = true;
  bool _randomOrder = false;
  bool _reviewDueOnly = true;
  double _reviewSpeed = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviewing Settings"),
      backgroundColor: AppColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Review Options",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Auto Show Answer
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text("Auto-show answer", style: TextStyle(fontSize: 14)),
            subtitle: Text("Automatically display the answer after a delay", style: TextStyle(fontSize: 12)),
            trailing: Transform.scale(
              scale: 0.75,
              child: Switch(
                value: _autoShowAnswer,
                onChanged: (val) {
                  setState(() {
                    _autoShowAnswer = val;
                  });
                },
              ),
            ),
          ),
          const Divider(),

          // Random Order
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text("Random order", style: TextStyle(fontSize: 14)),
            subtitle: Text("Shuffle questions during review", style: TextStyle(fontSize: 12)),
            trailing: Transform.scale(
              scale: 0.75,
              child: Switch(
                value: _randomOrder,
                onChanged: (val) {
                  setState(() {
                    _randomOrder = val;
                  });
                },
              ),
            ),
          ),
          const Divider(),

          // Review Due Only
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text("Review due only", style: TextStyle(fontSize: 14)),
            subtitle: Text("Only review cards that are due today", style: TextStyle(fontSize: 12)),
            trailing: Transform.scale(
              scale: 0.75,
              child: Switch(
                value: _reviewDueOnly,
                onChanged: (val) {
                  setState(() {
                    _reviewDueOnly = val;
                  });
                },
              ),
            ),
          ),
          const Divider(),

          // Review Speed Slider
          const SizedBox(height: 12),
          const Text(
            "Review Speed",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _reviewSpeed,
            min: 0.5,
            max: 2.0,
            divisions: 3,
            label: "${_reviewSpeed.toStringAsFixed(1)}x",
            onChanged: (val) {
              setState(() {
                _reviewSpeed = val;
              });
            },
          ),
          Text(
            "Current speed: ${_reviewSpeed.toStringAsFixed(1)}x",
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
