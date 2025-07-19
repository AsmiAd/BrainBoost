import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TestResultService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> saveResult({
    required String deckId,
    required String mode,
    required int score,
    required int totalQuestions,
    required Duration duration,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final uid = user.uid;
    final testRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc('tests')
        .collection('records')
        .doc();

    await testRef.set({
      'deckId': deckId,
      'mode': mode,
      'score': score,
      'totalQuestions': totalQuestions,
      'timestamp': FieldValue.serverTimestamp(),
      'durationSeconds': duration.inSeconds,
    });
  }
}
