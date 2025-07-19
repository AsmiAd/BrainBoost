import 'package:hive/hive.dart';

part 'study_progress.g.dart';

@HiveType(typeId: 0)
class StudyProgress extends HiveObject {
  @HiveField(0)
  final String timePeriod;

  @HiveField(1)
  final int actualMinutes;

  @HiveField(2)
  final int goalMinutes;

  String get id => timePeriod;

  StudyProgress({
    required this.timePeriod,
    required this.actualMinutes,
    required this.goalMinutes,
  });

  factory StudyProgress.fromMap(Map<String, dynamic> map) {
    return StudyProgress(
      timePeriod: map['timePeriod'] ?? '',
      actualMinutes: map['actualMinutes'] ?? 0,
      goalMinutes: map['goalMinutes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timePeriod': timePeriod,
      'actualMinutes': actualMinutes,
      'goalMinutes': goalMinutes,
    };
  }

  factory StudyProgress.fromJson(Map<String, dynamic> json) => StudyProgress.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}
