import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:brain_boost/core/constants/app_text_styles.dart';
import 'package:brain_boost/services/notification_service.dart';
import 'package:brain_boost/widgets/loading_indicator.dart';

import '../../core/providers/notification_provider.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () async {
              await NotificationService().markAllAsRead();
              ref.invalidate(notificationProvider);
            },
            tooltip: "Mark all as read",
          )
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (notifications) => notifications.isEmpty
            ? const Center(child: Text('No notifications'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: notifications.length,
                itemBuilder: (_, i) {
                  final notif = notifications[i];
                  final date = (notif['timestamp'] as Timestamp).toDate();
                  final read = notif['read'] == true;

                  return ListTile(
                    tileColor: read ? Colors.grey[100] : Colors.blue[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: Text(
                      notif['title'] ?? '',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: read ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      notif['message'] ?? '',
                      style: AppTextStyles.bodySmall,
                    ),
                    trailing: Text(
                      DateFormat('MMM d, h:mm a').format(date),
                      style: const TextStyle(fontSize: 11),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
