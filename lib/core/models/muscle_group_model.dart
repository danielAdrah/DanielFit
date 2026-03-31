import 'package:hive/hive.dart';

part 'muscle_group_model.g.dart';

@HiveType(typeId: 8)
class MuscleGroupModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String muscleGroup;

  @HiveField(3)
  List<String> exerciseIds;

  @HiveField(4)
  String? frontImageMap;

  @HiveField(5)
  String? backImageMap;

  @HiveField(6)
  int displayOrder;

  MuscleGroupModel({
    required this.id,
    required this.name,
    required this.muscleGroup,
    List<String>? exerciseIds,
    this.frontImageMap,
    this.backImageMap,
    required this.displayOrder,
  }) : exerciseIds = exerciseIds ?? [];

  MuscleGroupModel copyWith({
    String? id,
    String? name,
    String? muscleGroup,
    List<String>? exerciseIds,
    String? frontImageMap,
    String? backImageMap,
    int? displayOrder,
  }) {
    return MuscleGroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      exerciseIds: exerciseIds ?? this.exerciseIds,
      frontImageMap: frontImageMap ?? this.frontImageMap,
      backImageMap: backImageMap ?? this.backImageMap,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'muscleGroup': muscleGroup,
      'exerciseIds': exerciseIds,
      'frontImageMap': frontImageMap,
      'backImageMap': backImageMap,
      'displayOrder': displayOrder,
    };
  }

  factory MuscleGroupModel.fromJson(Map<String, dynamic> json) {
    return MuscleGroupModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? '',
      muscleGroup: json['muscleGroup'] ?? '',
      exerciseIds: List<String>.from(json['exerciseIds'] ?? []),
      frontImageMap: json['frontImageMap'],
      backImageMap: json['backImageMap'],
      displayOrder: json['displayOrder'] ?? 0,
    );
  }
}
