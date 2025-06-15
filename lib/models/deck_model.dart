import 'package:cloud_firestore/cloud_firestore.dart';

class Deck {
  final String id;
  final String name;
  final int cardCount;
  final DateTime? lastAccessed;

  Deck({
    required this.id,
    required this.name,
    required this.cardCount,
    required this.lastAccessed,
  });

  factory Deck.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Deck(
      id: doc.id,
      name: data['name'] ?? 'Untitled',
      cardCount: data['card_count'] ?? 0,
      lastAccessed: (data['last_accessed'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'card_count': cardCount,
      'last_accessed': lastAccessed != null ? Timestamp.fromDate(lastAccessed!) : null,
    };
  }

  Map<String, dynamic> toHive() {
    return {
      'id': id,
      'name': name,
      'cardCount': cardCount,
      'lastAccessed': lastAccessed?.millisecondsSinceEpoch,
    };
  }

  factory Deck.fromHive(Map<String, dynamic> map) {
    return Deck(
      id: map['id'] ?? '',
      name: map['name'] ?? 'Untitled',
      cardCount: map['cardCount'] ?? 0,
      lastAccessed: map['lastAccessed'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastAccessed'])
          : null,
    );
  }
}
