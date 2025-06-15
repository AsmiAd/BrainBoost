import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/flashcard_model.dart';
import '../../services/deck_service.dart';

class SpacedRepetitionScreen extends ConsumerStatefulWidget {
  final String deckId;
  const SpacedRepetitionScreen({required this.deckId, super.key});

  @override
  ConsumerState<SpacedRepetitionScreen> createState() => _SpacedRepetitionScreenState();
}

class _SpacedRepetitionScreenState extends ConsumerState<SpacedRepetitionScreen> {
  List<Flashcard> dueCards = [];
  int currentIndex = 0;
  bool showAnswer = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDueCards();
  }

  Future<void> loadDueCards() async {
    final allCards = await DeckService().getFlashcards(widget.deckId);
    final now = DateTime.now();
    dueCards = allCards.where((card) =>
        card.nextReview == null || card.nextReview!.isBefore(now)).toList();

    setState(() {
      loading = false;
    });
  }

  void updateCard(String difficulty) async {
    final card = dueCards[currentIndex];
    int newInterval;

    switch (difficulty) {
      case 'Easy': newInterval = 4; break;
      case 'Medium': newInterval = 2; break;
      case 'Hard': newInterval = 1; break;
      default: newInterval = 1;
    }

    final updatedCard = card.copyWith(
      interval: newInterval,
      lastReviewed: DateTime.now(),
      nextReview: DateTime.now().add(Duration(days: newInterval)),
    );

    await DeckService().updateFlashcard(widget.deckId, updatedCard);

    setState(() {
      currentIndex++;
      showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (dueCards.isEmpty) return const Center(child: Text("No cards due for review."));

    final card = dueCards[currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Spaced Repetition")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Q: ${card.question}", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            if (showAnswer) Text("A: ${card.answer}", style: const TextStyle(fontSize: 18)),
            const Spacer(),
            if (!showAnswer)
              ElevatedButton(
                onPressed: () => setState(() => showAnswer = true),
                child: const Text("Show Answer"),
              ),
            if (showAnswer)
              Column(
                children: ['Easy', 'Medium', 'Hard'].map((level) {
                  return ElevatedButton(
                    onPressed: () => updateCard(level),
                    child: Text(level),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
