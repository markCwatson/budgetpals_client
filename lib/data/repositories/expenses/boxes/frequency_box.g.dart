// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frequency_box.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FrequencyBoxAdapter extends TypeAdapter<FrequencyBox> {
  @override
  final int typeId = 2;

  @override
  FrequencyBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FrequencyBox()..name = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, FrequencyBox obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrequencyBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
