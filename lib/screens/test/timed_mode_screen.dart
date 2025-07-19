import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/deck_model.dart';
import '../../models/flashcard_model.dart';
import '../../providers/deck_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/study_progress_service.dart';

class TimedModeScreen extends ConsumerStatefulWidget {
  final Deck deck;
  const TimedModeScreen({super.key, required this.deck});

  @override
  ConsumerState<TimedModeScreen> createState() => _TimedModeScreenState();
}

class _TimedModeScreenState extends ConsumerState<TimedModeScreen> {
  List<Flashcard> _cards = [];
  int _currentIndex = 0;
  int _score = 0;
  int _timeLeft = 30;
  Timer? _timer;

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
      _startTimer();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft == 0) {
        _nextQuestion();
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _cards.length - 1) {
      setState(() {
        _currentIndex++;
        _startTimer();
      });
    } else {
      _timer?.cancel();
      _finish();
    }
  }

  void _answer(bool correct) {
    if (correct) _score++;
    _nextQuestion();
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
        title: const Text("Timed Test Finished"),
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
      appBar: AppBar(title: Text("Timed Mode: ${widget.deck.name}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Time Left: $_timeLeft", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
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
