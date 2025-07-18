// lib/services/flashcard_local_service.dart
import 'package:hive/hive.dart';
import '../models/flashcard_model.dart';

class FlashcardLocalService {
  static const _boxPrefix = 'flashcards_'; // unique per deck

  Future<Box<Flashcard>> _openBox(String deckId) async {
    return Hive.openBox<Flashcard>('$_boxPrefix$deckId');
  }

  Future<List<Flashcard>> getCards(String deckId) async {
    final box = await _openBox(deckId);
    return box.values.toList();
  }

  Future<void> saveMany(String deckId, List<Flashcard> cards) async {
    final box = await _openBox(deckId);
    final map = {for (var c in cards) c.id: c};
    await box.putAll(map);
  }

  Future<void> saveOne(String deckId, Flashcard card) async {
    final box = await _openBox(deckId);
    await box.put(card.id, card);
  }

  Future<void> delete(String deckId, String id) async {
    final box = await _openBox(deckId);
    await box.delete(id);
  }

  Future<void> clearBox(String deckId) async {
    final box = await _openBox(deckId);
    await box.clear();
  }

  Future<bool> isEmpty(String deckId) async {
    final box = await _openBox(deckId);
    return box.isEmpty;
  }
}
