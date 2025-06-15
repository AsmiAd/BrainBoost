import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/flashcard_model.dart';
import '../models/deck_model.dart';

class DeckService {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Flashcard>> getFlashcards(String deckId) async {
    final snap = await _firestore
        .collection('decks')
        .doc(deckId)
        .collection('flashcards')
        .get();

    return snap.docs.map((doc) => Flashcard.fromMap(doc.id, doc.data())).toList();
  }

  Future<List<Deck>> getRecentDecks(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('decks')
        .orderBy('last_accessed', descending: true)
        .limit(10)
        .get();

    return snapshot.docs.map((doc) => Deck.fromFirestore(doc)).toList();
  }

  Future<List<Deck>> getUserDecks(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('decks')
        .orderBy('last_accessed', descending: true)
        .get();

    return snapshot.docs.map((doc) => Deck.fromFirestore(doc)).toList();
  }

  Future<void> updateFlashcard(String deckId, Flashcard card) async {
    await _firestore
        .collection('decks')
        .doc(deckId)
        .collection('flashcards')
        .doc(card.id)
        .update(card.toMap());
  }
}
