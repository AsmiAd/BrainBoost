import 'dart:async';
import 'package:hive/hive.dart';

class NotificationService {
  static const _boxName = 'notifications';
  late Box<Map> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Map>(_boxName);
  }

  // Stream that emits the number of unread notifications every 3 seconds
  Stream<int> unreadCountStream() async* {
    while (true) {
      final unreadCount = _box.values.where((notif) => notif['read'] == false).length;
      yield unreadCount;
      await Future.delayed(Duration(seconds: 3));
    }
  }

  Future<void> addNotification(String title, String message) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await _box.put(id, {
      'title': title,
      'message': message,
      'read': false,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<void> markAllRead() async {
    for (final key in _box.keys) {
      final notif = _box.get(key);
      if (notif != null && notif['read'] == false) {
        await _box.put(key, {...notif, 'read': true});
      }
    }
  }

  List<Map> getAllNotifications() {
    return _box.values.toList();
  }
}
