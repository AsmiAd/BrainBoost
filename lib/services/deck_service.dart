import 'package:brain_boost/models/deck_model.dart';
import 'package:brain_boost/models/flashcard_model.dart';  // Add this
import 'package:brain_boost/services/api_service.dart';
import 'package:brain_boost/services/deck_local_service.dart';

class DeckService {
  final ApiService _api;
  final DeckLocalService _local;

  DeckService(this._api, this._local);

  Future<List<Deck>> getUserDecks(String userId) async {
    if (!_local.isEmpty) {
      return _local.getAll();
    }
    final decks = await _api.fetchDecks(onlyPublic: false);
    await _local.saveMany(decks);
    return decks;
  }

  Future<List<Flashcard>> getFlashcards(String deckId) async {
    return _api.fetchCards(deckId);
  }

  Future<void> updateFlashcard(String deckId, Flashcard card) async {
    // Call ApiService method to update flashcard
    await _api.updateFlashcard(deckId, card);
  }
}
