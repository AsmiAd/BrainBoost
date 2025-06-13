// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudyProgressAdapter extends TypeAdapter<StudyProgress> {
  @override
  final int typeId = 0;

  @override
  StudyProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudyProgress(
      timePeriod: fields[0] as String,
      actualMinutes: fields[1] as int,
      goalMinutes: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StudyProgress obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.timePeriod)
      ..writeByte(1)
      ..write(obj.actualMinutes)
      ..writeByte(2)
      ..write(obj.goalMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
