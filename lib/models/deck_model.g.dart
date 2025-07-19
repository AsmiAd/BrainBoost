// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeckAdapter extends TypeAdapter<Deck> {
  @override
  final int typeId = 1;

  @override
  Deck read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Deck(
      id: fields[0] as String,
      name: fields[1] as String,
      cardCount: fields[2] as int,
      lastAccessed: fields[3] as DateTime?,
      description: fields[4] as String,
      tags: (fields[5] as List).cast<String>(),
      category: fields[6] as String,
      color: fields[7] as int,
      isPublic: fields[8] as bool,
      imagePath: fields[9] as String?,
      createdAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Deck obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.cardCount)
      ..writeByte(3)
      ..write(obj.lastAccessed)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.tags)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.color)
      ..writeByte(8)
      ..write(obj.isPublic)
      ..writeByte(9)
      ..write(obj.imagePath)
      ..writeByte(10)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
