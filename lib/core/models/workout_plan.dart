// Data Models for Workout Plans

class Exercise {
  final String id;
  String name;
  String? imagePath;
  String notes;
  String targetMuscle;

  Exercise({
    required this.id,
    required this.name,
    this.imagePath,
    required this.notes,
    required this.targetMuscle,
  });

  // Copy with method for immutability
  Exercise copyWith({
    String? id,
    String? name,
    String? imagePath,
    String? notes,
    String? targetMuscle,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      notes: notes ?? this.notes,
      targetMuscle: targetMuscle ?? this.targetMuscle,
    );
  }

  // Convert to Map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'notes': notes,
      'targetMuscle': targetMuscle,
    };
  }

  // Create from Map
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? '',
      imagePath: json['imagePath'],
      notes: json['notes'] ?? '',
      targetMuscle: json['targetMuscle'] ?? '',
    );
  }
}

class WorkoutDay {
  final String id;
  String dayName;
  List<String> targetMuscles;
  List<Exercise> exercises;
  bool isCompleted;
  bool isExpanded; // For UI expandable/collapsible functionality

  WorkoutDay({
    required this.id,
    required this.dayName,
    required this.targetMuscles,
    required this.exercises,
    this.isCompleted = false,
    this.isExpanded = true,
  });

  WorkoutDay copyWith({
    String? id,
    String? dayName,
    List<String>? targetMuscles,
    List<Exercise>? exercises,
    bool? isCompleted,
    bool? isExpanded,
  }) {
    return WorkoutDay(
      id: id ?? this.id,
      dayName: dayName ?? this.dayName,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      exercises: exercises ?? this.exercises,
      isCompleted: isCompleted ?? this.isCompleted,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayName': dayName,
      'targetMuscles': targetMuscles,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'isCompleted': isCompleted,
    };
  }

  factory WorkoutDay.fromJson(Map<String, dynamic> json) {
    return WorkoutDay(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      dayName: json['dayName'] ?? '',
      targetMuscles: List<String>.from(json['targetMuscles'] ?? []),
      exercises:
          (json['exercises'] as List?)
              ?.map((e) => Exercise.fromJson(e))
              .toList() ??
          [],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class WorkoutPlan {
  final String id;
  String planName;
  int daysPerWeek;
  List<WorkoutDay> days;
  DateTime createdAt;

  WorkoutPlan({
    required this.id,
    required this.planName,
    required this.daysPerWeek,
    required this.days,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  WorkoutPlan copyWith({
    String? id,
    String? planName,
    int? daysPerWeek,
    List<WorkoutDay>? days,
    DateTime? createdAt,
  }) {
    return WorkoutPlan(
      id: id ?? this.id,
      planName: planName ?? this.planName,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      days: days ?? this.days,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planName': planName,
      'daysPerWeek': daysPerWeek,
      'days': days.map((d) => d.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      planName: json['planName'] ?? '',
      daysPerWeek: json['daysPerWeek'] ?? 0,
      days:
          (json['days'] as List?)
              ?.map((d) => WorkoutDay.fromJson(d))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
