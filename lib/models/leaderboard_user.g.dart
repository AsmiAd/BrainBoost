// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LeaderboardUserAdapter extends TypeAdapter<LeaderboardUser> {
  @override
  final int typeId = 1;

  @override
  LeaderboardUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LeaderboardUser(
      name: fields[0] as String,
      points: fields[1] as int,
      avatarUrl: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LeaderboardUser obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.points)
      ..writeByte(2)
      ..write(obj.avatarUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeaderboardUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
