import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_boost/services/api_service.dart';
import 'package:brain_boost/services/deck_local_service.dart';
import 'package:brain_boost/services/deck_service.dart';

final deckLocalServiceInitProvider = FutureProvider<DeckLocalService>((ref) async {
  final localService = DeckLocalService();
  await localService.init();
  return localService;
});

final deckServiceProvider = Provider<DeckService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final localServiceAsync = ref.watch(deckLocalServiceInitProvider);

  // Handle loading/error cases for localService initialization:
  return localServiceAsync.when(
    data: (localService) => DeckService(apiService, localService),
    loading: () => throw Exception('LocalService not ready'),
    error: (err, _) => throw err,
  );
});
