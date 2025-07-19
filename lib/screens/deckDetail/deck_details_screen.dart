import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_boost/widgets/deck_card.dart';
import 'package:brain_boost/models/deck_model.dart';

class DeckDetailsScreen extends ConsumerWidget {
  final String deckId;

  const DeckDetailsScreen({super.key, required this.deckId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deck = Deck(
      id: deckId,
      name: 'Deck Details',
      cardCount: 15,
      lastAccessed: DateTime.now(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(deck.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DeckCard(
              deck: deck,
              onTap: () {}, 
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.school),
                    label: const Text('Study'),
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/study',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.quiz),
                    label: const Text('Test'),
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/test',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Flashcards',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}