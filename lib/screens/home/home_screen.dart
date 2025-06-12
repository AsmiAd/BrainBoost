import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_boost/core/constants/app_text_styles.dart';
import 'package:brain_boost/core/providers/auth_provider.dart';
import 'package:brain_boost/models/deck_model.dart';
import 'package:brain_boost/services/deck_service.dart';
import 'package:brain_boost/services/local_storage_service.dart';
import 'package:brain_boost/widgets/deck_card.dart';
import 'package:brain_boost/widgets/error_retry_widget.dart';
import 'package:brain_boost/widgets/loading_indicator.dart';

/// Provider to fetch recent decks from Firestore or fallback to Hive.
final recentDecksProvider = FutureProvider.autoDispose<List<Deck>>((ref) async {
  final userId = ref.watch(authStateProvider).value?.uid;
  if (userId == null) return [];

  final deckService = DeckService();
  final localStorage = LocalStorageService();

  try {
    final remoteDecks = await deckService.getRecentDecks(userId);
    await localStorage.cacheRecentDecks(remoteDecks);
    return remoteDecks;
  } catch (e) {
    final cached = await localStorage.getCachedDecks();
    if (cached != null) return cached;
    throw e;
  }
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decksAsync = ref.watch(recentDecksProvider);
    final firestoreUserAsync = ref.watch(firestoreUserProvider);

    return Scaffold(
      appBar: _buildAppBar(context, firestoreUserAsync),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(recentDecksProvider.future),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(context),
                const SizedBox(height: 20),
                _buildActionButtons(context),
                const SizedBox(height: 24),
                Text('Recent Decks', style: AppTextStyles.headingSmall),
                const SizedBox(height: 12),
                Expanded(
                  child: decksAsync.when(
                    loading: () => const LoadingIndicator(),
                    error: (error, _) => ErrorRetryWidget(
                      error: error,
                      onRetry: () => ref.refresh(recentDecksProvider),
                    ),
                    data: (decks) => decks.isEmpty
                        ? const Center(child: Text('No decks found'))
                        : ListView.separated(
                            itemCount: decks.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (_, index) => DeckCard(
                              deck: decks[index],
                              onTap: () => _openDeck(context, decks[index].id),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, AsyncValue<Map<String, dynamic>?> firestoreUserAsync) {
    return AppBar(
      title: firestoreUserAsync.when(
        loading: () => const Text('Hi... 👋'),
        error: (_, __) => const Text('Hi User 👋'),
        data: (userData) {
          final name = userData?['name'] ?? 'User';
          return Text('Hi $name 👋', style: AppTextStyles.headingSmall);
        },
      ),
      actions: [
        IconButton(
          icon: Badge(
            smallSize: 8,
            child: const Icon(Icons.notifications_none),
          ),
          onPressed: () => _showNotifications(context),
        ),
      ],
    );
  }

  void _showNotifications(BuildContext context) {
  Navigator.pushNamed(context, '/notifications');
}


  Widget _buildSearchBar(BuildContext context) => TextField(
        decoration: InputDecoration(
          hintText: 'Search decks...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onTap: () => Navigator.pushNamed(context, '/search'),
      );

  Widget _buildActionButtons(BuildContext context) => Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.school),
              label: const Text('Study'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () => Navigator.pushNamed(context, '/study'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.quiz),
              label: const Text('Test'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () => Navigator.pushNamed(context, '/test'),
            ),
          ),
        ],
      );

  void _openDeck(BuildContext context, String deckId) {
    Navigator.pushNamed(
      context,
      '/deck-details',
      arguments: deckId,
    );
  }
}
