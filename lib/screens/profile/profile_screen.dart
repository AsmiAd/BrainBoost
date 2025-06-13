import 'package:brain_boost/screens/profile/edit_page.dart';
import 'package:brain_boost/screens/profile/settings_page.dart';
import 'package:brain_boost/screens/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/providers/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: ${e.toString()}')),
        );
      }
    }
  }

  void _addAccount(BuildContext context) {
    Navigator.of(context).pushNamed('/add-account');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
            icon: const Icon(Icons.notifications),
            color: AppColors.primary,
          ),
        ],
        title: Text(
          "Profile",
          style: AppTextStyles.headingSmall.copyWith(color: AppColors.primary),
        ),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Divider(),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    foregroundImage: AssetImage("assets/images/profile.jpg"),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ref.watch(usernameProvider).when(
                      data: (username) {
                        debugPrint("Username fetched: $username"); // <-- DEBUG PRINT
                        return Text(
                          username,
                          style: AppTextStyles.headingSmall
                              .copyWith(color: AppColors.primary),
                        );
                      },
                      loading: () {
                        debugPrint("Username loading...");
                        return const CircularProgressIndicator();
                      },
                      error: (error, stack) {
                        debugPrint(
                            "Error fetching username: $error"); // <-- DEBUG PRINT
                        return Text(
                          'User',
                          style: AppTextStyles.headingSmall
                              .copyWith(color: AppColors.primary),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    color: AppColors.primary,
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
              const Divider(),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.settings, color: AppColors.primary),
                title: Text("Settings", style: AppTextStyles.bodyMedium),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.feedback, color: AppColors.primary),
                title: Text("Give Feedback", style: AppTextStyles.bodyMedium),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help, color: AppColors.primary),
                title: Text("Help", style: AppTextStyles.bodyMedium),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.dark_mode, color: AppColors.primary),
                title: Text("Dark Mode", style: AppTextStyles.bodyMedium),
                trailing: Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      ref.read(themeProvider.notifier).toggleTheme();
                    },
                    activeColor: AppColors.primary,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.share, color: AppColors.primary),
                title: Text("Share App", style: AppTextStyles.bodyMedium),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person_add, color: AppColors.primary),
                title: Text("Add Account", style: AppTextStyles.bodyMedium),
                onTap: () => _addAccount(context),
              ),
              const Divider(),
              // Updated Logout Button with Rounded Rectangle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.logout, color: AppColors.error),
                    label: Text(
                      "Logout",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => logout(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
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
