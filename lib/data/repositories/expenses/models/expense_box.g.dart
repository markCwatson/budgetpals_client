// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_box.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseBoxAdapter extends TypeAdapter<ExpenseBox> {
  @override
  final int typeId = 0;

  @override
  ExpenseBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseBox()
      ..id = fields[0] as String
      ..frequency = fields[1] as String
      ..isEnding = fields[2] as bool
      ..endDate = fields[3] as String
      ..isFixed = fields[4] as bool
      ..userId = fields[5] as String
      ..isPlanned = fields[6] as bool
      ..amount = fields[7] as double
      ..date = fields[8] as String
      ..category = fields[9] as String;
  }

  @override
  void write(BinaryWriter writer, ExpenseBox obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.frequency)
      ..writeByte(2)
      ..write(obj.isEnding)
      ..writeByte(3)
      ..write(obj.endDate)
      ..writeByte(4)
      ..write(obj.isFixed)
      ..writeByte(5)
      ..write(obj.userId)
      ..writeByte(6)
      ..write(obj.isPlanned)
      ..writeByte(7)
      ..write(obj.amount)
      ..writeByte(8)
      ..write(obj.date)
      ..writeByte(9)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
