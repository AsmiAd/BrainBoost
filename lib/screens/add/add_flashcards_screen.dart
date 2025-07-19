import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/deck_model.dart';
import '../../models/flashcard_model.dart';
import '../../providers/deck_provider.dart';
import '../../services/api_service.dart';

class AddFlashcardsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> deck;

  const AddFlashcardsScreen({super.key, required this.deck});

  @override
  ConsumerState<AddFlashcardsScreen> createState() => _AddFlashcardsScreenState();
}

class _AddFlashcardsScreenState extends ConsumerState<AddFlashcardsScreen> {
  final List<Map<String, dynamic>> _cards = [];
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<String?> _uploadImage(File image) async {
    final api = ref.read(apiServiceProvider);
    try {
      final uri = Uri.parse('http://192.168.1.172:8080/api/images/upload');
      final req = http.MultipartRequest('POST', uri);
      req.files.add(await http.MultipartFile.fromPath('image', image.path));
      final res = await req.send();
      if (res.statusCode == 200) {
        final str = await res.stream.bytesToString();
        final json = jsonDecode(str);
        return json['fileId'];
      }
    } catch (e) {
      print('Image upload failed: $e');
    }
    return null;
  }

  Future<void> _addFlashcard() async {
    String? uploadedImageId;
    if (_selectedImage != null) {
      uploadedImageId = await _uploadImage(_selectedImage!);
    }

    if (_questionController.text.isEmpty && uploadedImageId == null) return;
    if (_answerController.text.isEmpty) return;

    setState(() {
      _cards.add({
        'question': _questionController.text,
        'answer': _answerController.text,
        'imagePath': uploadedImageId,
      });
      _selectedImage = null;
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
          question: card['question'] ?? '',
          answer: card['answer'] ?? '',
          deckId: deck.id,
          imagePath: card['imagePath'],
        )).toList();

    final service = ref.read(deckServiceProvider);
    await service.createDeckWithCards(deck, flashcards);

    if (!mounted) return;
    Navigator.popUntil(context, (route) => route.isFirst);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Deck saved successfully")),
    );
  }

  @override
 @override
Widget build(BuildContext context) {
  final deckTitle = widget.deck['title'] ?? 'Your Deck';
  return Scaffold(
    appBar: AppBar(
      title: Text("Add Flashcards to $deckTitle", style: AppTextStyles.headingMedium),
      centerTitle: true,
      backgroundColor: AppColors.primary,
      elevation: 2,
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _questionController,
            decoration: InputDecoration(
              labelText: 'Question',
              labelStyle: AppTextStyles.bodyMedium,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style: AppTextStyles.bodyMedium,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _answerController,
            decoration: InputDecoration(
              labelText: 'Answer',
              labelStyle: AppTextStyles.bodyMedium,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style: AppTextStyles.bodyMedium,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image_outlined),
                label: const Text("Add Image"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.text,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: AppTextStyles.buttonSmall,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(width: 16),
              if (_selectedImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _selectedImage!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _addFlashcard,
            icon: const Icon(Icons.add),
            label: const Text('Add Flashcard'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: AppTextStyles.buttonLarge,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Added Flashcards",
            style: AppTextStyles.headingSmall,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _cards.isEmpty
                ? Center(
                    child: Text(
                      "No flashcards added yet",
                      style: AppTextStyles.faded,
                    ),
                  )
                : ListView.separated(
                    itemCount: _cards.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final card = _cards[index];
                      return ListTile(
                        leading: card['imagePath'] != null
                            ? const Icon(Icons.image_outlined, color: AppColors.primary)
                            : const Icon(Icons.note_alt_outlined, color: AppColors.grey),
                        title: Text(card['question']?.isNotEmpty == true ? card['question'] : "Image Question", 
                            style: AppTextStyles.bodyMedium),
                        subtitle: Text(card['answer'] ?? '', style: AppTextStyles.bodySmall),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: AppColors.error),
                          onPressed: () {
                            setState(() => _cards.removeAt(index));
                          },
                          tooltip: 'Delete flashcard',
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _finish,
            icon: const Icon(Icons.done_all),
            label: const Text('Finish & Save'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              padding: const EdgeInsets.symmetric(vertical: 18),
              textStyle: AppTextStyles.buttonLarge,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    ),
  );
}

}
