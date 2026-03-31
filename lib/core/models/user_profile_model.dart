import 'package:hive/hive.dart';

part 'user_profile_model.g.dart';

@HiveType(typeId: 4)
class UserProfileModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String username;

  @HiveField(2)
  String? profileImagePath;

  @HiveField(3)
  DateTime trainingStartDate;

  @HiveField(4)
  int totalExercises;

  @HiveField(5)
  int totalFavorites;

  @HiveField(6)
  int totalPlans;

  @HiveField(7)
  int totalChallenges;

  @HiveField(8)
  String? favoriteExerciseId;

  @HiveField(9)
  String defaultWeightUnit;

  @HiveField(10)
  String theme;

  UserProfileModel({
    required this.id,
    required this.username,
    this.profileImagePath,
    DateTime? trainingStartDate,
    this.totalExercises = 0,
    this.totalFavorites = 0,
    this.totalPlans = 0,
    this.totalChallenges = 0,
    this.favoriteExerciseId,
    this.defaultWeightUnit = 'kg',
    this.theme = 'dark',
  }) : trainingStartDate = trainingStartDate ?? DateTime.now();

  UserProfileModel copyWith({
    String? id,
    String? username,
    String? profileImagePath,
    DateTime? trainingStartDate,
    int? totalExercises,
    int? totalFavorites,
    int? totalPlans,
    int? totalChallenges,
    String? favoriteExerciseId,
    String? defaultWeightUnit,
    String? theme,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      username: username ?? this.username,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      trainingStartDate: trainingStartDate ?? this.trainingStartDate,
      totalExercises: totalExercises ?? this.totalExercises,
      totalFavorites: totalFavorites ?? this.totalFavorites,
      totalPlans: totalPlans ?? this.totalPlans,
      totalChallenges: totalChallenges ?? this.totalChallenges,
      favoriteExerciseId: favoriteExerciseId ?? this.favoriteExerciseId,
      defaultWeightUnit: defaultWeightUnit ?? this.defaultWeightUnit,
      theme: theme ?? this.theme,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profileImagePath': profileImagePath,
      'trainingStartDate': trainingStartDate.toIso8601String(),
      'totalExercises': totalExercises,
      'totalFavorites': totalFavorites,
      'totalPlans': totalPlans,
      'totalChallenges': totalChallenges,
      'favoriteExerciseId': favoriteExerciseId,
      'defaultWeightUnit': defaultWeightUnit,
      'theme': theme,
    };
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? 'user_profile',
      username: json['username'] ?? 'User',
      profileImagePath: json['profileImagePath'],
      trainingStartDate: json['trainingStartDate'] != null
          ? DateTime.parse(json['trainingStartDate'])
          : DateTime.now(),
      totalExercises: json['totalExercises'] ?? 0,
      totalFavorites: json['totalFavorites'] ?? 0,
      totalPlans: json['totalPlans'] ?? 0,
      totalChallenges: json['totalChallenges'] ?? 0,
      favoriteExerciseId: json['favoriteExerciseId'],
      defaultWeightUnit: json['defaultWeightUnit'] ?? 'kg',
      theme: json['theme'] ?? 'dark',
    );
  }
}
