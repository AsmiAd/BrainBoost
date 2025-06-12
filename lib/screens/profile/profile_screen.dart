import 'package:brain_boost/screens/profile/edit_page.dart';
import 'package:brain_boost/screens/profile/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _darkMode = false;

  Future<void> logout() async {
    try {
      await _auth.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: ${e.toString()}')),
        );
      }
    }
  }

  void _addAccount() {
    Navigator.of(context).pushNamed('/add-account');
  }

  void toggleDarkMode(bool value) {
    setState(() {
      _darkMode = value;
    });
    // Add your theme switching logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        ],
        title: const Text("Profile", style: TextStyle(color: Colors.lightBlue)),
        iconTheme: const IconThemeData(color: Colors.lightBlue),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Divider(),
              Container(
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      foregroundImage: AssetImage("assets/images/profile.jpg"),
                    ),
                    const SizedBox(width: 20),
                    const Expanded(
                      child: Text(
                        "Asmi Poudel",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    IconButton(
                      color: Colors.blueAccent,
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              const SizedBox(height: 20),
              
              
              
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.blue),
                title: const Text("Settings"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                },
              ),
              const Divider(),
              
              ListTile(
                leading: const Icon(Icons.feedback, color: Colors.blue),
                title: const Text("Give Feedback"),
                onTap: () {},
              ),
              const Divider(),
              
              ListTile(
                leading: const Icon(Icons.help, color: Colors.blue),
                title: const Text("Help"),
                onTap: () {},
              ),
              const Divider(),
              
              ListTile(
                leading: const Icon(Icons.dark_mode, color: Colors.blue),
                title: const Text("Dark Mode"),
                trailing: Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: _darkMode,
                    onChanged: toggleDarkMode,
                    activeColor: Colors.blueAccent,
                  ),
                ),
              ),
              const Divider(),
              
              ListTile(
                leading: const Icon(Icons.share, color: Colors.blue),
                title: const Text("Share App"),
                onTap: () {},
              ),
              const Divider(),

               ListTile(
                leading: const Icon(Icons.person_add, color: Colors.blue),
                title: const Text("Add Account"),
                onTap: _addAccount,
              ),
              const Divider(),
              
              
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: InkWell(
                  onTap: logout,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}