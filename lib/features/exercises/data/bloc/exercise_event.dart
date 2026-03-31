import 'package:equatable/equatable.dart';
import '../../../../core/models/exercise_model.dart';

/// Base class for all Exercise events
abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all exercises from Hive database
class LoadAllExercisesEvent extends ExerciseEvent {
  const LoadAllExercisesEvent();
}

/// Event to load a single exercise by ID
class LoadExerciseByIdEvent extends ExerciseEvent {
  final String exerciseId;

  const LoadExerciseByIdEvent(this.exerciseId);

  @override
  List<Object?> get props => [exerciseId];
}

/// Event to add a new exercise
class AddExerciseEvent extends ExerciseEvent {
  final ExerciseModel exercise;

  const AddExerciseEvent(this.exercise);

  @override
  List<Object?> get props => [exercise];
}

/// Event to update an existing exercise
class UpdateExerciseEvent extends ExerciseEvent {
  final ExerciseModel exercise;

  const UpdateExerciseEvent(this.exercise);

  @override
  List<Object?> get props => [exercise];
}

/// Event to delete an exercise by ID
class DeleteExerciseEvent extends ExerciseEvent {
  final String exerciseId;

  const DeleteExerciseEvent(this.exerciseId);

  @override
  List<Object?> get props => [exerciseId];
}

/// Event to toggle favorite status
class ToggleFavoriteEvent extends ExerciseEvent {
  final String exerciseId;
  final bool isFavorite;

  const ToggleFavoriteEvent(this.exerciseId, this.isFavorite);

  @override
  List<Object?> get props => [exerciseId, isFavorite];
}

/// Event to toggle hated status
class ToggleHatedEvent extends ExerciseEvent {
  final String exerciseId;
  final bool isHated;

  const ToggleHatedEvent(this.exerciseId, this.isHated);

  @override
  List<Object?> get props => [exerciseId, isHated];
}

/// Event to get exercises by target muscle
class GetExercisesByMuscleEvent extends ExerciseEvent {
  final String muscle;

  const GetExercisesByMuscleEvent(this.muscle);

  @override
  List<Object?> get props => [muscle];
}

/// Event to get all favorite exercises
class GetFavoriteExercisesEvent extends ExerciseEvent {
  const GetFavoriteExercisesEvent();
}

/// Event to get all hated exercises
class GetHatedExercisesEvent extends ExerciseEvent {
  const GetHatedExercisesEvent();
}
