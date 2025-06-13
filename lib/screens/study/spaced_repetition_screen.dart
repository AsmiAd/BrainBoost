// spaced_repetition_screen.dart
import 'package:flutter/material.dart';

class SpacedRepetitionScreen extends StatelessWidget {
  const SpacedRepetitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deck = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(title: Text('Spaced: ${deck['title']}')),
      body: Center(child: Text('Spaced repetition for ${deck['title']}')),
    );
  }
}
