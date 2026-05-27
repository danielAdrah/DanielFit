import 'dart:core';

import 'package:hive/hive.dart';
part 'workout_plan_model.g.dart';

@HiveType(typeId: 2)
class WorkoutPlanModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String planName;

  @HiveField(2)
  int daysPerWeek;

  @HiveField(3)
  List<String> workoutDayIds; // References to WorkoutDay models

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  String? description;

  @HiveField(6)
  List<String> muscleCombinations;

  @HiveField(7)
  DateTime? startDate;

  @HiveField(8)
  List<int> restDays;

  WorkoutPlanModel({
    required this.id,
    required this.planName,
    required this.daysPerWeek,
    List<String>? workoutDayIds,
    DateTime? createdAt,
    this.description,
    List<String>? muscleCombinations,
    this.startDate,
    List<int>? restDays,
  }) : workoutDayIds = workoutDayIds ?? [],
       muscleCombinations = muscleCombinations ?? [],
       restDays = restDays ?? [],
       createdAt = createdAt ?? DateTime.now();

  WorkoutPlanModel copyWith({
    String? id,
    String? planName,
    int? daysPerWeek,
    List<String>? workoutDayIds,
    DateTime? createdAt,
    String? description,
    List<String>? muscleCombinations,
    DateTime? startDate,
    List<int>? restDays,
  }) {
    return WorkoutPlanModel(
      id: id ?? this.id,
      planName: planName ?? this.planName,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      workoutDayIds: workoutDayIds ?? this.workoutDayIds,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      muscleCombinations: muscleCombinations ?? this.muscleCombinations,
      startDate: startDate ?? this.startDate,
      restDays: restDays ?? this.restDays,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planName': planName,
      'daysPerWeek': daysPerWeek,
      'workoutDayIds': workoutDayIds,
      'createdAt': createdAt.toIso8601String(),
      'description': description,
      'muscleCombinations': muscleCombinations,
      'startDate': startDate?.toIso8601String(),
      'restDays': restDays,
    };
  }

  factory WorkoutPlanModel.fromJson(Map<String, dynamic> json) {
    return WorkoutPlanModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      planName: json['planName'] ?? '',
      daysPerWeek: json['daysPerWeek'] ?? 0,
      workoutDayIds: List<String>.from(json['workoutDayIds'] ?? []),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      description: json['description'],
      muscleCombinations: List<String>.from(json['muscleCombinations'] ?? []),
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      restDays: List<int>.from(json['restDays'] ?? []),
    );
  }
}
