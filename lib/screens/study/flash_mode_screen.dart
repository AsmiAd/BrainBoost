import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/deck_model.dart';
import '../../providers/deck_provider.dart';
import 'spaced_repetition_screen.dart';
import 'timed_mode_screen.dart';
import 'true_false_mode_screen.dart';

class FlashModeScreen extends ConsumerStatefulWidget {
  final String deckId;

  const FlashModeScreen({super.key, required this.deckId});

  @override
  ConsumerState<FlashModeScreen> createState() => _FlashModeScreenState();
}

class _FlashModeScreenState extends ConsumerState<FlashModeScreen> {
  List<Deck> decks = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDecks();
  }

  Future<void> loadDecks() async {
    final deckService = ref.read(deckServiceProvider);
    final fetchedDecks = await deckService.getAllDecks();
    setState(() {
      decks = fetchedDecks;
      loading = false;
    });
  }

  void _showModeSelection(Deck deck) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.repeat),
            title: const Text('Spaced Repetition'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => SpacedRepetitionScreen(deckId: deck.id),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text('Quiz Mode'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/quiz_mode', arguments: deck.id);
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_box),
            title: const Text('True/False Mode'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => TrueFalseModeStudyScreen(deck: deck),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Timed Mode'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => TimedModeStudyScreen(deck: deck),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.shuffle),
            title: const Text('Random Mix Mode'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/random_mix');
            },
          ),
          ListTile(
            leading: const Icon(Icons.style),
            title: const Text('Flashcard Review'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => FlashModeScreen(deckId: deck.id),
              ));
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (decks.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Study Modes')),
        body: const Center(child: Text('No decks available')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Select Deck to Study')),
      body: ListView.builder(
        itemCount: decks.length,
        itemBuilder: (context, index) {
          final deck = decks[index];
          return ListTile(
            title: Text(deck.name),
            subtitle: Text(deck.description ?? ''),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showModeSelection(deck),
          );
        },
      ),
    );
  }
}
