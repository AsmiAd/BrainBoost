import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'add_flashcards_screen.dart';

class AddScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onDeckCreated;

  const AddScreen({super.key, required this.onDeckCreated});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _deckImage;
  Color _deckColor = Colors.blue.shade200;
  String? _selectedCategory;
  bool _isLoading = false;

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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final newDeck = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': _titleController.text,
      'description': _descriptionController.text,
      'color': _deckColor.value,
      'category': _selectedCategory,
      'imagePath': _deckImage?.path,
      'createdAt': DateTime.now().toIso8601String(),
    };

    await Future.delayed(const Duration(seconds: 1));

    widget.onDeckCreated(newDeck);
if (!mounted) return;

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => AddFlashcardsScreen(deck: newDeck),
  ),
);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Deck created successfully!')),
    );

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: "Deck Title *",
                        prefixIcon: Icon(Icons.title),
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
                        prefixIcon: Icon(Icons.description),
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
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
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: "Category",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: const [
                        DropdownMenuItem(value: "DSAP", child: Text("DSAP")),
                        DropdownMenuItem(value: "Information Systems", child: Text("Information Systems")),
                        DropdownMenuItem(value: "Data Communication", child: Text("Data Communication")),
                        DropdownMenuItem(value: "SPIT", child: Text("SPIT")),

                        DropdownMenuItem(value: "Data Warehouse and Data Mining", child: Text("Ecommerce")),

                        DropdownMenuItem(value: "Ecommerce", child: Text("Ecommerce")),
                      ],
                      onChanged: (val) => setState(() => _selectedCategory = val),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _submitForm,
                        icon: const Icon(Icons.add),
                        label: const Text("Create Deck"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
