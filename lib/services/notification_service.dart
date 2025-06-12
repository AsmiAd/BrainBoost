import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    if (_userId == null) return [];

    final snapshot = await _firestore
        .collection('notifications')
        .doc(_userId)
        .collection('user_notifications')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> markAllAsRead() async {
    if (_userId == null) return;

    final snapshot = await _firestore
        .collection('notifications')
        .doc(_userId)
        .collection('user_notifications')
        .where('read', isEqualTo: false)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({'read': true});
    }
  }

  Future<void> addNotification(String title, String message) async {
    if (_userId == null) return;

    await _firestore
        .collection('notifications')
        .doc(_userId)
        .collection('user_notifications')
        .add({
      'title': title,
      'message': message,
      'timestamp': Timestamp.now(),
      'read': false,
    });
  }
}
