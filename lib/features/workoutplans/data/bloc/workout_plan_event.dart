import 'package:equatable/equatable.dart';
import '../../../../core/models/workout_plan_model.dart';
import '../../../../core/models/workout_day_model.dart';
import '../../../../core/models/exercise_model.dart';

/// Base event for WorkoutPlan BLoC
abstract class WorkoutPlanEvent extends Equatable {
  const WorkoutPlanEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all workout plans from the database
class LoadAllWorkoutPlansEvent extends WorkoutPlanEvent {
  const LoadAllWorkoutPlansEvent();
}

/// Event to load a specific workout plan by ID
class LoadWorkoutPlanByIdEvent extends WorkoutPlanEvent {
  final String workoutPlanId;

  const LoadWorkoutPlanByIdEvent(this.workoutPlanId);

  @override
  List<Object?> get props => [workoutPlanId];
}

/// Event to add a new workout plan to the database
class AddWorkoutPlanEvent extends WorkoutPlanEvent {
  final WorkoutPlanModel workoutPlan;

  const AddWorkoutPlanEvent(this.workoutPlan);

  @override
  List<Object?> get props => [workoutPlan];
}

/// Event to update an existing workout plan
class UpdateWorkoutPlanEvent extends WorkoutPlanEvent {
  final WorkoutPlanModel workoutPlan;

  const UpdateWorkoutPlanEvent(this.workoutPlan);

  @override
  List<Object?> get props => [workoutPlan];
}

/// Event to delete a workout plan by ID
class DeleteWorkoutPlanEvent extends WorkoutPlanEvent {
  final String workoutPlanId;

  const DeleteWorkoutPlanEvent(this.workoutPlanId);

  @override
  List<Object?> get props => [workoutPlanId];
}

/// Event to toggle workout plan favorite status
class ToggleWorkoutPlanFavoriteEvent extends WorkoutPlanEvent {
  final String workoutPlanId;
  final bool isFavorite;

  const ToggleWorkoutPlanFavoriteEvent(this.workoutPlanId, this.isFavorite);

  @override
  List<Object?> get props => [workoutPlanId, isFavorite];
}

/// Event to get workout plans filtered by category
class GetWorkoutPlansByCategoryEvent extends WorkoutPlanEvent {
  final String category;

  const GetWorkoutPlansByCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

/// Event to get favorite workout plans
class GetFavoriteWorkoutPlansEvent extends WorkoutPlanEvent {
  const GetFavoriteWorkoutPlansEvent();
}

/// Event to add workout day to plan
class AddWorkoutDayToPlanEvent extends WorkoutPlanEvent {
  final String workoutPlanId;
  final String workoutDayId;

  const AddWorkoutDayToPlanEvent(this.workoutPlanId, this.workoutDayId);

  @override
  List<Object?> get props => [workoutPlanId, workoutDayId];
}

/// Event to remove workout day from plan
class RemoveWorkoutDayFromPlanEvent extends WorkoutPlanEvent {
  final String workoutPlanId;
  final String workoutDayId;

  const RemoveWorkoutDayFromPlanEvent(this.workoutPlanId, this.workoutDayId);

  @override
  List<Object?> get props => [workoutPlanId, workoutDayId];
}

/// Event to load workout days for a specific plan
class LoadWorkoutDaysForPlanEvent extends WorkoutPlanEvent {
  final List<String> workoutDayIds;

  const LoadWorkoutDaysForPlanEvent(this.workoutDayIds);

  @override
  List<Object?> get props => [workoutDayIds];
}

/// Event to load exercises for a specific workout day
class LoadExercisesForDayEvent extends WorkoutPlanEvent {
  final List<String> exerciseIds;

  const LoadExercisesForDayEvent(this.exerciseIds);

  @override
  List<Object?> get props => [exerciseIds];
}
