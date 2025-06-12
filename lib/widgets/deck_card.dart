import 'package:flutter/material.dart';
import 'package:brain_boost/models/deck_model.dart';

class DeckCard extends StatelessWidget {
  final Deck deck;
  final VoidCallback? onTap;
  final Color? color;

  const DeckCard({
    Key? key,
    required this.deck,
    this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? Colors.white,
      child: ListTile(
        title: Text(deck.name),
        subtitle: Text('${deck.cardCount} cards'),
        onTap: onTap,
      ),
    );
  }
}
