// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_part_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BodyPartCoordinatesAdapter extends TypeAdapter<BodyPartCoordinates> {
  @override
  final int typeId = 9;

  @override
  BodyPartCoordinates read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BodyPartCoordinates(
      top: fields[0] as double,
      left: fields[1] as double,
      width: fields[2] as double,
      height: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BodyPartCoordinates obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.top)
      ..writeByte(1)
      ..write(obj.left)
      ..writeByte(2)
      ..write(obj.width)
      ..writeByte(3)
      ..write(obj.height);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BodyPartCoordinatesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BodyPartModelAdapter extends TypeAdapter<BodyPartModel> {
  @override
  final int typeId = 10;

  @override
  BodyPartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BodyPartModel(
      id: fields[0] as String,
      bodyPartName: fields[1] as String,
      muscleCategory: fields[2] as String,
      view: fields[3] as String,
      coordinates: fields[4] as BodyPartCoordinates,
    );
  }

  @override
  void write(BinaryWriter writer, BodyPartModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bodyPartName)
      ..writeByte(2)
      ..write(obj.muscleCategory)
      ..writeByte(3)
      ..write(obj.view)
      ..writeByte(4)
      ..write(obj.coordinates);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BodyPartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
