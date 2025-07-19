// lib/widgets/chat_support_button.dart
import 'package:flutter/material.dart';
import 'package:brain_boost/screens/chat/gemini_chat_screen.dart';

class ChatSupportButton extends StatelessWidget {
  const ChatSupportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 80,
      right: 16,
      child: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GeminiChatScreen()),
          );
        },
        child: const Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}
