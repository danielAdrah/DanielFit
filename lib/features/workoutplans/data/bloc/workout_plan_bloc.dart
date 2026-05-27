import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../../../core/models/workout_day_model.dart';
import 'workout_plan_event.dart';
import 'workout_plan_state.dart';
import '../repositories/workout_plan_repository.dart';

/// BLoC for managing WorkoutPlan-related state
/// Handles all workout plan CRUD operations through the repository pattern
class WorkoutPlanBloc extends Bloc<WorkoutPlanEvent, WorkoutPlanState> {
  final WorkoutPlanRepository _repository;

  WorkoutPlanBloc({WorkoutPlanRepository? repository})
    : _repository = repository ?? WorkoutPlanRepositoryImpl(),
      super(const WorkoutPlanInitial()) {
    on<LoadAllWorkoutPlansEvent>(_onLoadAllWorkoutPlans);
    on<LoadWorkoutPlanByIdEvent>(_onLoadWorkoutPlanById);
    on<AddWorkoutPlanEvent>(_onAddWorkoutPlan);
    on<UpdateWorkoutPlanEvent>(_onUpdateWorkoutPlan);
    on<DeleteWorkoutPlanEvent>(_onDeleteWorkoutPlan);
    on<ToggleWorkoutPlanFavoriteEvent>(_onToggleWorkoutPlanFavorite);
    on<GetWorkoutPlansByCategoryEvent>(_onGetWorkoutPlansByCategory);
    on<GetFavoriteWorkoutPlansEvent>(_onGetFavoriteWorkoutPlans);
    on<GenerateWorkoutPlanScheduleEvent>(_onGenerateWorkoutPlanSchedule);
    on<UpdateWorkoutPlanScheduleSettingsEvent>(
      _onUpdateWorkoutPlanScheduleSettings,
    );
    on<AddWorkoutDayToPlanEvent>(_onAddWorkoutDayToPlan);
    on<RemoveWorkoutDayFromPlanEvent>(_onRemoveWorkoutDayFromPlan);
    on<LoadWorkoutDaysForPlanEvent>(_onLoadWorkoutDaysForPlan);
    on<LoadExercisesForDayEvent>(_onLoadExercisesForDay);
    on<AddExerciseToDayEvent>(_onAddExerciseToDay);
    on<RemoveExerciseFromDayEvent>(_onRemoveExerciseFromDay);
  }

  /// Handle Load All Workout Plans Event
  Future<void> _onLoadAllWorkoutPlans(
    LoadAllWorkoutPlansEvent event,
    Emitter<WorkoutPlanState> emit,
  ) async {
    try {
      emit(const WorkoutPlanLoading());
      final workoutPlans = await _repository.getAllWorkoutPlans();
      emit(WorkoutPlanLoaded(workoutPlans));
    } catch (e) {
      emit(WorkoutPlanError(e.toString()));
    }
  }

  /// Handle Load Workout Plan By ID Event
  Future<void> _onLoadWorkoutPlanById(
    LoadWorkoutPlanByIdEvent event,
    Emitter<WorkoutPlanState> emit,
  ) async {
    try {
      emit(const WorkoutPlanLoading());
      final workoutPlan = await _repository.getWorkoutPlanById(
        event.workoutPlanId,
      );

      if (workoutPlan != null) {
        emit(SingleWorkoutPlanLoaded(workoutPlan));
      } else {
        emit(const WorkoutPlanError('Workout plan not found'));
      }
    } catch (e) {
      emit(WorkoutPlanError(e.toString()));
    }
  }

  /// Handle Add Workout Plan Event
  Future<void> _onAddWorkoutPlan(
    AddWorkoutPlanEvent event,
    Emitter<WorkoutPlanState> emit,
  ) async {
    try {
      emit(const WorkoutPlanLoading());
      await _repository.addWorkoutPlan(event.workoutPlan);

      emit(WorkoutPlanAdded(event.workoutPlan));

      // Reload all workout plans to update the list
      final workoutPlans = await _repository.getAllWorkoutPlans();
      emit(WorkoutPlanLoaded(workoutPlans));
    } catch (e) {
      emit(WorkoutPlanError(e.toString()));
    }
  }

  /// Handle Update Workout Plan Event
  Future<void> _onUpdateWorkoutPlan(
    UpdateWorkoutPlanEvent event,
    Emitter<WorkoutPlanState> emit,
  ) async {
    try {
      emit(const WorkoutPlanLoading());
      await _repository.updateWorkoutPlan(event.workoutPlan);
      emit(WorkoutPlanUpdated(event.workoutPlan));

      // Reload all workout plans to update the list
      final workoutPlans = await _repository.getAllWorkoutPlans();
      emit(WorkoutPlanLoaded(workoutPlans));
    } catch (e) {
      emit(WorkoutPlanError(e.toString()));
    }
  }

  /// Handle Delete Workout Plan Event
  Future<void> _onDeleteWorkoutPlan(
    DeleteWorkoutPlanEvent event,
    Emitter<WorkoutPlanState> emit,
  ) async {
    try {
      emit(const WorkoutPlanLoading());
      await _repository.deleteWorkoutPlan(event.workoutPlanId);
      emit(WorkoutPlanDeleted(event.workoutPlanId));

      // Reload all workout plans to update the list
      final workoutPlans = await _repository.getAllWorkoutPlans();
      emit(WorkoutPlanLoaded(workoutPlans));
    } catch (e) {
      emit(WorkoutPlanError(e.toString()));
    }
  }

  /// Handle Toggle Workout Plan Favorite Event
  Future<void> _onToggleWorkoutPlanFavorite(
    ToggleWorkoutPlanFavoriteEvent event,
    Emitter<WorkoutPlanState> emit,
  ) async {
    try {
      emit(const WorkoutPlanLoading());
      await _repository.toggleFavorite(event.workoutPlanId, event.isFavorite);

      final workoutPlan = await _repository.getWorkoutPlanById(
        event.workoutPlanId,
      );
      if (workoutPlan != null) {
        emit(WorkoutPlanFavoriteToggled(workoutPlan));

        // Reload all workout plans to update the list
        final workoutPlans = await _repository.getAllWorkoutPlans();
        emit(WorkoutPlanLoaded(workoutPlans));
      }
    } catch (e) {
      emit(WorkoutPlanError(e.toString()));
    }
  }

  /// Handle Get Workout Plans By Category Event
  Future<void> _onGetWorkoutPlansByCategory(
    GetWorkoutPlansByCategoryEvent event,
    Emitter<WorkoutPlanState> emit,
  ) async {
    try {
      emit(const WorkoutPlanLoading());
      final workoutPlans = await _repository.getWorkoutPlansByCategory(
        event.category,
      );
      emit(WorkoutPlansFilteredByCategory(workoutPlans, event.category));
    } catch (e) {
      emit(WorkoutPlanError(e.toString()));
    }
  }

  /// Handle Get Favorite Workout Plans Event
  Future<void> _onGetFavoriteWorkoutPlans(
    GetFavoriteWorkoutPlansEvent event,
    Emitter<WorkoutPlanState> emit,
  ) async {
    try {
      emit(const WorkoutPlanLoading());
      final workoutPlans = await _repository.getFavoriteWorkoutPlans();
      emit(WorkoutPlanLoaded(workoutPlans));
    } catch (e) {
      emit(WorkoutPlanError(e.toString()));
    }
  }

  /// Handle Add Workout Day To Plan Event
  Future<void> _onAddWorkoutDayToPlan(
    AddWorkoutDayToPlanEvent event,
    Emitter<WorkoutPlanState> emit,
  ) async {
    try {
      emit(const WorkoutPlanLoading());
      await _repository.addWorkoutDayToPlan(
        event.workoutPlanId,
        event.workoutDayId,
      );
      emit(WorkoutDayAddedToPlan(event.workoutPlanId, event.workoutDayId));

      // Reload the specific workout plan
      final workoutPlan = await _repository.getWorkoutPlanById(
        event.workoutPlanId,
      );
      if (workoutPlan != null) {
        emit(SingleWorkoutPlanLoaded(workoutPlan));
      }
    } catch (e) {
      emit(WorkoutPlanError(e.toString()));
    }
  }

  /// Handle Remove Workout Day From Plan Event
  Future<void> _onRemoveWorkoutDayFromPlan(
    RemoveWorkoutDayFromPlanEvent event,
    Emitter<WorkoutPlanState> emit,
  ) async {
    try {
      emit(const WorkoutPlanLoading());
      await _repository.removeWorkoutDayFromPlan(
        event.workoutPlanId,
        event.workoutDayId,
      );
      emit(WorkoutDayRemovedFromPlan(event.workoutPlanId, event.workoutDayId));

      // Reload the specific workout plan
      final workoutPlan = await _repository.getWorkoutPlanById(
        event.workoutPlanId,
      );
      if (workoutPlan != null) {
        emit(SingleWorkoutPlanLoaded(workoutPlan));
      }
    } catch (e) {
      emit(WorkoutPlanError(e.toString()));
    }
  }

  /// Handle Load Workout Days For Plan Event
  Future<void> _onLoadWorkoutDaysForPlan(
    LoadWorkoutDaysForPlanEvent event,
    Emitter<WorkoutPlanState> emit,
  ) async {
    try {
      // Don't emit loading state if we already have workout days loaded
      // This prevents flickering when navigating back from DayDetails
      final currentWorkoutDays = await _repository.getWorkoutDaysByPlanIds(
        event.workoutDayIds,
      );
      emit(WorkoutDaysLoaded(currentWorkoutDays));
    } catch (e) {
      emit(WorkoutPlanError(e.toString()));
    }
  }

  /// Handle Load Exercises For Day Event
  Future<void> _onLoadExercisesForDay(
    LoadExercisesForDayEvent event,
    Emitter<WorkoutPlanState> emit,
  ) async {
    try {
      emit(const WorkoutPlanLoading());
      final exercises = await _repository.getExercisesByDayIds(
        event.exerciseIds,
      );
      emit(ExercisesLoaded(exercises));
    } catch (e) {
      emit(WorkoutPlanError(e.toString()));
    }
  }

  /// Handle Generate Workout Plan Schedule Event
  Future<void> _onGenerateWorkoutPlanSchedule(
    GenerateWorkoutPlanScheduleEvent event,
    Emitter<WorkoutPlanState> emit,
  ) async {
    try {
      emit(const WorkoutPlanLoading());
      final schedule = await _repository.getWorkoutPlanSchedule(
        event.workoutPlanId,
        scheduleStartDate: event.scheduleStartDate,
        horizonDays: event.horizonDays,
      );
      emit(WorkoutPlanScheduleLoaded(schedule));
    } catch (e) {
      emit(WorkoutPlanError(e.toString()));
    }
  }

  /// Handle Update Workout Plan Schedule Settings Event
  Future<void> _onUpdateWorkoutPlanScheduleSettings(
    UpdateWorkoutPlanScheduleSettingsEvent event,
    Emitter<WorkoutPlanState> emit,
  ) async {
    try {
      emit(const WorkoutPlanLoading());
      final workoutPlan = await _repository.getWorkoutPlanById(
        event.workoutPlanId,
      );

      if (workoutPlan == null) {
        emit(const WorkoutPlanError('Workout plan not found'));
        return;
      }

      final updatedPlan = workoutPlan.copyWith(
        startDate: event.startDate,
        restDays: event.restDays,
      );

      await _repository.updateWorkoutPlan(updatedPlan);
      emit(WorkoutPlanUpdated(updatedPlan));

      final workoutPlans = await _repository.getAllWorkoutPlans();
      emit(WorkoutPlanLoaded(workoutPlans));
    } catch (e) {
      emit(WorkoutPlanError(e.toString()));
    }
  }

  /// Handle Add Exercise To Day Event
  Future<void> _onAddExerciseToDay(
    AddExerciseToDayEvent event,
    Emitter<WorkoutPlanState> emit,
  ) async {
    try {
      emit(const WorkoutPlanLoading());
      await _repository.addExerciseToDay(event.workoutDayId, event.exerciseId);

      // Reload the workout day to get updated exerciseIds
      final workoutDaysBox = Hive.box<WorkoutDayModel>('workout_days');
      final updatedDay = workoutDaysBox.get(event.workoutDayId);

      if (updatedDay != null) {
        final exercises = await _repository.getExercisesByDayIds(
          updatedDay.exerciseIds,
        );
        emit(ExerciseUpdatedForDay(event.workoutDayId, exercises));
      }
    } catch (e) {
      emit(WorkoutPlanError(e.toString()));
    }
  }

  /// Handle Remove Exercise From Day Event
  Future<void> _onRemoveExerciseFromDay(
    RemoveExerciseFromDayEvent event,
    Emitter<WorkoutPlanState> emit,
  ) async {
    try {
      emit(const WorkoutPlanLoading());
      await _repository.removeExerciseFromDay(
        event.workoutDayId,
        event.exerciseId,
      );

      // Reload the workout day to get updated exerciseIds
      final workoutDaysBox = Hive.box<WorkoutDayModel>('workout_days');
      final updatedDay = workoutDaysBox.get(event.workoutDayId);

      if (updatedDay != null) {
        final exercises = await _repository.getExercisesByDayIds(
          updatedDay.exerciseIds,
        );
        emit(ExerciseUpdatedForDay(event.workoutDayId, exercises));
        final workoutPlans = await _repository.getAllWorkoutPlans();
        emit(WorkoutPlanLoaded(workoutPlans));
      }
    } catch (e) {
      emit(WorkoutPlanError(e.toString()));
    }
  }
}
