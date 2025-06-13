
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/leaderboard_user.dart';
import '../models/study_progress.dart';

class StatisticService {
  final _firestore = FirebaseFirestore.instance;

  Future<List<StudyProgress>> fetchStudyProgress(String uid, String timeRange) async {
  final snap = await _firestore
      .collection('users')
      .doc(uid)
      .collection('progress')
      .doc(timeRange)
      .collection('records')
      .get();

  return snap.docs.map((d) {
    final m = d.data();
    return StudyProgress(
      timePeriod: m['timePeriod'] ?? '',
      actualMinutes: m['actualMinutes'] ?? 0,
      goalMinutes: m['goalMinutes'] ?? 0,
    );
  }).toList();
}

  Future<List<LeaderboardUser>> fetchLeaderboard(String timeRange) async {
    final snap = await _firestore
        .collection('leaderboard')
        .doc(timeRange)
        .collection('users')
        .orderBy('points', descending: true)
        .get();
    return snap.docs.map((d) => LeaderboardUser.fromMap(d.data())).toList();
  }
}
