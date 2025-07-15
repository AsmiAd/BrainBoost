import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NotificationService();
  service.init(); // Initialize Hive box
  return service;
});

final notificationProvider = StreamProvider.autoDispose<int>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return service.unreadCountStream();
});
