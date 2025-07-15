// lib/core/providers/deck_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../models/deck_model.dart';
import '../../services/api_service.dart';

final deckRepositoryProvider = Provider<DeckRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final box = Hive.box<Deck>('decks');
  return DeckRepository(apiService, box);
});

class DeckRepository {
  DeckRepository(this._apiService, this._box);

  final ApiService _apiService;
  final Box<Deck> _box;

  /// Synchronize remote decks with local cache
  Future<void> sync() async {
    final remoteDecks = await _apiService.fetchDecks(onlyPublic: false);
    await _box.clear();
    for (var deck in remoteDecks) {
      await _box.put(deck.id, deck);
    }
  }

  /// Return all locally cached decks
  List<Deck> getAllDecks() => _box.values.toList();

  /// Add a new deck (remote + local)
  Future<void> addDeck(Deck deck) async {
    final createdDeck = await _apiService.createDeck(deck);
    await _box.put(createdDeck.id, createdDeck);
  }
}
