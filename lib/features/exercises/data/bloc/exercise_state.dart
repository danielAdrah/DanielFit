import 'package:equatable/equatable.dart';
import '../../../../core/models/exercise_model.dart';

/// Base class for all Exercise states
abstract class ExerciseState extends Equatable {
  const ExerciseState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no actions performed yet
class ExerciseInitial extends ExerciseState {
  const ExerciseInitial();
}

/// Loading state - data is being fetched/processed
class ExerciseLoading extends ExerciseState {
  const ExerciseLoading();
}

/// Success state - exercises loaded successfully
class ExerciseLoaded extends ExerciseState {
  final List<ExerciseModel> exercises;

  const ExerciseLoaded(this.exercises);

  @override
  List<Object?> get props => [exercises];
}

/// Single exercise loaded successfully
class ExerciseDetailLoaded extends ExerciseState {
  final ExerciseModel exercise;

  const ExerciseDetailLoaded(this.exercise);

  @override
  List<Object?> get props => [exercise];
}

/// Exercise added successfully
class ExerciseAdded extends ExerciseState {
  final ExerciseModel exercise;

  const ExerciseAdded(this.exercise);

  @override
  List<Object?> get props => [exercise];
}

/// Exercise updated successfully
class ExerciseUpdated extends ExerciseState {
  final ExerciseModel exercise;

  const ExerciseUpdated(this.exercise);

  @override
  List<Object?> get props => [exercise];
}

/// Exercise deleted successfully
class ExerciseDeleted extends ExerciseState {
  final String exerciseId;

  const ExerciseDeleted(this.exerciseId);

  @override
  List<Object?> get props => [exerciseId];
}

/// Favorite status toggled successfully
class ExerciseFavoriteToggled extends ExerciseState {
  final ExerciseModel exercise;

  const ExerciseFavoriteToggled(this.exercise);

  @override
  List<Object?> get props => [exercise];
}

/// Hated status toggled successfully
class ExerciseHatedToggled extends ExerciseState {
  final ExerciseModel exercise;

  const ExerciseHatedToggled(this.exercise);

  @override
  List<Object?> get props => [exercise];
}

/// Error state - operation failed
class ExerciseError extends ExerciseState {
  final String message;

  const ExerciseError(this.message);

  @override
  List<Object?> get props => [message];
}
