import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/flashcard_model.dart';
import '../../providers/deck_provider.dart';
import '../../services/study_progress_service.dart';

class QuizModeStudyScreen extends ConsumerStatefulWidget {
  final String deckId;
  const QuizModeStudyScreen({super.key, required this.deckId});

  @override
  ConsumerState<QuizModeStudyScreen> createState() => _QuizModeScreenState();
}

class _QuizModeScreenState extends ConsumerState<QuizModeStudyScreen> {
  List<Flashcard> cards = [];
  int currentIndex = 0;
  int score = 0;
  final answerController = TextEditingController();
  bool loading = true;
  late DateTime startTime;

  @override
  void initState() {
    super.initState();
    loadCards();
    startTime = DateTime.now();
  }

  Future<void> loadCards() async {
    final deckService = ref.read(deckServiceProvider);
    final fetchedCards = await deckService.getFlashcards(widget.deckId);
    setState(() {
      cards = fetchedCards;
      loading = false;
    });
  }

  void submitAnswer() async {
    final correctAnswer = cards[currentIndex].answer.trim().toLowerCase();
    final userAnswer = answerController.text.trim().toLowerCase();
    if (userAnswer == correctAnswer) {
      score++;
    }
    answerController.clear();

    if (currentIndex == cards.length - 1) {
      final duration = DateTime.now().difference(startTime);
      await ref.read(studyProgressServiceProvider).saveTestResult(
        deckId: widget.deckId,
        score: score,
        total: cards.length,
        duration: duration,
      );
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Quiz Finished"),
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
      setState(() => currentIndex++);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (cards.isEmpty) return Scaffold(appBar: AppBar(title: const Text("Quiz Mode")), body: const Center(child: Text("No cards")));
    final card = cards[currentIndex];
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz Mode")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text("Q${currentIndex + 1}/${cards.length}: ${card.question}", style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 20),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(labelText: "Your Answer"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitAnswer,
              child: const Text("Submit"),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
            ),
          ],
        ),
      ),
    );
  }
}
