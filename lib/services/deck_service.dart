import 'package:brain_boost/models/deck_model.dart';
import 'package:brain_boost/models/flashcard_model.dart';
import 'package:brain_boost/services/api_service.dart';
import 'package:brain_boost/services/deck_local_service.dart';
import 'package:brain_boost/services/flashcard_local_service.dart';

class DeckService {
  final ApiService _api;
  final DeckLocalService _deckLocal;
  final FlashcardLocalService _cardLocal;

  DeckService(this._api, this._deckLocal, this._cardLocal);

  /// Fetch decks from cache (if available), else from API, then save to cache
  Future<List<Deck>> getUserDecks(String userId) async {
    if (!_deckLocal.isEmpty) {
      return _deckLocal.getAll();
    }
    final decks = await _api.fetchDecks(onlyPublic: false);
    await _deckLocal.saveMany(decks);
    return decks;
  }

  /// Used in StudyScreen: sync decks from API then return local cache
  Future<List<Deck>> getCachedDecksAfterSync() async {
    final decks = await _api.fetchDecks(onlyPublic: false);
    await _deckLocal.saveMany(decks);
    return _deckLocal.getAll();
  }

  /// Used in HomeScreen: syncs only
  Future<void> sync() async {
    final decks = await _api.fetchDecks(onlyPublic: false);
    await _deckLocal.saveMany(decks);
  }

  /// Used in HomeScreen to get locally cached decks after sync
  List<Deck> getAllDecks() {
    return _deckLocal.getAll();
  }

  /// Flashcard operations
  Future<List<Flashcard>> getFlashcards(String deckId) async {
    if (!await _cardLocal.isEmpty(deckId)) {
      return await _cardLocal.getCards(deckId);
    }
    final cards = await _api.fetchCards(deckId);
    await _cardLocal.saveMany(deckId, cards);
    return cards;
  }

  Future<void> updateFlashcard(String deckId, Flashcard card) async {
    await _api.updateFlashcard(deckId, card);
    await _cardLocal.saveOne(deckId, card);
  }

  /// ✅ CREATE deck, save flashcards, and cache locally
Future<void> createDeckWithCards(Deck deck, List<Flashcard> cards) async {
  try {
    // Step 1: Create the deck
    final createdDeck = await _api.createDeck(deck);

    // Step 2: Save cards with correct deck ID
    final updatedCards = cards.map((card) => card.copyWith(deckId: createdDeck.id)).toList();

    // ✅ Use positional parameters here
    await _api.saveManyCards(createdDeck.id, updatedCards);

    // Step 3: Save locally
    await _deckLocal.saveOne(createdDeck);
    await _cardLocal.saveMany(createdDeck.id, updatedCards);

    print('✅ Deck and cards created successfully');
  } catch (e) {
    print('❌ Error in createDeckWithCards: $e');
    rethrow;
  }
}

}
