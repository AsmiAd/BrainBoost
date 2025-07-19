import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/test_result.dart';

final studyProgressServiceProvider = Provider((ref) => StudyProgressService());

class StudyProgressService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> saveTestResult({
    required String deckId,
    required int score,
    required int total,
    Duration? duration,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final date = DateTime.now();

    final result = TestResult(
      deckId: deckId,
      score: score,
      total: total,
      date: date,
      durationSeconds: duration?.inSeconds ?? 0,
    );

    // Save locally in Hive
    final box = await Hive.openBox<TestResult>('testResults');
    await box.add(result);

    // Save to Firestore for cross-device sync / stats
    final dateKey = "${date.year}-${date.month}-${date.day}";
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('testResults')
        .doc(dateKey)
        .set({
      'deckId': deckId,
      'score': score,
      'total': total,
      'date': date.toIso8601String(),
      'durationInSeconds': duration?.inSeconds ?? 0, 
    }, SetOptions(merge: true));
  }

  Future<List<TestResult>> getTodayTestResults() async {
    final date = DateTime.now();

    final box = await Hive.openBox<TestResult>('testResults');
    final allResults = box.values.toList();

    final todayResults = allResults.where((r) {
      return r.date.year == date.year &&
          r.date.month == date.month &&
          r.date.day == date.day;
    }).toList();

    return todayResults;
  }
}
