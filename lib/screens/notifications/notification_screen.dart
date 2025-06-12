import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top: Greeting
              const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Notification List
              Expanded(
                child: ListView.builder(
                  itemCount: 10, // Example count
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text('Notification ${index + 1}'),
                      subtitle: Text(
                          'This is the detail of notification ${index + 1}.'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
