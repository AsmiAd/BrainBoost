import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/flashcard_model.dart';
import '../../providers/deck_provider.dart';
import '../../services/study_progress_service.dart';

class RandomMixStudyScreen extends ConsumerStatefulWidget {
  const RandomMixStudyScreen({super.key});

  @override
  ConsumerState<RandomMixStudyScreen> createState() => _RandomMixScreenState();
}

class _RandomMixScreenState extends ConsumerState<RandomMixStudyScreen> {
  List<Flashcard> cards = [];
  int currentIndex = 0;
  int score = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAllCards();
  }

  Future<void> loadAllCards() async {
    final deckService = ref.read(deckServiceProvider);
    final decks = deckService.getAllDecks();
    List<Flashcard> allCards = [];
    for (final deck in decks) {
      final deckCards = await deckService.getFlashcards(deck.id);
      allCards.addAll(deckCards);
    }
    allCards.shuffle(Random());
    setState(() {
      cards = allCards;
      loading = false;
    });
  }

  void answer(bool correct) {
    if (correct) score++;
    if (currentIndex == cards.length - 1) {
      finish();
    } else {
      setState(() => currentIndex++);
    }
  }

  Future<void> finish() async {
    await ref.read(studyProgressServiceProvider).saveTestResult(
      deckId: "random_mix",
      score: score,
      total: cards.length,
    );
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Random Mix Finished"),
        content: Text("Score: $score / ${cards.length}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final card = cards[currentIndex];
    return Scaffold(
      appBar: AppBar(title: const Text("Random Mix Mode")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text("Card ${currentIndex + 1} of ${cards.length}", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text(card.question, style: const TextStyle(fontSize: 22)),
            const Spacer(),
            ElevatedButton(onPressed: () => answer(true), child: const Text("Correct")),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () => answer(false), child: const Text("Incorrect")),
          ],
        ),
      ),
    );
  }
}
