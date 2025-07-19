import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'flashcard_model.g.dart';

@HiveType(typeId: 2)
class Flashcard extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String question;

  @HiveField(2)
  final String answer;

  @HiveField(3)
  final int interval;

  @HiveField(4)
  final double easeFactor;

  @HiveField(5)
  final DateTime? lastReviewed;

  @HiveField(6)
  final DateTime? nextReview;

  @HiveField(7)
  final String deckId; // ✅ NEW FIELD

  @HiveField(8)
  final String? imagePath;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    required this.deckId, 
    this.imagePath,
    this.interval = 1,
    this.easeFactor = 2.5,
    this.lastReviewed,
    this.nextReview,
  });

  /// From Firestore or generic Map
  factory Flashcard.fromMap(String id, Map<String, dynamic> map) {
    return Flashcard(
      id: id,
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
      deckId: map['deckId'] ?? '',
      imagePath: map['imagePath'],
      interval: (map['interval'] ?? 1).clamp(1, 9999),
      easeFactor: ((map['easeFactor'] ?? 2.5) as num).toDouble(),
      lastReviewed: map['lastReviewed'] != null
          ? (map['lastReviewed'] is Timestamp
              ? (map['lastReviewed'] as Timestamp).toDate()
              : DateTime.tryParse(map['lastReviewed'].toString()))
          : null,
      nextReview: map['nextReview'] != null
          ? (map['nextReview'] is Timestamp
              ? (map['nextReview'] as Timestamp).toDate()
              : DateTime.tryParse(map['nextReview'].toString()))
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'question': question,
        'answer': answer,
        'deckId': deckId,
        'imagePath': imagePath,
        'interval': interval,
        'easeFactor': easeFactor,
        'lastReviewed':
            lastReviewed != null ? Timestamp.fromDate(lastReviewed!) : null,
        'nextReview':
            nextReview != null ? Timestamp.fromDate(nextReview!) : null,
      };
      
  /// From API response (JSON)
  factory Flashcard.fromJson(Map<String, dynamic> json) =>
      Flashcard.fromMap(json['id'] ?? '', json);

  Map<String, dynamic> toJson() {
    final map = toMap();
    map['id'] = id;
    return map;
  }


  /// ✅ Copy with updated values (including deckId)
  Flashcard copyWith({
    String? id,
    String? question,
    String? answer,
    String? deckId,
    int? interval,
    double? easeFactor,
    DateTime? lastReviewed,
    DateTime? nextReview,
  }) {
    return Flashcard(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      deckId: deckId ?? this.deckId,
      interval: interval ?? this.interval,
      easeFactor: easeFactor ?? this.easeFactor,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      nextReview: nextReview ?? this.nextReview,
    );
  }

  /// Reset card (for testing or restart)
  Flashcard reset() {
    return Flashcard(
      id: id,
      question: question,
      answer: answer,
      deckId: deckId,
      interval: 1,
      easeFactor: 2.5,
      lastReviewed: null,
      nextReview: null,
    );
  }

  /// Equality check
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Flashcard &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
