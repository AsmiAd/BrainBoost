import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/deck_model.dart';
import '../../models/flashcard_model.dart';
import '../../providers/deck_provider.dart';
import '../../services/study_progress_service.dart';

class TimedModeStudyScreen extends ConsumerStatefulWidget {
  final Deck deck;
  const TimedModeStudyScreen({super.key, required this.deck});

  @override
  ConsumerState<TimedModeStudyScreen> createState() => _TimedModeScreenState();
}

class _TimedModeScreenState extends ConsumerState<TimedModeStudyScreen> {
  List<Flashcard> cards = [];
  int currentIndex = 0;
  int score = 0;
  int timeLeft = 30;
  Timer? timer;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadCards();
  }

  Future<void> loadCards() async {
    final deckService = ref.read(deckServiceProvider);
    final fetchedCards = await deckService.getFlashcards(widget.deck.id);
    setState(() {
      cards = fetchedCards;
      loading = false;
    });
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    timeLeft = 30;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft == 0) {
        nextCard();
      } else {
        setState(() => timeLeft--);
      }
    });
  }

  void nextCard() {
    if (currentIndex == cards.length - 1) {
      timer?.cancel();
      finish();
    } else {
      setState(() {
        currentIndex++;
        timeLeft = 30;
      });
      startTimer();
    }
  }

  void answer(bool correct) {
    if (correct) score++;
    nextCard();
  }

  Future<void> finish() async {
    await ref.read(studyProgressServiceProvider).saveTestResult(
      deckId: widget.deck.id,
      score: score,
      total: cards.length,
    );
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Timed Mode Finished"),
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
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final card = cards[currentIndex];
    return Scaffold(
      appBar: AppBar(title: Text("Timed Mode: ${widget.deck.name}")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text("Time Left: $timeLeft", style: const TextStyle(fontSize: 20)),
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
