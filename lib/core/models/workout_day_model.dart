import 'package:hive/hive.dart';

part 'workout_day_model.g.dart';

@HiveType(typeId: 1)
class WorkoutDayModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String dayName;

  @HiveField(2)
  List<String> targetMuscles;

  @HiveField(3)
  List<String> exerciseIds; // References to Exercise models

  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  bool isExpanded;

  @HiveField(6)
  int order;

  WorkoutDayModel({
    required this.id,
    required this.dayName,
    required this.targetMuscles,
    List<String>? exerciseIds,
    this.isCompleted = false,
    this.isExpanded = true,
    required this.order,
  }) : exerciseIds = exerciseIds ?? [];

  WorkoutDayModel copyWith({
    String? id,
    String? dayName,
    List<String>? targetMuscles,
    List<String>? exerciseIds,
    bool? isCompleted,
    bool? isExpanded,
    int? order,
  }) {
    return WorkoutDayModel(
      id: id ?? this.id,
      dayName: dayName ?? this.dayName,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      exerciseIds: exerciseIds ?? this.exerciseIds,
      isCompleted: isCompleted ?? this.isCompleted,
      isExpanded: isExpanded ?? this.isExpanded,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayName': dayName,
      'targetMuscles': targetMuscles,
      'exerciseIds': exerciseIds,
      'isCompleted': isCompleted,
      'isExpanded': isExpanded,
      'order': order,
    };
  }

  factory WorkoutDayModel.fromJson(Map<String, dynamic> json) {
    return WorkoutDayModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      dayName: json['dayName'] ?? '',
      targetMuscles: List<String>.from(json['targetMuscles'] ?? []),
      exerciseIds: List<String>.from(json['exerciseIds'] ?? []),
      isCompleted: json['isCompleted'] ?? false,
      isExpanded: json['isExpanded'] ?? true,
      order: json['order'] ?? 0,
    );
  }
}
