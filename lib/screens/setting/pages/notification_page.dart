import 'package:brain_boost/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class NotificationsSettingsPage extends StatefulWidget {
  @override
  _NotificationsSettingsPageState createState() => _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool _enableNotifications = true;
  bool _dailyReminder = true;
  bool _vibrate = true;
  bool _led = false;
  TimeOfDay _reminderTime = TimeOfDay(hour: 8, minute: 0);

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification Settings"),
      backgroundColor: AppColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Push Notifications",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text("Enable Notifications", style: TextStyle(fontSize: 14)),
            subtitle: Text("Receive updates and reminders", style: TextStyle(fontSize: 12)),
            trailing: Transform.scale(
              scale: 0.75,
              child: Switch(
                value: _enableNotifications,
                onChanged: (val) {
                  setState(() {
                    _enableNotifications = val;
                  });
                },
              ),
            ),
          ),
          const Divider(),

          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text("Daily Study Reminder", style: TextStyle(fontSize: 14)),
            subtitle: Text("Push notification to remind study daily", style: TextStyle(fontSize: 12)),
            trailing: Transform.scale(
              scale: 0.75,
              child: Switch(
                value: _dailyReminder,
                onChanged: (val) {
                  setState(() {
                    _dailyReminder = val;
                  });
                },
              ),
            ),
          ),
          if (_dailyReminder) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("Reminder Time", style: TextStyle(fontSize: 14)),
              subtitle: Text("Set time for daily reminder", style: TextStyle(fontSize: 12)),
              trailing: TextButton(
                onPressed: _pickTime,
                child: Text("${_reminderTime.format(context)}"),
              ),
            ),
            const Divider(),
          ],

          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text("Vibration", style: TextStyle(fontSize: 14)),
            subtitle: Text("Enable vibration for alerts", style: TextStyle(fontSize: 12)),
            trailing: Transform.scale(
              scale: 0.75,
              child: Switch(
                value: _vibrate,
                onChanged: (val) {
                  setState(() {
                    _vibrate = val;
                  });
                },
              ),
            ),
          ),
          const Divider(),

          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text("Blink LED Light", style: TextStyle(fontSize: 14)),
            subtitle: Text("Flash LED light for notifications", style: TextStyle(fontSize: 12)),
            trailing: Transform.scale(
              scale: 0.75,
              child: Switch(
                value: _led,
                onChanged: (val) {
                  setState(() {
                    _led = val;
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
