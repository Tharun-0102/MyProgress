// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_goal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeeklyGoalAdapter extends TypeAdapter<WeeklyGoal> {
  @override
  final int typeId = 1;

  @override
  WeeklyGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeeklyGoal(
      weekStartDate: fields[0] as DateTime,
      targetActivities: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WeeklyGoal obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.weekStartDate)
      ..writeByte(1)
      ..write(obj.targetActivities);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
