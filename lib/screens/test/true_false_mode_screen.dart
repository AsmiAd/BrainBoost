import 'package:flutter/material.dart';
import '../../models/deck_model.dart';
import '../../models/flashcard_model.dart';
import '../../providers/deck_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/study_progress_service.dart';
import 'dart:math';

class TrueFalseModeScreen extends ConsumerStatefulWidget {
  final Deck deck;
  const TrueFalseModeScreen({super.key, required this.deck});

  @override
  ConsumerState<TrueFalseModeScreen> createState() => _TrueFalseModeScreenState();
}

class _TrueFalseModeScreenState extends ConsumerState<TrueFalseModeScreen> {
  List<Flashcard> _cards = [];
  int _currentIndex = 0;
  int _score = 0;
  String? _displayedAnswer;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final service = ref.read(deckServiceProvider);
    final cards = await service.getFlashcards(widget.deck.id);
    setState(() {
      _cards = cards;
      _randomizeAnswer();
    });
  }

  void _randomizeAnswer() {
    final card = _cards[_currentIndex];
    final random = Random();
    _displayedAnswer =
        random.nextBool() ? card.answer : _cards[random.nextInt(_cards.length)].answer;
  }

  void _answer(bool isTrue) {
    final correct = _displayedAnswer == _cards[_currentIndex].answer;
    if ((isTrue && correct) || (!isTrue && !correct)) _score++;
    if (_currentIndex < _cards.length - 1) {
      setState(() {
        _currentIndex++;
        _randomizeAnswer();
      });
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await ref.read(studyProgressServiceProvider).saveTestResult(
      deckId: widget.deck.id,
      score: _score,
      total: _cards.length,
    );
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("True/False Finished"),
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
      appBar: AppBar(title: Text("True/False: ${widget.deck.name}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(card.question, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Text(_displayedAnswer!, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => _answer(true), child: const Text("True")),
                ElevatedButton(onPressed: () => _answer(false), child: const Text("False")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
