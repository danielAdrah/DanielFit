import 'package:hive/hive.dart';

part 'challenge_model.g.dart';

@HiveType(typeId: 3)
class ChallengeModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String challengeName;

  @HiveField(2)
  String description;

  @HiveField(3)
  String targetType; // "Reps" or "Weight"

  @HiveField(4)
  double targetValue;

  @HiveField(5)
  double currentValue;

  @HiveField(6)
  bool isCompleted;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime? completedAt;

  @HiveField(9)
  String unit; // Measurement unit (e.g., "reps", "kg", "lbs")

  ChallengeModel({
    required this.id,
    required this.challengeName,
    required this.description,
    required this.targetType,
    required this.targetValue,
    required this.currentValue,
    this.isCompleted = false,
    DateTime? createdAt,
    this.completedAt,
    required this.unit,
  }) : createdAt = createdAt ?? DateTime.now();

  ChallengeModel copyWith({
    String? id,
    String? challengeName,
    String? description,
    String? targetType,
    double? targetValue,
    double? currentValue,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
    String? unit,
  }) {
    return ChallengeModel(
      id: id ?? this.id,
      challengeName: challengeName ?? this.challengeName,
      description: description ?? this.description,
      targetType: targetType ?? this.targetType,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challengeName': challengeName,
      'description': description,
      'targetType': targetType,
      'targetValue': targetValue,
      'currentValue': currentValue,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'unit': unit,
    };
  }

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      challengeName: json['challengeName'] ?? '',
      description: json['description'] ?? '',
      targetType: json['targetType'] ?? 'Reps',
      targetValue: json['targetValue'] ?? 0.0,
      currentValue: json['currentValue'] ?? 0.0,
      isCompleted: json['isCompleted'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      unit: json['unit'] ?? 'reps',
    );
  }
}
