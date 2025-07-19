import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/deck_model.dart';
import '../../providers/deck_provider.dart';

class TestModeScreen extends ConsumerWidget {
  const TestModeScreen({super.key});

  void _showModePicker(BuildContext context, Deck deck) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: AppColors.white,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Test Mode",
                style: AppTextStyles.headingMedium,
              ),
              const SizedBox(height: 16),
              _buildModeButton(context, deck, "Quiz Mode", Icons.quiz, '/quiz'),
              _buildModeButton(context, deck, "True/False", Icons.check_circle, '/truefalse'),
              _buildModeButton(context, deck, "Timed Mode", Icons.timer, '/timed'),
              _buildModeButton(context, deck, "Random Mix", Icons.shuffle, '/randommix'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModeButton(BuildContext context, Deck deck, String title, IconData icon, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 22),
        label: Text(title, style: AppTextStyles.buttonLarge),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          Navigator.pop(context); // close modal
          Navigator.pushNamed(context, route, arguments: deck);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decksAsync = ref.watch(decksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Your Knowledge"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: decksAsync.when(
        data: (decks) {
          if (decks.isEmpty) {
            return const Center(child: Text("No decks available for testing"));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: decks.length,
            itemBuilder: (_, i) {
              final deck = decks[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(deck.name, style: AppTextStyles.headingSmall),
                  subtitle: Text("${deck.cardCount} cards", style: AppTextStyles.bodySmall),
                  trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.grey),
                  onTap: () => _showModePicker(context, deck),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error loading decks: $e")),
      ),
    );
  }
}
