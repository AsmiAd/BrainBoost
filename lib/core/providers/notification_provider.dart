import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_boost/services/notification_service.dart';

final notificationProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final service = NotificationService();
  return await service.fetchNotifications();
});
