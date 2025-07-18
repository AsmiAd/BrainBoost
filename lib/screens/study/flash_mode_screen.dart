import 'package:flutter/material.dart';
import '../../models/flashcard_model.dart'; // Assuming you already have this

class FlashModeScreen extends StatefulWidget {
  final String deckTitle;
  final List<Flashcard> cards;

  const FlashModeScreen({
    super.key,
    required this.deckTitle,
    required this.cards,
  });

  @override
  State<FlashModeScreen> createState() => _FlashModeScreenState();
}

class _FlashModeScreenState extends State<FlashModeScreen> {
  int currentIndex = 0;
  bool showAnswer = false;

  void _nextCard() {
    if (currentIndex < widget.cards.length - 1) {
      setState(() {
        currentIndex++;
        showAnswer = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You've reached the end!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.cards[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Flash: ${widget.deckTitle}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: GestureDetector(
            onTap: () => setState(() => showAnswer = !showAnswer),
            onHorizontalDragEnd: (_) => _nextCard(),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                height: 300,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      showAnswer ? card.answer : card.question,
                      key: ValueKey(showAnswer),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nextCard,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
