import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/deck_model.dart';
import '../../models/flashcard_model.dart';
import '../../providers/deck_provider.dart';
import '../../services/study_progress_service.dart';

class TrueFalseModeStudyScreen extends ConsumerStatefulWidget {
  final Deck deck;
  const TrueFalseModeStudyScreen({super.key, required this.deck});

  @override
  ConsumerState<TrueFalseModeStudyScreen> createState() => _TrueFalseModeScreenState();
}

class _TrueFalseModeScreenState extends ConsumerState<TrueFalseModeStudyScreen> {
  List<Flashcard> cards = [];
  int currentIndex = 0;
  int score = 0;
  String? displayedAnswer;
  Random random = Random();

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
      randomizeAnswer();
    });
  }

  void randomizeAnswer() {
    final card = cards[currentIndex];
    // 50% chance to show correct or incorrect answer
    if (random.nextBool()) {
      displayedAnswer = card.answer;
    } else {
      // Pick random answer from another card
      final otherCard = cards[random.nextInt(cards.length)];
      displayedAnswer = otherCard.answer;
    }
  }

  void answer(bool userSaysTrue) async {
    final card = cards[currentIndex];
    final correct = displayedAnswer == card.answer;
    if ((userSaysTrue && correct) || (!userSaysTrue && !correct)) {
      score++;
    }
    if (currentIndex == cards.length - 1) {
      await ref.read(studyProgressServiceProvider).saveTestResult(
        deckId: widget.deck.id,
        score: score,
        total: cards.length,
      );
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("True/False Finished"),
          content: Text("Score: $score / ${cards.length}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        currentIndex++;
        randomizeAnswer();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final card = cards[currentIndex];
    return Scaffold(
      appBar: AppBar(title: Text("True/False Mode: ${widget.deck.name}")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(card.question, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 20),
            Text(displayedAnswer ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => answer(true), child: const Text("True")),
                ElevatedButton(onPressed: () => answer(false), child: const Text("False")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
