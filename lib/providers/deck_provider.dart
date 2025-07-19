import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_boost/services/api_service.dart';
import 'package:brain_boost/services/deck_local_service.dart';
import 'package:brain_boost/services/deck_service.dart';
import 'package:brain_boost/services/flashcard_local_service.dart';
import 'package:brain_boost/providers/auth_provider.dart';
import 'package:brain_boost/models/deck_model.dart';

/// Initialize DeckLocalService
final deckLocalServiceInitProvider = FutureProvider<DeckLocalService>((ref) async {
  final localService = DeckLocalService();
  await localService.init();
  return localService;
});

/// Initialize FlashcardLocalService
final flashcardLocalServiceInitProvider = FutureProvider<FlashcardLocalService>((ref) async {
  return FlashcardLocalService();
});

/// Provide DeckService with API + Local services
final deckServiceProvider = Provider<DeckService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final deckLocalServiceAsync = ref.watch(deckLocalServiceInitProvider);
  final flashcardLocalServiceAsync = ref.watch(flashcardLocalServiceInitProvider);

  // Ensure both services are ready
  if (deckLocalServiceAsync.isLoading || flashcardLocalServiceAsync.isLoading) {
    throw Exception('Deck or Flashcard LocalService not initialized yet.');
  }
  if (deckLocalServiceAsync.hasError) throw deckLocalServiceAsync.error!;
  if (flashcardLocalServiceAsync.hasError) throw flashcardLocalServiceAsync.error!;

  final deckLocal = deckLocalServiceAsync.value!;
  final flashcardLocal = flashcardLocalServiceAsync.value!;

  return DeckService(apiService, deckLocal, flashcardLocal);
});

/// Provide user's personal decks (autoDispose for better memory)
final decksProvider = FutureProvider.autoDispose<List<Deck>>((ref) async {
  final userAsync = ref.watch(authStateProvider);

  return userAsync.when(
    data: (user) async {
      if (user == null) return [];
      final deckService = ref.watch(deckServiceProvider);
      return await deckService.getUserDecks(user.uid);
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
