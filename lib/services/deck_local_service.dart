import 'package:hive/hive.dart';
import '../../models/deck_model.dart';

class DeckLocalService {
  static const _boxName = 'decks';
  late final Box<Deck> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Deck>(_boxName);
  }

  List<Deck> getAll() => _box.values.toList();

  Future<void> saveDeck(Deck deck) async {
    await _box.put(deck.id, deck);
  }

  Future<void> saveMany(List<Deck> decks) async {
    final map = {for (var d in decks) d.id: d};
    await _box.putAll(map);
  }

  Future<void> deleteDeck(String id) async => _box.delete(id);

  bool get isEmpty => _box.isEmpty;
}
