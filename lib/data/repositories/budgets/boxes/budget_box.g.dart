// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_box.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BudgetBoxAdapter extends TypeAdapter<BudgetBox> {
  @override
  final int typeId = 20;

  @override
  BudgetBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BudgetBox()
      ..userId = fields[0] as String
      ..configuration = fields[1] as ConfigurationBox
      ..plannedExpenses = (fields[2] as List).cast<ExpenseBox>()
      ..plannedIncomes = (fields[3] as List).cast<IncomeBox>()
      ..unplannedExpenses = (fields[4] as List).cast<ExpenseBox>()
      ..unplannedIncomes = (fields[5] as List).cast<IncomeBox>();
  }

  @override
  void write(BinaryWriter writer, BudgetBox obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.configuration)
      ..writeByte(2)
      ..write(obj.plannedExpenses)
      ..writeByte(3)
      ..write(obj.plannedIncomes)
      ..writeByte(4)
      ..write(obj.unplannedExpenses)
      ..writeByte(5)
      ..write(obj.unplannedIncomes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
