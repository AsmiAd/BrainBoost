import 'dart:convert';
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

  @HiveField(4)
  final String description;

  @HiveField(5)
  final List<String> tags;

  @HiveField(6)
  final String category;

  @HiveField(7)
  final int color;

  @HiveField(8)
  final bool isPublic;

  @HiveField(9)
  final String? imagePath;

  @HiveField(10)
  final DateTime? createdAt;

  @HiveField(11)
  final String? userId;

  Deck({
    required this.id,
    required this.name,
    required this.cardCount,
    this.lastAccessed,
    this.description = '',
    this.tags = const [],
    this.category = 'General',
    this.color = 0xFF2196F3,
    this.isPublic = false,
    this.imagePath,
    this.createdAt,
    this.userId,
  });

  /// Firestore mapping
  factory Deck.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Deck(
      id: doc.id,
      name: data['title'] ?? data['name'] ?? 'Untitled',
      cardCount: data['card_count'] ?? 0,
      lastAccessed: (data['last_accessed'] as Timestamp?)?.toDate(),
      description: data['description'] ?? '',
      category: data['category'] ?? 'General',
      color: (data['color'] is int) ? data['color'] : 0xFF2196F3,
      isPublic: data['isPublic'] ?? false,
      tags: (data['tags'] as List?)?.cast<String>() ?? [],
      imagePath: data['imagePath'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      userId: data['userId'], // FIXED
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': name,
      'card_count': cardCount,
      'last_accessed': lastAccessed != null
          ? Timestamp.fromDate(lastAccessed!)
          : null,
      'description': description,
      'category': category,
      'color': color,
      'isPublic': isPublic,
      'tags': tags,
      'imagePath': imagePath,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : null,
      'userId': userId,
    };
  }

  /// Hive mapping
  factory Deck.fromHive(Map<String, dynamic> map) {
    return Deck(
      id: map['id'] ?? '',
      name: map['title'] ?? map['name'] ?? 'Untitled',
      cardCount: map['cardCount'] ?? 0,
      lastAccessed: map['lastAccessed'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastAccessed'])
          : null,
      description: map['description'] ?? '',
      category: map['category'] ?? 'General',
      color: map['color'] ?? 0xFF2196F3,
      isPublic: map['isPublic'] ?? false,
      tags: (map['tags'] as List?)?.cast<String>() ?? [],
      imagePath: map['imagePath'],
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
      userId: map['userId'], // ADD to Hive as well
    );
  }

  /// JSON (for API / MongoDB)
  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['title'] ?? json['name'] ?? 'Untitled',
      cardCount: json['cardCount'] ?? 0,
      lastAccessed: json['lastAccessed'] != null
          ? DateTime.tryParse(json['lastAccessed'])
          : null,
      description: json['description'] ?? '',
      category: json['category'] ?? 'General',
      color: (json['color'] is int) ? json['color'] : 0xFF2196F3,
      isPublic: json['isPublic'] ?? false,
      tags: (json['tags'] as List?)?.cast<String>() ?? [],
      imagePath: json['imagePath'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      userId: json['userId'], // FIXED for API
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'cardCount': cardCount,
      'lastAccessed': lastAccessed?.toIso8601String(),
      'description': description,
      'category': category,
      'color': color,
      'isPublic': isPublic,
      'tags': tags,
      'imagePath': imagePath,
      'createdAt': createdAt?.toIso8601String(),
      'userId': userId, // include when sending to API
    };
  }
}
