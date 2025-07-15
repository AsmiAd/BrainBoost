// lib/services/api_service.dart
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

  static const _baseUrl =
      String.fromEnvironment('API_URL', defaultValue: 'http://localhost:8080');

  Future<String> _token() async =>
      (await _auth.currentUser?.getIdToken()) ?? '';

  Future<List<Deck>> fetchDecks({bool onlyPublic = false}) async {
    final res = await _get('/api/decks${onlyPublic ? '?public=true' : ''}');
    return (jsonDecode(res.body) as List)
        .map((j) => Deck.fromJson(j))
        .toList();
  }

  Future<Deck> createDeck(Deck deck) async {
    final res = await _post(
      '/api/decks',
      body: jsonEncode(deck.toJson()),
      expected: 201,
    );
    return Deck.fromJson(jsonDecode(res.body));
  }

  Future<List<StudyProgress>> fetchProgress() async {
    final res = await _get('/api/progress');
    return (jsonDecode(res.body) as List)
        .map((j) => StudyProgress.fromJson(j))
        .toList();
  }

  Future<void> updateProgress(StudyProgress p) async {
    await _post(
      '/api/progress',
      body: jsonEncode(p.toJson()),
      expected: 201,
    );
  }

  Future<List<Flashcard>> fetchCards(String deckId) async {
    final res = await _get('/api/cards/$deckId');
    return (jsonDecode(res.body) as List)
        .map((j) => Flashcard.fromJson(j))
        .toList();
  }

  Future<void> createCard(Flashcard card) async {
    await _post(
      '/api/cards',
      body: jsonEncode(card.toJson()),
      expected: 201,
    );
  }

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

  Future<Map<String, String>> _headers() async => {
        'Authorization': 'Bearer ${await _token()}',
        'Content-Type': 'application/json',
      };

      Future<void> updateFlashcard(String deckId, Flashcard card) async {
    // Example Firestore update logic:
    final docRef = FirebaseFirestore.instance
      .collection('decks')
      .doc(deckId)
      .collection('flashcards')
      .doc(card.id);

    await docRef.update({
      'question': card.question,
      'answer': card.answer,
      'interval': card.interval,
      'lastReviewed': card.lastReviewed?.toIso8601String(),
      'nextReview': card.nextReview?.toIso8601String(),
      // add other fields as necessary
    });
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(FirebaseAuth.instance);
});
