import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_boost/widgets/deck_card.dart';
import 'package:brain_boost/models/deck_model.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search decks...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            // Implement search logic
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Trigger search
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 0, // Replace with actual search results count
        itemBuilder: (context, index) {
          return DeckCard(
            deck: Deck(
              id: 'search-$index',
              name: 'Search Result ${index + 1}',
              cardCount: 10,
              lastAccessed: DateTime.now()),
            onTap: () => Navigator.pushNamed(
              context,
              '/deck-details',
              arguments: 'search-$index',
            ),
          );
        },
      ),
    );
  }
}