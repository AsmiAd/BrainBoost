import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/flashcard_model.dart';

class SpacedRepetitionService {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Flashcard>> fetchDueFlashcards(String userId) async {
    final decks = await _firestore.collection('users').doc(userId).collection('decks').get();

    List<Flashcard> dueCards = [];

    for (var deckDoc in decks.docs) {
      final flashcards = await deckDoc.reference.collection('flashcards').get();

      for (var card in flashcards.docs) {
        final flashcard = Flashcard.fromMap(card.id, card.data());

        // Convert Timestamp to DateTime if needed
        final nextReview = (card.data()['nextReview'] as Timestamp).toDate();

        if (nextReview.isBefore(DateTime.now())) {
          dueCards.add(flashcard);
        }
      }
    }

    return dueCards;
  }

  Future<void> updateFlashcardAfterReview(
      String userId, String deckId, Flashcard card, bool isCorrect) async {
    final currentEase = card.easeFactor;
    final newInterval = isCorrect ? (card.interval * currentEase).round() : 1;
    final newEaseFactor = isCorrect
        ? currentEase + 0.1
        : (currentEase - 0.2).clamp(1.3, 2.5);
    final nextReview = DateTime.now().add(Duration(days: newInterval));

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('decks')
        .doc(deckId)
        .collection('flashcards')
        .doc(card.id)
        .update({
      'interval': newInterval,
      'easeFactor': newEaseFactor,
      'nextReview': Timestamp.fromDate(nextReview),
    });
  }
}
