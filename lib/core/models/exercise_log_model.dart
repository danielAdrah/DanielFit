import 'package:hive/hive.dart';

part 'exercise_log_model.g.dart';

@HiveType(typeId: 5)
class SetModel extends HiveObject {
  @HiveField(0)
  int reps;

  @HiveField(1)
  double weight;

  @HiveField(2)
  bool completed;

  SetModel({required this.reps, required this.weight, this.completed = true});

  SetModel copyWith({int? reps, double? weight, bool? completed}) {
    return SetModel(
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() {
    return {'reps': reps, 'weight': weight, 'completed': completed};
  }

  factory SetModel.fromJson(Map<String, dynamic> json) {
    return SetModel(
      reps: json['reps'] ?? 0,
      weight: json['weight'] ?? 0.0,
      completed: json['completed'] ?? true,
    );
  }
}

@HiveType(typeId: 6)
class ExerciseLogEntry extends HiveObject {
  @HiveField(0)
  String exerciseId;

  @HiveField(1)
  List<SetModel> sets;

  ExerciseLogEntry({required this.exerciseId, List<SetModel>? sets})
    : sets = sets ?? [];

  ExerciseLogEntry copyWith({String? exerciseId, List<SetModel>? sets}) {
    return ExerciseLogEntry(
      exerciseId: exerciseId ?? this.exerciseId,
      sets: sets ?? this.sets,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'sets': sets.map((s) => s.toJson()).toList(),
    };
  }

  factory ExerciseLogEntry.fromJson(Map<String, dynamic> json) {
    return ExerciseLogEntry(
      exerciseId: json['exerciseId'] ?? '',
      sets:
          (json['sets'] as List?)?.map((s) => SetModel.fromJson(s)).toList() ??
          [],
    );
  }
}

@HiveType(typeId: 7)
class ExerciseLogModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String workoutDayId;

  @HiveField(2)
  String workoutPlanId;

  @HiveField(3)
  DateTime completedAt;

  @HiveField(4)
  int duration; // Duration in minutes

  @HiveField(5)
  List<ExerciseLogEntry> exercises;

  @HiveField(6)
  String? notes;

  @HiveField(7)
  int? rating;

  ExerciseLogModel({
    required this.id,
    required this.workoutDayId,
    required this.workoutPlanId,
    DateTime? completedAt,
    required this.duration,
    List<ExerciseLogEntry>? exercises,
    this.notes,
    this.rating,
  }) : completedAt = completedAt ?? DateTime.now(),
       exercises = exercises ?? [];

  ExerciseLogModel copyWith({
    String? id,
    String? workoutDayId,
    String? workoutPlanId,
    DateTime? completedAt,
    int? duration,
    List<ExerciseLogEntry>? exercises,
    String? notes,
    int? rating,
  }) {
    return ExerciseLogModel(
      id: id ?? this.id,
      workoutDayId: workoutDayId ?? this.workoutDayId,
      workoutPlanId: workoutPlanId ?? this.workoutPlanId,
      completedAt: completedAt ?? this.completedAt,
      duration: duration ?? this.duration,
      exercises: exercises ?? this.exercises,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workoutDayId': workoutDayId,
      'workoutPlanId': workoutPlanId,
      'completedAt': completedAt.toIso8601String(),
      'duration': duration,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'notes': notes,
      'rating': rating,
    };
  }

  factory ExerciseLogModel.fromJson(Map<String, dynamic> json) {
    return ExerciseLogModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      workoutDayId: json['workoutDayId'] ?? '',
      workoutPlanId: json['workoutPlanId'] ?? '',
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : DateTime.now(),
      duration: json['duration'] ?? 0,
      exercises:
          (json['exercises'] as List?)
              ?.map((e) => ExerciseLogEntry.fromJson(e))
              .toList() ??
          [],
      notes: json['notes'],
      rating: json['rating'],
    );
  }
}
