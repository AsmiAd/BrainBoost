import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class WelcomeNotificationBar extends StatelessWidget {
  final String userName;

  const WelcomeNotificationBar({super.key, this.userName = "User"});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hi, $userName 👋',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primary,
              size: 28,
            ),
            onPressed: () {
              // TODO: Navigate to notifications screen
            },
          ),
        ],
      ),
    );
  }
}
