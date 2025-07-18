import 'package:flutter/material.dart';
import 'package:brain_boost/models/flashcard_model.dart';

class TestModeScreen extends StatefulWidget {
  const TestModeScreen({super.key});

  @override
  State<TestModeScreen> createState() => _TestModeScreenState();
}

class _TestModeScreenState extends State<TestModeScreen> {
  int _currentIndex = 0;
  int _score = 0;
  bool _answered = false;


  final List<Flashcard> _flashcards = [
  Flashcard(
    id: '1',
    question: 'What is the capital of France?',
    answer: 'Paris',
    deckId: 'testDeck1', // ✅ hardcoded deckId
    interval: 1,
    easeFactor: 2.5,
    lastReviewed: DateTime.now(),
    nextReview: DateTime.now().add(const Duration(days: 1)),
  ),
  Flashcard(
    id: '2',
    question: 'What is 2+2?',
    answer: '4',
    deckId: 'testDeck1', // ✅ same here
    interval: 1,
    easeFactor: 2.5,
    lastReviewed: DateTime.now(),
    nextReview: DateTime.now().add(const Duration(days: 1)),
  ),
];


  void _handleAnswer(bool isCorrect) {
    setState(() {
      _answered = true;
      if (isCorrect) _score++;
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentIndex++;
      _answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLastQuestion = _currentIndex == _flashcards.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentIndex + 1}/${_flashcards.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      _flashcards[_currentIndex].question,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    if (_answered) ...[
                      const Divider(),
                      Text(
                        'Answer: ${_flashcards[_currentIndex].answer}',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (!_answered)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _handleAnswer(true),
                      child: const Text('I Know It'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _handleAnswer(false),
                      child: const Text('I Don\'t Know'),
                    ),
                  ),
                ],
              ),
            if (_answered && !isLastQuestion)
              ElevatedButton(
                onPressed: _nextQuestion,
                child: const Text('Next Question'),
              ),
            if (_answered && isLastQuestion)
              Column(
                children: [
                  Text(
                    'Test Complete! Score: $_score/${_flashcards.length}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Finish'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}