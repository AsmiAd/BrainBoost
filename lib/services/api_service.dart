import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/deck_model.dart';
import '../models/flashcard_model.dart';
import '../models/study_progress.dart';

class ApiService {
  ApiService(this._auth);

  final FirebaseAuth _auth;

  static const String _baseUrl =
      'http://10.0.2.2:8080'; // your backend API base URL

  Future<String> _token() async =>
      (await _auth.currentUser?.getIdToken()) ?? '';

  Future<Map<String, String>> _headers() async => {
        'Authorization': 'Bearer ${await _token()}',
        'Content-Type': 'application/json',
      };

  Future<http.Response> _get(String path) async => http.get(
        Uri.parse('$_baseUrl$path'),
        headers: await _headers(),
      );

  Future<http.Response> _post(
    String path, {
    Object? body,
    int expected = 200,
  }) async {
    final res = await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: await _headers(),
      body: body,
    );
    if (res.statusCode != expected) {
      throw Exception('API ${res.statusCode}: ${res.body}');
    }
    return res;
  }

  /// Fetch all decks (user or public)
  Future<List<Deck>> fetchDecks({bool onlyPublic = false}) async {
    final res = await _get('/api/decks${onlyPublic ? '?public=true' : ''}');
    return (jsonDecode(res.body) as List).map((j) => Deck.fromJson(j)).toList();
  }

  /// Create a deck with full fields (title, description, color, tags, etc.)
  Future<Deck> createDeck(Deck deck) async {
    print('Creating deck: ${deck.name}');

    final res = await _post(
      '/api/decks',
      body: jsonEncode({
        'title': deck.name,
        'description': deck.description ?? '',
        'color': deck.color != null
            ? '#${deck.color!.toRadixString(16).padLeft(8, '0').substring(2)}'
            : '#ffffff', // default white
        'category': deck.category ?? 'General',
        'tags': deck.tags ?? [],
        'isPublic': deck.isPublic ?? false,
        'imagePath': deck.imagePath ?? '',
        'createdAt': deck.createdAt?.toIso8601String() ??
            DateTime.now().toIso8601String(),
      }),
      expected: 201,
    );

    return Deck.fromJson(jsonDecode(res.body));
  }

  /// Bulk save flashcards to MongoDB API
  Future<void> saveManyCards(String deckId, List<Flashcard> cards) async {
    await _post(
      '/api/decks/$deckId/cards/bulk',
      body: jsonEncode({'cards': cards.map((c) => c.toJson()).toList()}),
      expected: 200,
    );
  }

  /// Fetch flashcards for a deck from API
  Future<List<Flashcard>> fetchCards(String deckId) async {
    final res = await _get('/api/cards/$deckId');
    return (jsonDecode(res.body) as List)
        .map((j) => Flashcard.fromJson(j))
        .toList();
  }

  /// Create a single flashcard in API
  Future<void> createCard(Flashcard card) async {
    await _post(
      '/api/cards',
      body: jsonEncode(card.toJson()),
      expected: 201,
    );
  }

  /// Update flashcard on MongoDB API + ALSO update spaced repetition fields in Firestore
  Future<void> updateFlashcard(String deckId, Flashcard card) async {
    // Update card in MongoDB backend API
    await _post(
      '/api/cards/${card.id}',
      body: jsonEncode(card.toJson()),
      expected: 200,
    );

    // Also update spaced repetition related fields in Firestore for real-time sync
    final docRef = FirebaseFirestore.instance
        .collection('decks')
        .doc(deckId)
        .collection('flashcards')
        .doc(card.id);

    await docRef.set({
      'question': card.question,
      'answer': card.answer,
      'interval': card.interval,
      'easeFactor': card.easeFactor,
      'lastReviewed': card.lastReviewed != null
          ? Timestamp.fromDate(card.lastReviewed!)
          : null,
      'nextReview': card.nextReview != null
          ? Timestamp.fromDate(card.nextReview!)
          : null,
      'deckId': card.deckId,
    }, SetOptions(merge: true));
  }

  /// Fetch study progress from API
  Future<List<StudyProgress>> fetchProgress() async {
    final res = await _get('/api/progress');
    return (jsonDecode(res.body) as List)
        .map((j) => StudyProgress.fromJson(j))
        .toList();
  }

  /// Update study progress via API
  Future<void> updateProgress(StudyProgress p) async {
    await _post(
      '/api/progress',
      body: jsonEncode(p.toJson()),
      expected: 201,
    );
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(FirebaseAuth.instance);
});
