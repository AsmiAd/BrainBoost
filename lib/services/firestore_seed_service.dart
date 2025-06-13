import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreSeedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> seedUserStudyProgress() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Not logged in");

    final uid = user.uid;

    final List<Map<String, dynamic>> weekData = [
      {'timePeriod': 'Monday', 'actualMinutes': 40, 'goalMinutes': 60},
      {'timePeriod': 'Tuesday', 'actualMinutes': 50, 'goalMinutes': 60},
      {'timePeriod': 'Wednesday', 'actualMinutes': 20, 'goalMinutes': 60},
      {'timePeriod': 'Thursday', 'actualMinutes': 60, 'goalMinutes': 60},
      {'timePeriod': 'Friday', 'actualMinutes': 70, 'goalMinutes': 60},
      {'timePeriod': 'Saturday', 'actualMinutes': 45, 'goalMinutes': 60},
      {'timePeriod': 'Sunday', 'actualMinutes': 30, 'goalMinutes': 60},
    ];

    final batch = _firestore.batch();
    final weekRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc('week')
        .collection('records');

    for (final record in weekData) {
      final docRef = weekRef.doc(record['timePeriod']);
      batch.set(docRef, record);
    }

    await batch.commit();
    print("✅ Study progress for week added successfully.");
  }

  Future<void> seedLeaderboard({String timeRange = 'week'}) async {
    final leaderboardRef = _firestore
        .collection('leaderboard')
        .doc(timeRange)
        .collection('users');

    final List<Map<String, dynamic>> leaderboardUsers = [
      {
        'name': 'Alice',
        'points': 320,
        'avatarUrl': 'https://i.pravatar.cc/150?img=1',
      },
      {
        'name': 'Bob',
        'points': 280,
        'avatarUrl': 'https://i.pravatar.cc/150?img=2',
      },
      {
        'name': 'Charlie',
        'points': 260,
        'avatarUrl': 'https://i.pravatar.cc/150?img=3',
      },
    ];

    final batch = _firestore.batch();

    for (final user in leaderboardUsers) {
      final docRef = leaderboardRef.doc(user['name'].toLowerCase());
      batch.set(docRef, user);
    }

    await batch.commit();
    print("✅ Leaderboard ($timeRange) seeded successfully.");
  }
}
