import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'deck_model.g.dart';

@HiveType(typeId: 1)
class Deck {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int cardCount;

  @HiveField(3)
  final DateTime? lastAccessed;

  Deck({
    required this.id,
    required this.name,
    required this.cardCount,
    required this.lastAccessed,
  });

  // Firestore mapping
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

  // Hive mapping
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

  // JSON (for API communication)
  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? 'Untitled',
      cardCount: json['cardCount'] ?? 0,
      lastAccessed: json['lastAccessed'] != null
          ? DateTime.parse(json['lastAccessed'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cardCount': cardCount,
      'lastAccessed': lastAccessed?.toIso8601String(),
    };
  }
}
