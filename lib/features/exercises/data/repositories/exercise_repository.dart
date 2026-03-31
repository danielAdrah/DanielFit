import 'package:hive/hive.dart';

// Import from core models - ExerciseModel and HiveBoxes
import '../../../../core/models/exercise_model.dart' show ExerciseModel;
import '../../../../core/models/hive_registry.dart' show HiveBoxes;

/// Repository interface for Exercise data operations
/// Defines the contract that all exercise repositories must implement
abstract class ExerciseRepository {
  /// Get all exercises from the database
  Future<List<ExerciseModel>> getAllExercises();

  /// Get a single exercise by ID
  Future<ExerciseModel?> getExerciseById(String id);

  /// Add a new exercise to the database
  Future<void> addExercise(ExerciseModel exercise);

  /// Update an existing exercise
  Future<void> updateExercise(ExerciseModel exercise);

  /// Delete an exercise by ID
  Future<void> deleteExercise(String id);

  /// Toggle favorite status
  Future<void> toggleFavorite(String id, bool isFavorite);

  /// Toggle hated status
  Future<void> toggleHated(String id, bool isHated);

  /// Get exercises by target muscle
  Future<List<ExerciseModel>> getExercisesByMuscle(String muscle);

  /// Get all favorite exercises
  Future<List<ExerciseModel>> getFavoriteExercises();

  /// Get all hated exercises
  Future<List<ExerciseModel>> getHatedExercises();
}

/// Hive implementation of the ExerciseRepository
class ExerciseRepositoryImpl implements ExerciseRepository {
  final Box<ExerciseModel> _exercisesBox;

  ExerciseRepositoryImpl()
    : _exercisesBox = Hive.box<ExerciseModel>(HiveBoxes.exercises);

  @override
  Future<List<ExerciseModel>> getAllExercises() async {
    try {
      return _exercisesBox.values.toList();
    } catch (e) {
      throw Exception('Failed to load exercises: ${e.toString()}');
    }
  }

  @override
  Future<ExerciseModel?> getExerciseById(String id) async {
    try {
      return _exercisesBox.get(id);
    } catch (e) {
      throw Exception('Failed to load exercise: ${e.toString()}');
    }
  }

  @override
  Future<void> addExercise(ExerciseModel exercise) async {
    try {
      await _exercisesBox.put(exercise.id, exercise);
    } catch (e) {
      throw Exception('Failed to add exercise: ${e.toString()}');
    }
  }

  @override
  Future<void> updateExercise(ExerciseModel exercise) async {
    try {
      await _exercisesBox.put(exercise.id, exercise);
    } catch (e) {
      throw Exception('Failed to update exercise: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteExercise(String id) async {
    try {
      await _exercisesBox.delete(id);
    } catch (e) {
      throw Exception('Failed to delete exercise: ${e.toString()}');
    }
  }

  @override
  Future<void> toggleFavorite(String id, bool isFavorite) async {
    try {
      final exercise = _exercisesBox.get(id);
      if (exercise != null) {
        // If marking as favorite, ensure hated is set to false
        final updated = exercise.copyWith(
          isFavorite: isFavorite,
          isHated: isFavorite ? false : exercise.isHated,
        );
        await _exercisesBox.put(id, updated);
      } else {
        throw Exception('Exercise not found: $id');
      }
    } catch (e) {
      throw Exception('Failed to toggle favorite: ${e.toString()}');
    }
  }

  @override
  Future<void> toggleHated(String id, bool isHated) async {
    try {
      final exercise = _exercisesBox.get(id);
      if (exercise != null) {
        // If marking as hated, ensure favorite is set to false
        final updated = exercise.copyWith(
          isHated: isHated,
          isFavorite: isHated ? false : exercise.isFavorite,
        );
        await _exercisesBox.put(id, updated);
      } else {
        throw Exception('Exercise not found: $id');
      }
    } catch (e) {
      throw Exception('Failed to toggle hated: ${e.toString()}');
    }
  }

  @override
  Future<List<ExerciseModel>> getExercisesByMuscle(String muscle) async {
    try {
      return _exercisesBox.values
          .where((exercise) => exercise.targetMuscle == muscle)
          .toList();
    } catch (e) {
      throw Exception('Failed to filter exercises by muscle: ${e.toString()}');
    }
  }

  @override
  Future<List<ExerciseModel>> getFavoriteExercises() async {
    try {
      return _exercisesBox.values
          .where((exercise) => exercise.isFavorite)
          .toList();
    } catch (e) {
      throw Exception('Failed to load favorite exercises: ${e.toString()}');
    }
  }

  @override
  Future<List<ExerciseModel>> getHatedExercises() async {
    try {
      return _exercisesBox.values
          .where((exercise) => exercise.isHated)
          .toList();
    } catch (e) {
      throw Exception('Failed to load hated exercises: ${e.toString()}');
    }
  }
}
