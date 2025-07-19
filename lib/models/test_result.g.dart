// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TestResultAdapter extends TypeAdapter<TestResult> {
  @override
  final int typeId = 1;

  @override
  TestResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TestResult(
      deckId: fields[0] as String,
      score: fields[1] as int,
      total: fields[2] as int,
      date: fields[3] as DateTime,
      durationSeconds: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TestResult obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.deckId)
      ..writeByte(1)
      ..write(obj.score)
      ..writeByte(2)
      ..write(obj.total)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.durationSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
