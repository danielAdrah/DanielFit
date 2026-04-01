import 'package:equatable/equatable.dart';
import '../../../../core/models/workout_plan_model.dart';
import '../../../../core/models/workout_day_model.dart';
import '../../../../core/models/exercise_model.dart';

/// Base state for WorkoutPlan BLoC
abstract class WorkoutPlanState extends Equatable {
  const WorkoutPlanState();

  @override
  List<Object?> get props => [];
}

/// Initial state when no events have been triggered
class WorkoutPlanInitial extends WorkoutPlanState {
  const WorkoutPlanInitial();
}

/// State when workout plans are being loaded
class WorkoutPlanLoading extends WorkoutPlanState {
  const WorkoutPlanLoading();
}

/// State when all workout plans have been loaded successfully
class WorkoutPlanLoaded extends WorkoutPlanState {
  final List<WorkoutPlanModel> workoutPlans;

  const WorkoutPlanLoaded(this.workoutPlans);

  @override
  List<Object?> get props => [workoutPlans];
}

/// State when a single workout plan has been loaded
class SingleWorkoutPlanLoaded extends WorkoutPlanState {
  final WorkoutPlanModel workoutPlan;

  const SingleWorkoutPlanLoaded(this.workoutPlan);

  @override
  List<Object?> get props => [workoutPlan];
}

/// State when there's an error loading workout plans
class WorkoutPlanError extends WorkoutPlanState {
  final String message;

  const WorkoutPlanError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when a workout plan has been successfully added
class WorkoutPlanAdded extends WorkoutPlanState {
  final WorkoutPlanModel workoutPlan;

  const WorkoutPlanAdded(this.workoutPlan);

  @override
  List<Object?> get props => [workoutPlan];
}

/// State when a workout plan has been successfully updated
class WorkoutPlanUpdated extends WorkoutPlanState {
  final WorkoutPlanModel workoutPlan;

  const WorkoutPlanUpdated(this.workoutPlan);

  @override
  List<Object?> get props => [workoutPlan];
}

/// State when a workout plan has been deleted
class WorkoutPlanDeleted extends WorkoutPlanState {
  final String workoutPlanId;

  const WorkoutPlanDeleted(this.workoutPlanId);

  @override
  List<Object?> get props => [workoutPlanId];
}

/// State when workout plan favorite status has been toggled
class WorkoutPlanFavoriteToggled extends WorkoutPlanState {
  final WorkoutPlanModel workoutPlan;

  const WorkoutPlanFavoriteToggled(this.workoutPlan);

  @override
  List<Object?> get props => [workoutPlan];
}

/// State when workout plans have been filtered by category
class WorkoutPlansFilteredByCategory extends WorkoutPlanState {
  final List<WorkoutPlanModel> workoutPlans;
  final String category;

  const WorkoutPlansFilteredByCategory(this.workoutPlans, this.category);

  @override
  List<Object?> get props => [workoutPlans, category];
}

/// State when a workout day has been added to plan
class WorkoutDayAddedToPlan extends WorkoutPlanState {
  final String workoutPlanId;
  final String workoutDayId;

  const WorkoutDayAddedToPlan(this.workoutPlanId, this.workoutDayId);

  @override
  List<Object?> get props => [workoutPlanId, workoutDayId];
}

/// State when a workout day has been removed from plan
class WorkoutDayRemovedFromPlan extends WorkoutPlanState {
  final String workoutPlanId;
  final String workoutDayId;

  const WorkoutDayRemovedFromPlan(this.workoutPlanId, this.workoutDayId);

  @override
  List<Object?> get props => [workoutPlanId, workoutDayId];
}

/// State when workout days for a plan have been loaded
class WorkoutDaysLoaded extends WorkoutPlanState {
  final List<WorkoutDayModel> workoutDays;

  const WorkoutDaysLoaded(this.workoutDays);

  @override
  List<Object?> get props => [workoutDays];
}

/// State when exercises for a workout day have been loaded
class ExercisesLoaded extends WorkoutPlanState {
  final List<ExerciseModel> exercises;

  const ExercisesLoaded(this.exercises);

  @override
  List<Object?> get props => [exercises];
}
