import 'package:hive/hive.dart';
import '../../models/deck_model.dart';

class DeckLocalService {
  static const _boxName = 'decks';
  late final Box<Deck> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Deck>(_boxName);
  }

  List<Deck> getAll() => _box.values.toList();

  Future<void> saveOne(Deck deck) async {
  // If you're using Hive or SharedPreferences, save the single deck here
  final current = getAll();
  current.removeWhere((d) => d.id == deck.id);
  current.add(deck);
  await saveMany(current);
}

  Future<void> saveMany(List<Deck> decks) async {
    final map = {for (var d in decks) d.id: d};
    await _box.putAll(map);
  }

  Future<void> deleteDeck(String id) async => _box.delete(id);

  bool get isEmpty => _box.isEmpty;
}
