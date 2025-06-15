// flash_mode_screen.dart
import 'package:flutter/material.dart';

class FlashModeScreen extends StatelessWidget {
  const FlashModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deck = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(title: Text('Flash: ${deck['title']}')),
      body: Center(child: Text('Flashcards for ${deck['title']}')),
    );
  }
}
