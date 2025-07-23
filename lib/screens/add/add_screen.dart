import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddScreen extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onDeckCreated;

  const AddScreen({super.key, this.onDeckCreated});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _tagController = TextEditingController();

  bool _isLoading = false;

  Future<void> createDeck(String title, String userId) async {
    final url = Uri.parse('http://127.0.0.1:5000/api/decks');

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'description': _descriptionController.text.trim(),
          'tag': _tagController.text.trim(),
          'userId': userId,
        }),
      );

      if (response.statusCode == 201) {
        final newDeck = jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Deck created successfully!')),
        );

        _titleController.clear();

        // Call the callback if provided
        if (widget.onDeckCreated != null) {
          widget.onDeckCreated!(newDeck);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = '123'; // Replace with dynamic user ID if available

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Deck'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Deck Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _tagController,
              decoration: const InputDecoration(
                labelText: 'Tag',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      final title = _titleController.text.trim();
                      if (title.isNotEmpty) {
                        createDeck(title, userId);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Title cannot be empty')),
                        );
                      }
                    },
                    child: const Text('Create Deck'),
                  ),
          ],
        ),
      ),
    );
  }
}
