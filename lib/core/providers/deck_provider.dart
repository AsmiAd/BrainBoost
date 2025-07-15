import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_boost/services/api_service.dart';
import 'package:brain_boost/services/deck_local_service.dart';
import 'package:brain_boost/services/deck_service.dart';
import 'package:brain_boost/core/providers/auth_provider.dart';
import 'package:brain_boost/models/deck_model.dart';

final deckLocalServiceInitProvider = FutureProvider<DeckLocalService>((ref) async {
  final localService = DeckLocalService();
  await localService.init();
  return localService;
});

final deckServiceProvider = FutureProvider<DeckService>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final localService = await ref.watch(deckLocalServiceInitProvider.future);
  return DeckService(apiService, localService);
});

final decksProvider = FutureProvider.autoDispose<List<Deck>>((ref) {
  final userAsync = ref.watch(authStateProvider);

  return userAsync.when(
    data: (user) async {
      if (user == null) return [];
      final deckService = await ref.watch(deckServiceProvider.future);
      return deckService.getUserDecks(user.uid);
    },
    loading: () => Future.value([]),
    error: (_, __) => Future.value([]),
  );
});
