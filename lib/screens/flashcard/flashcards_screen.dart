import 'package:flutter/material.dart';

class FlashcardsScreen extends StatelessWidget {
  final String deckId;

  const FlashcardsScreen({super.key, required this.deckId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flashcards')),
      body: Center(
        child: Text('Display flashcards for deck ID: $deckId'),
      ),
    );
  }
}
