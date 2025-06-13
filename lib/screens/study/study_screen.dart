import 'package:flutter/material.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock decks
    final decks = [
      {'title': 'Biology Deck', 'id': 'bio1'},
      {'title': 'Physics Deck', 'id': 'phy1'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Study')),
      body: ListView.builder(
        itemCount: decks.length,
        itemBuilder: (context, index) {
          final deck = decks[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              title: Text(deck['title']!),
              subtitle: const Text('Choose a mode'),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Flash') {
                    Navigator.pushNamed(context, '/flash_mode', arguments: deck);
                  } else if (value == 'Spaced') {
                    Navigator.pushNamed(context, '/spaced_repetition', arguments: deck);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'Flash', child: Text('Flash Mode')),
                  const PopupMenuItem(value: 'Spaced', child: Text('Spaced Repetition')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
