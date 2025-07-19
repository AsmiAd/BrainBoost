import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/deck_provider.dart'; // your provider path
import '../../models/deck_model.dart';
import '../../models/flashcard_model.dart';

class AddFlashcardsScreen extends StatefulWidget {
  final Map<String, dynamic> deck;

  const AddFlashcardsScreen({super.key, required this.deck});

  @override
  State<AddFlashcardsScreen> createState() => _AddFlashcardsScreenState();
}

class _AddFlashcardsScreenState extends State<AddFlashcardsScreen> {
  final List<Map<String, String>> _cards = [];
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  void _addFlashcard() {
    if (_questionController.text.isEmpty || _answerController.text.isEmpty) return;

    setState(() {
      _cards.add({
        'question': _questionController.text,
        'answer': _answerController.text,
      });
    });

    _questionController.clear();
    _answerController.clear();
  }

  Future<void> _finish() async {
    final deckData = widget.deck;

    final deck = Deck(
      id: deckData['id'],
      name: deckData['title'],
      cardCount: _cards.length,
      lastAccessed: DateTime.now(),
    );

    final flashcards = _cards.map((card) => Flashcard(
      id: UniqueKey().toString(),
      question: card['question']!,
      answer: card['answer']!,
      deckId: deck.id,
    )).toList();

    final container = ProviderScope.containerOf(context);
    final service = container.read(deckServiceProvider);

    await service.createDeckWithCards(deck, flashcards);

    if (!mounted) return;

    // Navigate back to home (or your main screen)
    Navigator.popUntil(context, (route) => route.isFirst);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Deck saved successfully")),
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deckTitle = widget.deck['title'] ?? 'Your Deck';

    return Scaffold(
      appBar: AppBar(title: Text("Add Flashcards to $deckTitle")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(labelText: 'Answer'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addFlashcard,
              icon: const Icon(Icons.add),
              label: const Text('Add Flashcard'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_cards[index]['question'] ?? ''),
                    subtitle: Text(_cards[index]['answer'] ?? ''),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: _finish,
              icon: const Icon(Icons.done),
              label: const Text('Finish'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
