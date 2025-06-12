import 'package:brain_boost/models/deck_model.dart';
import 'package:hive/hive.dart';

class LocalStorageService {
  static const _recentDecksBox = 'recent_decks';

  Future<void> cacheRecentDecks(List<Deck> decks) async {
    final box = await Hive.openBox(_recentDecksBox);
    await box.put('decks', decks.map((d) => d.toHive()).toList());
  }


  Future<List<Deck>?> getCachedDecks() async {
    final box = await Hive.openBox(_recentDecksBox);
    final data = await box.get('decks') as List?;
    return data?.map((d) => Deck.fromHive(d)).toList();
  }
}