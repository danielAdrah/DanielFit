import 'package:hive/hive.dart';
import '../../../../core/models/workout_plan_model.dart';
import '../../../../core/models/workout_day_model.dart';
import '../../../../core/models/exercise_model.dart';

/// Repository interface for WorkoutPlan data operations
abstract class WorkoutPlanRepository {
  /// Get all workout plans from the database
  Future<List<WorkoutPlanModel>> getAllWorkoutPlans();

  /// Get a specific workout plan by ID
  Future<WorkoutPlanModel?> getWorkoutPlanById(String id);

  /// Add a new workout plan to the database
  Future<void> addWorkoutPlan(WorkoutPlanModel workoutPlan);

  /// Update an existing workout plan
  Future<void> updateWorkoutPlan(WorkoutPlanModel workoutPlan);

  /// Delete a workout plan by ID
  Future<void> deleteWorkoutPlan(String id);

  /// Toggle workout plan favorite status
  Future<void> toggleFavorite(String id, bool isFavorite);

  /// Get workout plans filtered by category
  Future<List<WorkoutPlanModel>> getWorkoutPlansByCategory(String category);

  /// Get favorite workout plans
  Future<List<WorkoutPlanModel>> getFavoriteWorkoutPlans();

  /// Add workout day to plan
  Future<void> addWorkoutDayToPlan(String workoutPlanId, String workoutDayId);

  /// Remove workout day from plan
  Future<void> removeWorkoutDayFromPlan(
    String workoutPlanId,
    String workoutDayId,
  );

  /// Load workout days for a specific plan
  Future<List<WorkoutDayModel>> getWorkoutDaysByPlanIds(
    List<String> workoutDayIds,
  );

  /// Load exercises for a specific workout day
  Future<List<ExerciseModel>> getExercisesByDayIds(List<String> exerciseIds);
}

/// Implementation of WorkoutPlanRepository using Hive
class WorkoutPlanRepositoryImpl implements WorkoutPlanRepository {
  late final Box<WorkoutPlanModel> _workoutPlansBox;
  late final Box<WorkoutDayModel> _workoutDaysBox;

  WorkoutPlanRepositoryImpl() {
    _workoutPlansBox = Hive.box<WorkoutPlanModel>('workout_plans');
    _workoutDaysBox = Hive.box<WorkoutDayModel>('workout_days');
  }

  @override
  Future<List<WorkoutPlanModel>> getAllWorkoutPlans() async {
    try {
      return _workoutPlansBox.values.toList();
    } catch (e) {
      throw Exception('Failed to load workout plans: ${e.toString()}');
    }
  }

  @override
  Future<WorkoutPlanModel?> getWorkoutPlanById(String id) async {
    try {
      return _workoutPlansBox.get(id);
    } catch (e) {
      throw Exception('Failed to get workout plan: ${e.toString()}');
    }
  }

  @override
  Future<void> addWorkoutPlan(WorkoutPlanModel workoutPlan) async {
    try {
      await _workoutPlansBox.put(workoutPlan.id, workoutPlan);
    } catch (e) {
      throw Exception('Failed to add workout plan: ${e.toString()}');
    }
  }

  @override
  Future<void> updateWorkoutPlan(WorkoutPlanModel workoutPlan) async {
    try {
      final existingPlan = _workoutPlansBox.get(workoutPlan.id);
      if (existingPlan != null) {
        await _workoutPlansBox.put(workoutPlan.id, workoutPlan);
      } else {
        throw Exception('Workout plan not found: ${workoutPlan.id}');
      }
    } catch (e) {
      throw Exception('Failed to update workout plan: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteWorkoutPlan(String id) async {
    try {
      final workoutPlan = _workoutPlansBox.get(id);
      if (workoutPlan != null) {
        // Delete associated workout days
        for (final dayId in workoutPlan.workoutDayIds) {
          await _workoutDaysBox.delete(dayId);
        }
        // Delete the workout plan
        await _workoutPlansBox.delete(id);
      } else {
        throw Exception('Workout plan not found: $id');
      }
    } catch (e) {
      throw Exception('Failed to delete workout plan: ${e.toString()}');
    }
  }

  @override
  Future<void> toggleFavorite(String id, bool isFavorite) async {
    try {
      final workoutPlan = _workoutPlansBox.get(id);
      if (workoutPlan != null) {
        // Note: WorkoutPlanModel doesn't have isFavorite field by default
        // You may need to add it to the model or use a different approach
        throw Exception(
          'Toggle favorite not implemented - add isFavorite field to WorkoutPlanModel',
        );
      } else {
        throw Exception('Workout plan not found: $id');
      }
    } catch (e) {
      throw Exception('Failed to toggle favorite: ${e.toString()}');
    }
  }

  @override
  Future<List<WorkoutPlanModel>> getWorkoutPlansByCategory(
    String category,
  ) async {
    try {
      // Filter by muscle combinations or description
      return _workoutPlansBox.values
          .where(
            (plan) =>
                plan.muscleCombinations.contains(category) ||
                (plan.description?.toLowerCase().contains(
                      category.toLowerCase(),
                    ) ??
                    false),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to filter workout plans: ${e.toString()}');
    }
  }

  @override
  Future<List<WorkoutPlanModel>> getFavoriteWorkoutPlans() async {
    try {
      // Note: This requires adding isFavorite field to WorkoutPlanModel
      // For now, returning empty list as placeholder
      return [];
    } catch (e) {
      throw Exception('Failed to load favorite workout plans: ${e.toString()}');
    }
  }

  @override
  Future<void> addWorkoutDayToPlan(
    String workoutPlanId,
    String workoutDayId,
  ) async {
    try {
      final workoutPlan = _workoutPlansBox.get(workoutPlanId);
      if (workoutPlan != null) {
        final updatedDayIds = List<String>.from(workoutPlan.workoutDayIds)
          ..add(workoutDayId);

        final updatedPlan = workoutPlan.copyWith(
          workoutDayIds: updatedDayIds,
          daysPerWeek: updatedDayIds.length,
        );

        await _workoutPlansBox.put(workoutPlanId, updatedPlan);
      } else {
        throw Exception('Workout plan not found: $workoutPlanId');
      }
    } catch (e) {
      throw Exception('Failed to add workout day to plan: ${e.toString()}');
    }
  }

  @override
  Future<void> removeWorkoutDayFromPlan(
    String workoutPlanId,
    String workoutDayId,
  ) async {
    try {
      final workoutPlan = _workoutPlansBox.get(workoutPlanId);
      if (workoutPlan != null) {
        final updatedDayIds = List<String>.from(workoutPlan.workoutDayIds)
          ..remove(workoutDayId);

        final updatedPlan = workoutPlan.copyWith(
          workoutDayIds: updatedDayIds,
          daysPerWeek: updatedDayIds.length,
        );

        await _workoutPlansBox.put(workoutPlanId, updatedPlan);

        // Optionally delete the workout day itself
        await _workoutDaysBox.delete(workoutDayId);
      } else {
        throw Exception('Workout plan not found: $workoutPlanId');
      }
    } catch (e) {
      throw Exception(
        'Failed to remove workout day from plan: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<WorkoutDayModel>> getWorkoutDaysByPlanIds(
    List<String> workoutDayIds,
  ) async {
    try {
      final workoutDays = <WorkoutDayModel>[];

      for (final dayId in workoutDayIds) {
        final day = _workoutDaysBox.get(dayId);
        if (day != null) {
          workoutDays.add(day);
        }
      }

      return workoutDays;
    } catch (e) {
      throw Exception('Failed to load workout days: ${e.toString()}');
    }
  }

  @override
  Future<List<ExerciseModel>> getExercisesByDayIds(
    List<String> exerciseIds,
  ) async {
    try {
      final exercisesBox = Hive.box<ExerciseModel>('exercises');
      final exercises = <ExerciseModel>[];

      for (final exerciseId in exerciseIds) {
        final exercise = exercisesBox.get(exerciseId);
        if (exercise != null) {
          exercises.add(exercise);
        }
      }

      return exercises;
    } catch (e) {
      throw Exception('Failed to load exercises: ${e.toString()}');
    }
  }
}
