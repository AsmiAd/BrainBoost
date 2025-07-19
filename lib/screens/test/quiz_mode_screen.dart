import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/flashcard_model.dart';
import '../../providers/deck_provider.dart';
import '../../services/test_result_service.dart';

class QuizModeScreen extends ConsumerStatefulWidget {
  const QuizModeScreen({super.key});

  @override
  ConsumerState<QuizModeScreen> createState() => _QuizModeScreenState();
}

class _QuizModeScreenState extends ConsumerState<QuizModeScreen> {
  late List<Flashcard> _cards;
  int _current = 0;
  int _score = 0;
  final _controller = TextEditingController();
  late DateTime _startTime;
  String deckId = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    deckId = ModalRoute.of(context)?.settings.arguments as String;
    _loadCards();
    _startTime = DateTime.now();
  }

  Future<void> _loadCards() async {
    final service = ref.read(deckServiceProvider);
    final cards = await service.getFlashcards(deckId);
    setState(() => _cards = cards);
  }

  void _submitAnswer() {
    final correct = _controller.text.trim().toLowerCase() ==
        _cards[_current].answer.trim().toLowerCase();
    if (correct) _score++;
    _controller.clear();

    if (_current == _cards.length - 1) {
      _finish();
    } else {
      setState(() => _current++);
    }
  }

  Future<void> _finish() async {
    final duration = DateTime.now().difference(_startTime);
    await TestResultService().saveResult(
      deckId: deckId,
      mode: 'quiz',
      score: _score,
      totalQuestions: _cards.length,
      duration: duration,
    );
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text("Quiz Complete! Score: $_score/${_cards.length}")));
  }

  @override
  Widget build(BuildContext context) {
    if (_cards == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final card = _cards[_current];
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz Mode")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(card.question, style: const TextStyle(fontSize: 20)),
            TextField(controller: _controller, decoration: const InputDecoration(labelText: "Your Answer")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _submitAnswer, child: const Text("Submit")),
          ],
        ),
      ),
    );
  }
}
