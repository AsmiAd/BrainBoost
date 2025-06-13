import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../../models/study_progress.dart';
import '../../models/leaderboard_user.dart';
import 'auth_provider.dart';

final studyProgressProvider = FutureProvider.family<List<StudyProgress>, String>((ref, timeRange) async {
  final user = ref.read(authStateProvider).valueOrNull;
  if (user == null) return [];

  final uid = user.uid;
  final firestore = FirebaseFirestore.instance;
  final box = await Hive.openBox('study_progress_cache');

  try {
    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc(timeRange)
        .collection('records')
        .get();

    final result = snapshot.docs.map((doc) => StudyProgress.fromMap(doc.data())).toList();

    // cache
    await box.put('progress_$timeRange', result.map((e) => e.toMap()).toList());

    return result;
  } catch (e) {
    // fallback to Hive cache
    final cached = box.get('progress_$timeRange');
    if (cached != null) {
      return List<Map<String, dynamic>>.from(cached)
          .map((e) => StudyProgress.fromMap(e))
          .toList();
    }
    return [];
  }
});

final leaderboardProvider = FutureProvider.family<List<LeaderboardUser>, String>((ref, timeRange) async {
  final firestore = FirebaseFirestore.instance;
  final box = await Hive.openBox('leaderboard_cache');

  try {
    final snapshot = await firestore
        .collection('leaderboard')
        .doc(timeRange)
        .collection('users')
        .orderBy('points', descending: true)
        .get();

    final result = snapshot.docs.map((doc) => LeaderboardUser.fromMap(doc.data())).toList();

    // cache
    await box.put('leaderboard_$timeRange', result.map((e) => e.toMap()).toList());

    return result;
  } catch (e) {
    // fallback to Hive
    final cached = box.get('leaderboard_$timeRange');
    if (cached != null) {
      return List<Map<String, dynamic>>.from(cached)
          .map((e) => LeaderboardUser.fromMap(e))
          .toList();
    }
    return [];
  }
});
