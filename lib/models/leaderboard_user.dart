import 'package:hive/hive.dart';

part 'leaderboard_user.g.dart';

@HiveType(typeId: 1)
class LeaderboardUser {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int points;

  @HiveField(2)
  final String avatarUrl;

  LeaderboardUser({
    required this.name,
    required this.points,
    required this.avatarUrl,
  });

  factory LeaderboardUser.fromMap(Map<String, dynamic> map) {
    return LeaderboardUser(
      name: map['name'] ?? '',
      points: map['points'] ?? 0,
      avatarUrl: map['avatarUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'points': points,
      'avatarUrl': avatarUrl,
    };
  }
}
