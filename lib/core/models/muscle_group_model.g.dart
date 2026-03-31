// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muscle_group_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MuscleGroupModelAdapter extends TypeAdapter<MuscleGroupModel> {
  @override
  final int typeId = 8;

  @override
  MuscleGroupModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MuscleGroupModel(
      id: fields[0] as String,
      name: fields[1] as String,
      muscleGroup: fields[2] as String,
      exerciseIds: (fields[3] as List?)?.cast<String>(),
      frontImageMap: fields[4] as String?,
      backImageMap: fields[5] as String?,
      displayOrder: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MuscleGroupModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.muscleGroup)
      ..writeByte(3)
      ..write(obj.exerciseIds)
      ..writeByte(4)
      ..write(obj.frontImageMap)
      ..writeByte(5)
      ..write(obj.backImageMap)
      ..writeByte(6)
      ..write(obj.displayOrder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MuscleGroupModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
