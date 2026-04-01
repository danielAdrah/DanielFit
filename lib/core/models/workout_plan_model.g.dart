// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_plan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutPlanModelAdapter extends TypeAdapter<WorkoutPlanModel> {
  @override
  final int typeId = 2;

  @override
  WorkoutPlanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutPlanModel(
      id: fields[0] as String,
      planName: fields[1] as String,
      daysPerWeek: fields[2] as int,
      workoutDayIds: (fields[3] as List?)?.cast<String>(),
      createdAt: fields[4] as DateTime?,
      description: fields[5] as String?,
      muscleCombinations: (fields[6] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutPlanModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.planName)
      ..writeByte(2)
      ..write(obj.daysPerWeek)
      ..writeByte(3)
      ..write(obj.workoutDayIds)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.muscleCombinations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutPlanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
