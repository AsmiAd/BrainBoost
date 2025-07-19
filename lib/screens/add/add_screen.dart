import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/deck_model.dart';
import '../../providers/deck_provider.dart';
import 'add_flashcards_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddScreen extends ConsumerStatefulWidget {
  final void Function(Deck)? onDeckCreated;

  const AddScreen({Key? key, this.onDeckCreated}) : super(key: key);

  @override
  ConsumerState<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends ConsumerState<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagController = TextEditingController();

  List<String> _tags = [];
  File? _deckImage;
  Color _deckColor = Colors.blue.shade200;
  bool _isPublic = false;
  bool _isLoading = false;

  final String apiBaseUrl = 'http://192.168.1.172:8080/api';

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _deckImage = File(pickedFile.path));
    }
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pick a color"),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: Colors.primaries.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() => _deckColor = color.shade200);
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    backgroundColor: color,
                    radius: 20,
                    child: _deckColor.value == color.shade200.value
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<String?> uploadImageToBackend(File imageFile) async {
    try {
      final uri = Uri.parse('$apiBaseUrl/images/upload');
      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final respJson = json.decode(respStr);
        return respJson['fileId'];
      } else {
        print('Image upload failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Image upload error: $e');
      return null;
    }
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String? uploadedFileId;
    if (_deckImage != null) {
      uploadedFileId = await uploadImageToBackend(_deckImage!);
    }

    final newDeck = Deck(
      id: '', // Leave empty; backend will generate ID
      name: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      cardCount: 0,
      tags: _tags,
      category: 'General',
      color: _deckColor.value,
      isPublic: _isPublic,
      imagePath: uploadedFileId,
      createdAt: DateTime.now(),
      lastAccessed: null,
    );

    try {
      final deckService = ref.read(deckServiceProvider);
      final createdDeck = await deckService.createDeck(newDeck);

      if (!mounted) return;

      // Call onDeckCreated callback if provided
      widget.onDeckCreated?.call(createdDeck);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AddFlashcardsScreen(deck: createdDeck.toJson()),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deck created! Add flashcards now.')),
      );

      _resetForm();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating deck: $e')),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      _tagController.clear();
      _tags.clear();
      _deckImage = null;
      _deckColor = Colors.blue.shade200;
      _isPublic = false;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Deck")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: "Deck Title *",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Title is required" : null,
                      maxLength: 50,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Description (optional)",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      maxLength: 200,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.color_lens),
                      title: const Text("Deck Color"),
                      trailing: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _deckColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black26),
                        ),
                      ),
                      onTap: _showColorPicker,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _tagController,
                      decoration: InputDecoration(
                        labelText: "Add Tag",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addTag,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      children: _tags
                          .map((tag) => Chip(
                                label: Text(tag),
                                onDeleted: () => setState(() => _tags.remove(tag)),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                    SwitchListTile(
                      title: const Text("Make this deck public"),
                      value: _isPublic,
                      onChanged: (v) => setState(() => _isPublic = v),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _submitForm,
                        icon: const Icon(Icons.add),
                        label: const Text("Create Deck"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
