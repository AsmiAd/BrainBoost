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

  static const String _baseUrl = 'http://127.0.0.1:5000'; // backend base URL

  Future<String> _token() async =>
      (await _auth.currentUser?.getIdToken()) ?? '';

  Future<Map<String, String>> _headers() async => {
        'Authorization': 'Bearer ${await _token()}',
        'Content-Type': 'application/json',
      };

  Future<http.Response> _get(String path) async =>
      http.get(Uri.parse('$_baseUrl$path'), headers: await _headers());

  Future<http.Response> _post(String path,
      {Object? body, int expected = 200}) async {
    final res = await http.post(Uri.parse('$_baseUrl$path'),
        headers: await _headers(), body: body);
    if (res.statusCode != expected) {
      throw Exception('API ${res.statusCode}: ${res.body}');
    }
    return res;
  }

  Future<http.Response> _put(String path,
      {Object? body, int expected = 200}) async {
    final res = await http.put(Uri.parse('$_baseUrl$path'),
        headers: await _headers(), body: body);
    if (res.statusCode != expected) {
      throw Exception('API ${res.statusCode}: ${res.body}');
    }
    return res;
  }

  // -------- Decks --------
  Future<List<Deck>> fetchDecks({String? userId, bool onlyPublic = false}) async {
  String query = '';
  if (onlyPublic) query = '?public=true';
  if (userId != null) query = '?userId=$userId';
  final res = await _get('/api/decks$query');
  return (jsonDecode(res.body) as List).map((j) => Deck.fromJson(j)).toList();
}


  Future<Deck> createDeck(Deck deck) async {
    final res = await _post('/api/decks',
        body: jsonEncode({
          'title': deck.name,
          'description': deck.description ?? '',
          'color': deck.color != null
              ? '#${deck.color!.toRadixString(16).padLeft(8, '0').substring(2)}'
              : '#ffffff',
          'category': deck.category ?? 'General',
          'tags': deck.tags ?? [],
          'isPublic': deck.isPublic ?? false,
          'imagePath': deck.imagePath ?? '',
          'userId': deck.userId ?? '', // ensure correct user
        }),
        expected: 201);
    return Deck.fromJson(jsonDecode(res.body));
  }

  Future<void> updateDeck(String id, Map<String, dynamic> updates) async {
    await _put('/api/decks/$id', body: jsonEncode(updates), expected: 200);
  }

  Future<void> deleteDeck(String id) async {
    final res =
        await http.delete(Uri.parse('$_baseUrl/api/decks/$id'), headers: await _headers());
    if (res.statusCode != 200) {
      throw Exception('Failed to delete deck: ${res.body}');
    }
  }

  // -------- Cards --------
  Future<List<Flashcard>> fetchCards(String deckId) async {
    final res = await _get('/api/cards?deckId=$deckId');
    return (jsonDecode(res.body) as List)
        .map((j) => Flashcard.fromJson(j))
        .toList();
  }

  Future<void> createCard(Flashcard card) async {
    await _post('/api/cards',
        body: jsonEncode(card.toJson()), expected: 201);
  }

  Future<void> updateFlashcard(String deckId, Flashcard card) async {
    // Update card in backend
    await _put('/api/cards/${card.id}',
        body: jsonEncode(card.toJson()), expected: 200);

    // Sync spaced repetition data to Firestore
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

  Future<void> deleteCard(String id) async {
    final res =
        await http.delete(Uri.parse('$_baseUrl/api/cards/$id'), headers: await _headers());
    if (res.statusCode != 200) {
      throw Exception('Failed to delete card: ${res.body}');
    }
  }

  Future<void> saveManyCards(String deckId, List<Flashcard> cards) async {
  final body = {
    'cards': cards.map((c) => c.toJson()).toList(),
  };
  await _post('/api/decks/$deckId/cards/bulk',
      body: jsonEncode(body), expected: 200);
}


  // -------- Study Progress --------
  Future<List<StudyProgress>> fetchProgress() async {
    final res = await _get('/api/progress');
    return (jsonDecode(res.body) as List)
        .map((j) => StudyProgress.fromJson(j))
        .toList();
  }

  Future<void> updateProgress(StudyProgress p) async {
    await _post('/api/progress',
        body: jsonEncode(p.toJson()), expected: 201);
  }

  // -------- Admin --------
  Future<List<dynamic>> getAllUsers() async {
    final res = await _get('/api/admin/users'); // uses auth headers now
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load users');
  }

  Future<List<dynamic>> getAllDecksAdmin() async {
    final res = await _get('/api/admin/decks');
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load decks');
  }

  Future<void> deleteUser(String id) async {
    final res = await http.delete(Uri.parse('$_baseUrl/api/admin/users/$id'),
        headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to delete user: ${res.body}');
  }

  Future<void> deleteDeckAdmin(String id) async {
    final res = await http.delete(Uri.parse('$_baseUrl/api/admin/decks/$id'),
        headers: await _headers());
    if (res.statusCode != 200) throw Exception('Failed to delete deck: ${res.body}');
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(FirebaseAuth.instance);
});
