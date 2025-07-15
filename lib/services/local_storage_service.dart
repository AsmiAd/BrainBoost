import 'package:brain_boost/models/deck_model.dart';
import 'package:hive/hive.dart';

class LocalStorageService {
  static const _recentDecksBox = 'recent_decks';

  Future<void> cacheRecentDecks(List<Deck> decks) async {
    final box = await Hive.openBox<Deck>(_recentDecksBox);
    for (var deck in decks) {
      await box.put(deck.id, deck);
    }
  }

  Future<List<Deck>> getCachedDecks() async {
    final box = await Hive.openBox<Deck>(_recentDecksBox);
    return box.values.toList();
  }
}
