import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/deck_model.dart';

class DeckService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Deck>> getRecentDecks(String userId) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('decks')
        .orderBy('last_accessed', descending: true)
        .limit(20)
        .get();

    return querySnapshot.docs.map((doc) => Deck.fromFirestore(doc)).toList();
  }

  Future<List<Deck>> getUserDecks(String userId) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('decks')
        .get();

    return querySnapshot.docs.map((doc) => Deck.fromFirestore(doc)).toList();
  }
}
