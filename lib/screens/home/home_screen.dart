import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:brain_boost/core/constants/app_text_styles.dart';
import 'package:brain_boost/models/deck_model.dart';
import 'package:brain_boost/widgets/deck_card.dart';
import 'package:brain_boost/widgets/loading_indicator.dart';
import 'package:brain_boost/widgets/error_retry_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Deck>> _decksFuture;

  @override
  void initState() {
    super.initState();
    _decksFuture = fetchDecks();
  }

  Future<List<Deck>> fetchDecks() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:5000/api/decks'));


      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Deck.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load decks');
      }
    } catch (e) {
      throw Exception('Error fetching decks: $e');
    }
  }

  Future<void> _refreshDecks() async {
    setState(() {
      _decksFuture = fetchDecks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshDecks,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(context),
                const SizedBox(height: 20),
                _buildActionButtons(context),
                const SizedBox(height: 24),
                Text('Recent Decks', style: AppTextStyles.headingSmall),
                const SizedBox(height: 12),
                Expanded(
                  child: FutureBuilder<List<Deck>>(
                    future: _decksFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LoadingIndicator();
                      } else if (snapshot.hasError) {
                        return ErrorRetryWidget(
                          error: snapshot.error.toString(),
                          onRetry: _refreshDecks,
                        );
                      } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                        return const Center(child: Text('No decks found'));
                      } else if (snapshot.hasData) {
                        final decks = snapshot.data!;
                        return ListView.separated(
                          itemCount: decks.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (_, index) => DeckCard(
                            deck: decks[index],
                            onTap: () => _openDeck(context, decks[index].id),
                          ),
                        );
                      } else {
                        return const Center(child: Text('Unexpected error'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'User';

    return AppBar(
      title: Text('Hi Asmi👋', style: AppTextStyles.headingSmall),
      actions: [
        IconButton(
          icon: Badge(
            smallSize: 8,
            child: const Icon(Icons.notifications_none),
          ),
          onPressed: () => _showNotifications(context),
        ),
        IconButton(
          icon: const Icon(Icons.vpn_key),
          tooltip: 'Print Firebase ID Token',
          onPressed: () async {
            if (user != null) {
              final token = await user.getIdToken();
              print('Firebase ID Token:\n$token');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ID token printed to console')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No user logged in')),
              );
            }
          },
        ),
      ],
    );
  }

  void _showNotifications(BuildContext context) {
    Navigator.pushNamed(context, '/notifications');
  }

  Widget _buildSearchBar(BuildContext context) => TextField(
        decoration: InputDecoration(
          hintText: 'Search decks...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onTap: () => Navigator.pushNamed(context, '/search'),
      );

  Widget _buildActionButtons(BuildContext context) => Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.school),
              label: const Text('Study'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () => Navigator.pushNamed(context, '/study'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.quiz),
              label: const Text('Test'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () => Navigator.pushNamed(context, '/test'),
            ),
          ),
        ],
      );

  void _openDeck(BuildContext context, String deckId) {
    Navigator.pushNamed(
      context,
      '/deck-details',
      arguments: deckId,
    );
  }
}
