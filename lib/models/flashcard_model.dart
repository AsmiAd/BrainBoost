import 'package:cloud_firestore/cloud_firestore.dart';

class Flashcard {
  final String id;
  final String question;
  final String answer;
  final int interval;
  final double easeFactor;
  final DateTime? lastReviewed;
  final DateTime? nextReview;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    required this.interval,
    required this.easeFactor,
    this.lastReviewed,
    this.nextReview,
  });

  factory Flashcard.fromMap(String id, Map<String, dynamic> map) {
    return Flashcard(
      id: id,
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
      interval: map['interval'] ?? 1,
      easeFactor: (map['easeFactor'] ?? 2.5).toDouble(),
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

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      'interval': interval,
      'easeFactor': easeFactor,
      'lastReviewed': lastReviewed != null ? Timestamp.fromDate(lastReviewed!) : null,
      'nextReview': nextReview != null ? Timestamp.fromDate(nextReview!) : null,
    };
  }

  Flashcard copyWith({
    int? interval,
    double? easeFactor,
    DateTime? lastReviewed,
    DateTime? nextReview,
  }) {
    return Flashcard(
      id: id,
      question: question,
      answer: answer,
      interval: interval ?? this.interval,
      easeFactor: easeFactor ?? this.easeFactor,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      nextReview: nextReview ?? this.nextReview,
    );
  }

  // JSON helpers for ApiService
  factory Flashcard.fromJson(Map<String, dynamic> json) {
    // Here json must include 'id'
    return Flashcard.fromMap(
      json['id'] ?? '',
      json,
    );
  }

  Map<String, dynamic> toJson() {
    final map = toMap();
    map['id'] = id;
    return map;
  }
}
