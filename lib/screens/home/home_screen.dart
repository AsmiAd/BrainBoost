import 'package:brain_boost/screens/home/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:brain_boost/services/auth_service.dart';
import 'package:brain_boost/screens/home/widgets/welcome_notification_bar.dart'; // adjust path

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  String _username = 'User';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final name = await _authService.getUsernameFromFirestore();
    setState(() {
      _username = name;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WelcomeNotificationBar(userName: _username),
                SizedBox(height: 20), // Spacing after the welcome bar
                SearchBarWidget()
                // Add more widgets here for the home content
              ],
            ),
    );
  }
}
