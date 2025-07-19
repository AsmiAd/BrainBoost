import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_boost/models/deck_model.dart';
import 'package:brain_boost/widgets/deck_card.dart';

import '../../providers/deck_provider.dart';


final decksProvider = FutureProvider.autoDispose<List<Deck>>((ref) {
  final userId = 'user123'; // replace with real user ID from auth provider
  final deckService = ref.watch(deckServiceProvider);
  return deckService.getUserDecks(userId);
});

class DecksScreen extends ConsumerWidget {
  const DecksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decksAsync = ref.watch(decksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Decks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(decksProvider.future),
        child: decksAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
          data: (decks) {
            if (decks.isEmpty) {
              return const Center(child: Text('No decks found.'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: decks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) => DeckCard(
                deck: decks[index],
                onTap: () => _openDeck(context, decks[index].id),
                color: _getDeckColor(index),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/add-deck'),
      ),
    );
  }

  Color _getDeckColor(int index) {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple];
    return colors[index % colors.length];
  }

  void _openDeck(BuildContext context, String deckId) {
  Navigator.pushNamed(
    context,
    '/flashcards', // ← not '/deck-details' if you want flashcards
    arguments: deckId,
  );
}
}