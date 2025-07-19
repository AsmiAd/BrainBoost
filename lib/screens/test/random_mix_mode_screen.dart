import 'package:flutter/material.dart';
import '../../models/flashcard_model.dart';
import '../../providers/deck_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/study_progress_service.dart';
import 'dart:math';

class RandomMixScreen extends ConsumerStatefulWidget {
  const RandomMixScreen({super.key});

  @override
  ConsumerState<RandomMixScreen> createState() => _RandomMixScreenState();
}

class _RandomMixScreenState extends ConsumerState<RandomMixScreen> {
  List<Flashcard> _cards = [];
  int _currentIndex = 0;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _loadAllCards();
  }

  Future<void> _loadAllCards() async {
    final service = ref.read(deckServiceProvider);
    final decks = await service.getAllDecks();
    List<Flashcard> allCards = [];
    for (final d in decks) {
      final cards = await service.getFlashcards(d.id);
      allCards.addAll(cards);
    }
    allCards.shuffle(Random());
    setState(() => _cards = allCards);
  }

  void _answer(bool correct) {
    if (correct) _score++;
    if (_currentIndex < _cards.length - 1) {
      setState(() => _currentIndex++);
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await ref.read(studyProgressServiceProvider).saveTestResult(
      deckId: "random",
      score: _score,
      total: _cards.length,
    );
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Random Mix Finished"),
        content: Text("Score: $_score / ${_cards.length}"),
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
    if (_cards.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final card = _cards[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Random Mix Mode")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(card.question, style: const TextStyle(fontSize: 20)),
            const Spacer(),
            ElevatedButton(onPressed: () => _answer(true), child: const Text("Correct")),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () => _answer(false), child: const Text("Incorrect")),
          ],
        ),
      ),
    );
  }
}
