// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileModelAdapter extends TypeAdapter<UserProfileModel> {
  @override
  final int typeId = 4;

  @override
  UserProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfileModel(
      id: fields[0] as String,
      username: fields[1] as String,
      profileImagePath: fields[2] as String?,
      trainingStartDate: fields[3] as DateTime?,
      totalExercises: fields[4] as int,
      totalFavorites: fields[5] as int,
      totalPlans: fields[6] as int,
      totalChallenges: fields[7] as int,
      favoriteExerciseId: fields[8] as String?,
      defaultWeightUnit: fields[9] as String,
      theme: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfileModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.profileImagePath)
      ..writeByte(3)
      ..write(obj.trainingStartDate)
      ..writeByte(4)
      ..write(obj.totalExercises)
      ..writeByte(5)
      ..write(obj.totalFavorites)
      ..writeByte(6)
      ..write(obj.totalPlans)
      ..writeByte(7)
      ..write(obj.totalChallenges)
      ..writeByte(8)
      ..write(obj.favoriteExerciseId)
      ..writeByte(9)
      ..write(obj.defaultWeightUnit)
      ..writeByte(10)
      ..write(obj.theme);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
