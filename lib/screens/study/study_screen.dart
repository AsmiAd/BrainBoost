import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_boost/models/deck_model.dart';
import 'package:brain_boost/widgets/loading_indicator.dart';
import 'package:brain_boost/widgets/error_retry_widget.dart';

import '../../core/providers/deck_provider.dart';

final studyDecksProvider = FutureProvider.autoDispose<List<Deck>>((ref) async {
  final service = ref.watch(deckServiceProvider);
  return service.getCachedDecksAfterSync();
});


class StudyScreen extends ConsumerWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decksAsync = ref.watch(studyDecksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Study')),
      body: decksAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorRetryWidget(
          error: error,
          onRetry: () => ref.refresh(studyDecksProvider),
        ),
        data: (decks) {
          if (decks.isEmpty) {
            return const Center(child: Text("No decks available."));
          }

          return ListView.builder(
            itemCount: decks.length,
            itemBuilder: (context, index) {
              final deck = decks[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(deck.name),
                  subtitle: const Text('Choose a mode'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Flash') {
                        Navigator.pushNamed(
                          context,
                          '/flash_mode',
                          arguments: deck.id,
                        );
                      } else if (value == 'Spaced') {
                        Navigator.pushNamed(
                          context,
                          '/spaced_repetition',
                          arguments: deck.id,
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'Flash', child: Text('Flash Mode')),
                      const PopupMenuItem(value: 'Spaced', child: Text('Spaced Repetition')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
