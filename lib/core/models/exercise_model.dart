import 'package:hive/hive.dart';

part 'exercise_model.g.dart';

@HiveType(typeId: 0)
class ExerciseModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? imagePath;

  @HiveField(3)
  String notes;

  @HiveField(4)
  String targetMuscle;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  bool isFavorite;

  @HiveField(7)
  bool isHated;

  @HiveField(8)
  bool isPlanExercise;

  @HiveField(9)
  double? highestWeight;

  ExerciseModel({
    required this.id,
    required this.name,
    this.imagePath,
    required this.notes,
    required this.targetMuscle,
    DateTime? createdAt,
    this.isFavorite = false,
    this.isHated = false,
    this.isPlanExercise = false,
    this.highestWeight,
  }) : createdAt = createdAt ?? DateTime.now();

  // Copy with method for immutability
  ExerciseModel copyWith({
    String? id,
    String? name,
    String? imagePath,
    String? notes,
    String? targetMuscle,
    DateTime? createdAt,
    bool? isFavorite,
    bool? isHated,
    bool? isPlanExercise,
    double? highestWeight,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      notes: notes ?? this.notes,
      targetMuscle: targetMuscle ?? this.targetMuscle,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isHated: isHated ?? this.isHated,
      isPlanExercise: isPlanExercise ?? this.isPlanExercise,
      highestWeight: highestWeight ?? this.highestWeight,
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
      'createdAt': createdAt.toIso8601String(),
      'isFavorite': isFavorite,
      'isHated': isHated,
      'isPlanExercise': isPlanExercise,
      'highestWeight': highestWeight,
    };
  }

  // Create from Map
  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? '',
      imagePath: json['imagePath'],
      notes: json['notes'] ?? '',
      targetMuscle: json['targetMuscle'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isFavorite: json['isFavorite'] ?? false,
      isHated: json['isHated'] ?? false,
      isPlanExercise: json['isPlanExercise'] ?? false,
      highestWeight: json['highestWeight']?.toDouble(),
    );
  }
}
