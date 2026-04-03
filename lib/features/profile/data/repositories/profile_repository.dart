import 'dart:io';
import '../../../../core/models/hive_registry.dart';
import '../../../../core/models/exercise_model.dart';
import '../../../../core/models/workout_plan_model.dart';
import '../../../../core/models/challenge_model.dart';
import '../../../../core/models/user_profile_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Repository interface for Profile data operations
/// Defines the contract that all profile repositories must implement
abstract class ProfileRepository {
  /// Get all profile statistics from various data sources
  Future<Map<String, int>> getProfileStatistics();

  /// Get muscle group distribution (count of exercises per muscle group)
  Future<Map<String, int>> getMuscleGroupDistribution();

  /// Get current user profile
  Future<UserProfileModel?> getUserProfile();

  /// Update user profile
  Future<void> updateUserProfile(UserProfileModel profile);

  /// Pick image from gallery
  Future<File?> pickImageFromGallery();

  /// Save image to local storage and return path
  Future<String?> saveImageToStorage(File imageFile, String fileName);

  /// Delete profile image
  Future<void> deleteProfileImage(String imagePath);
}

/// Implementation of ProfileRepository using Hive directly
class ProfileRepositoryImpl implements ProfileRepository {
  late final Box<UserProfileModel> _profileBox;
  final ImagePicker _imagePicker = ImagePicker();

  ProfileRepositoryImpl() {
    _profileBox = Hive.box<UserProfileModel>(HiveBoxes.userProfile);
  }
  @override
  Future<Map<String, int>> getProfileStatistics() async {
    try {
      // Access Hive boxes directly to avoid circular dependencies
      final exercisesBox = Hive.box<ExerciseModel>(HiveBoxes.exercises);
      final workoutPlansBox = Hive.box<WorkoutPlanModel>('workout_plans');
      final challengesBox = Hive.box<ChallengeModel>(HiveBoxes.challenges);

      // Get total exercises (excluding plan-specific exercises)
      final totalExercises = exercisesBox.values
          .where((exercise) => !exercise.isPlanExercise)
          .length;

      // Get total favorite exercises
      final totalFavorites = exercisesBox.values
          .where((exercise) => exercise.isFavorite)
          .length;

      // Get total workout plans
      final totalPlans = workoutPlansBox.values.length;

      // Get total challenges
      final totalChallenges = challengesBox.values.length;

      return {
        'totalExercises': totalExercises,
        'totalFavorites': totalFavorites,
        'totalPlans': totalPlans,
        'totalChallenges': totalChallenges,
      };
    } catch (e) {
      throw Exception('Failed to load profile statistics: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, int>> getMuscleGroupDistribution() async {
    try {
      final exercisesBox = Hive.box<ExerciseModel>(HiveBoxes.exercises);
      final muscleGroupCounts = <String, int>{};

      // Group exercises by target muscle (excluding plan-specific exercises)
      for (var exercise in exercisesBox.values) {
        if (!exercise.isPlanExercise && exercise.targetMuscle.isNotEmpty) {
          final muscle = exercise.targetMuscle;
          muscleGroupCounts[muscle] = (muscleGroupCounts[muscle] ?? 0) + 1;
        }
      }

      return muscleGroupCounts;
    } catch (e) {
      throw Exception(
        'Failed to load muscle group distribution: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserProfileModel?> getUserProfile() async {
    try {
      return _profileBox.get('user_profile');
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUserProfile(UserProfileModel profile) async {
    try {
      await _profileBox.put('user_profile', profile);
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }

  @override
  Future<File?> pickImageFromGallery() async {
    try {
      print("!");
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      print("2");

      if (pickedFile == null) return null;
      print("3");

      return File(pickedFile.path);
    } catch (e) {
      print(e);
      throw Exception('Failed to pick image: ${e.toString()}');
    }
  }

  @override
  Future<String?> saveImageToStorage(File imageFile, String fileName) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final profileImagesDir = Directory('${appDir.path}/profile_images');

      // Create directory if it doesn't exist
      if (!await profileImagesDir.exists()) {
        await profileImagesDir.create(recursive: true);
      }

      // Generate unique filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final savedImage = await imageFile.copy(
        '${profileImagesDir.path}/${fileName}_$timestamp.jpg',
      );

      return savedImage.path;
    } catch (e) {
      throw Exception('Failed to save image: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteProfileImage(String imagePath) async {
    try {
      final imageFile = File(imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete image: ${e.toString()}');
    }
  }
}
