// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SetModelAdapter extends TypeAdapter<SetModel> {
  @override
  final int typeId = 5;

  @override
  SetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SetModel(
      reps: fields[0] as int,
      weight: fields[1] as double,
      completed: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SetModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.reps)
      ..writeByte(1)
      ..write(obj.weight)
      ..writeByte(2)
      ..write(obj.completed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseLogEntryAdapter extends TypeAdapter<ExerciseLogEntry> {
  @override
  final int typeId = 6;

  @override
  ExerciseLogEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseLogEntry(
      exerciseId: fields[0] as String,
      sets: (fields[1] as List?)?.cast<SetModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseLogEntry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.exerciseId)
      ..writeByte(1)
      ..write(obj.sets);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseLogEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseLogModelAdapter extends TypeAdapter<ExerciseLogModel> {
  @override
  final int typeId = 7;

  @override
  ExerciseLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseLogModel(
      id: fields[0] as String,
      workoutDayId: fields[1] as String,
      workoutPlanId: fields[2] as String,
      completedAt: fields[3] as DateTime?,
      duration: fields[4] as int,
      exercises: (fields[5] as List?)?.cast<ExerciseLogEntry>(),
      notes: fields[6] as String?,
      rating: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseLogModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.workoutDayId)
      ..writeByte(2)
      ..write(obj.workoutPlanId)
      ..writeByte(3)
      ..write(obj.completedAt)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.exercises)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
