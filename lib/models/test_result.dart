import 'package:hive/hive.dart';

part 'test_result.g.dart';

@HiveType(typeId: 1)
class TestResult extends HiveObject {
  @HiveField(0)
  final String deckId;

  @HiveField(1)
  final int score;

  @HiveField(2)
  final int total;

  @HiveField(3)
  final DateTime date;



  @HiveField(4)
  final int durationSeconds;

  TestResult({
    required this.deckId,
    required this.score,
    required this.total,
    required this.date,
    this.durationSeconds =0,
  });
}
