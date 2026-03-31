import 'package:hive/hive.dart';
import '../models/exercise_model.dart';
import '../models/workout_day_model.dart';
import '../models/workout_plan_model.dart';
import '../models/challenge_model.dart';
import '../models/user_profile_model.dart';
import '../models/exercise_log_model.dart';
import '../models/muscle_group_model.dart';
import '../models/body_part_model.dart';

/// Initialize all Hive adapters for the application
Future<void> initializeHiveAdapters() async {
  // Register all adapters in order matching their typeId
  Hive.registerAdapter(ExerciseModelAdapter());
  Hive.registerAdapter(WorkoutDayModelAdapter());
  Hive.registerAdapter(WorkoutPlanModelAdapter());
  Hive.registerAdapter(ChallengeModelAdapter());
  Hive.registerAdapter(UserProfileModelAdapter());
  Hive.registerAdapter(SetModelAdapter());
  Hive.registerAdapter(ExerciseLogEntryAdapter());
  Hive.registerAdapter(ExerciseLogModelAdapter());
  Hive.registerAdapter(MuscleGroupModelAdapter());
  Hive.registerAdapter(BodyPartCoordinatesAdapter());
  Hive.registerAdapter(BodyPartModelAdapter());

  print('✓ All Hive adapters registered successfully');
}

/// Box names for easy reference
class HiveBoxes {
  static const String exercises = 'exercises';
  static const String workoutPlans = 'workout_plans';
  static const String workoutDays = 'workout_days';
  static const String challenges = 'challenges';
  static const String userProfile = 'user_profile';
  static const String exerciseLogs = 'exercise_logs';
  static const String muscleGroups = 'muscle_groups';
  static const String bodyParts = 'body_parts';

  /// Get all box names
  static List<String> get allBoxes => [
    exercises,
    workoutPlans,
    workoutDays,
    challenges,
    userProfile,
    exerciseLogs,
    muscleGroups,
    bodyParts,
  ];
}
