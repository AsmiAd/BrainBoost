import 'package:flutter/material.dart';
import 'package:brain_boost/models/flashcard_model.dart';

class StudyModeScreen extends StatefulWidget {
  const StudyModeScreen({super.key});

  @override
  State<StudyModeScreen> createState() => _StudyModeScreenState();
}

class _StudyModeScreenState extends State<StudyModeScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;

  final List<Flashcard> _flashcards = [
  Flashcard(
    id: '1',
    question: 'What is the capital of France?',
    answer: 'Paris',
    interval: 1,
    easeFactor: 2.5,
    lastReviewed: DateTime.now(),
    nextReview: DateTime.now().add(const Duration(days: 1)),
  ),
  Flashcard(
    id: '2',
    question: 'What is 2+2?',
    answer: '4',
    interval: 1,
    easeFactor: 2.5,
    lastReviewed: DateTime.now(),
    nextReview: DateTime.now().add(const Duration(days: 1)),
  ),
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card ${_currentIndex + 1}/${_flashcards.length}'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () => setState(() => _showAnswer = !_showAnswer),
          child: Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _flashcards[_currentIndex].question,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    if (_showAnswer) ...[
                      const Divider(),
                      Text(
                        _flashcards[_currentIndex].answer,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'prev',
            onPressed: _currentIndex > 0
                ? () {
                    setState(() {
                      _currentIndex--;
                      _showAnswer = false;
                    });
                  }
                : null,
            child: const Icon(Icons.chevron_left),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'next',
            onPressed: _currentIndex < _flashcards.length - 1
                ? () {
                    setState(() {
                      _currentIndex++;
                      _showAnswer = false;
                    });
                  }
                : null,
            child: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
