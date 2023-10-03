// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration_box.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfigurationBoxAdapter extends TypeAdapter<ConfigurationBox> {
  @override
  final int typeId = 21;

  @override
  ConfigurationBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConfigurationBox()
      ..startDate = fields[0] as String
      ..period = fields[1] as String
      ..startAccountBalance = fields[2] as double
      ..runningBalance = fields[3] as double;
  }

  @override
  void write(BinaryWriter writer, ConfigurationBox obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.startDate)
      ..writeByte(1)
      ..write(obj.period)
      ..writeByte(2)
      ..write(obj.startAccountBalance)
      ..writeByte(3)
      ..write(obj.runningBalance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigurationBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
