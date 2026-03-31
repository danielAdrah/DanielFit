import 'package:flutter_bloc/flutter_bloc.dart';
import 'exercise_event.dart';
import 'exercise_state.dart';
import '../repositories/exercise_repository.dart';

/// BLoC for managing Exercise-related state
/// Handles all exercise CRUD operations through the repository pattern
class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final ExerciseRepository _repository;

  ExerciseBloc({ExerciseRepository? repository})
    : _repository = repository ?? ExerciseRepositoryImpl(),
      super(const ExerciseInitial()) {
    on<LoadAllExercisesEvent>(_onLoadAllExercises);
    on<LoadExerciseByIdEvent>(_onLoadExerciseById);
    on<AddExerciseEvent>(_onAddExercise);
    on<UpdateExerciseEvent>(_onUpdateExercise);
    on<DeleteExerciseEvent>(_onDeleteExercise);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<ToggleHatedEvent>(_onToggleHated);
    on<GetExercisesByMuscleEvent>(_onGetExercisesByMuscle);
    on<GetFavoriteExercisesEvent>(_onGetFavoriteExercises);
    on<GetHatedExercisesEvent>(_onGetHatedExercises);
  }

  /// Handle Load All Exercises Event
  Future<void> _onLoadAllExercises(
    LoadAllExercisesEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(const ExerciseLoading());
      final exercises = await _repository.getAllExercises();
      emit(ExerciseLoaded(exercises));
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }

  /// Handle Load Exercise By ID Event
  Future<void> _onLoadExerciseById(
    LoadExerciseByIdEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(const ExerciseLoading());
      final exercise = await _repository.getExerciseById(event.exerciseId);

      if (exercise != null) {
        emit(ExerciseDetailLoaded(exercise));
      } else {
        emit(const ExerciseError('Exercise not found'));
      }
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }

  /// Handle Add Exercise Event
  Future<void> _onAddExercise(
    AddExerciseEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(const ExerciseLoading());
      await _repository.addExercise(event.exercise);

      emit(ExerciseAdded(event.exercise));

      // Reload all exercises to update the list
      final exercises = await _repository.getAllExercises();

      emit(ExerciseLoaded(exercises));
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }

  /// Handle Update Exercise Event
  Future<void> _onUpdateExercise(
    UpdateExerciseEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(const ExerciseLoading());
      await _repository.updateExercise(event.exercise);
      emit(ExerciseUpdated(event.exercise));

      // Reload all exercises to update the list
      final exercises = await _repository.getAllExercises();
      emit(ExerciseLoaded(exercises));
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }

  /// Handle Delete Exercise Event
  Future<void> _onDeleteExercise(
    DeleteExerciseEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(const ExerciseLoading());
      await _repository.deleteExercise(event.exerciseId);
      emit(ExerciseDeleted(event.exerciseId));

      // Reload all exercises to update the list
      final exercises = await _repository.getAllExercises();
      emit(ExerciseLoaded(exercises));
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }

  /// Handle Toggle Favorite Event
  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(const ExerciseLoading());
      await _repository.toggleFavorite(event.exerciseId, event.isFavorite);

      final exercise = await _repository.getExerciseById(event.exerciseId);
      if (exercise != null) {
        emit(ExerciseFavoriteToggled(exercise));

        // Reload all exercises to update the list
        final exercises = await _repository.getAllExercises();
        emit(ExerciseLoaded(exercises));
      }
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }

  /// Handle Toggle Hated Event
  Future<void> _onToggleHated(
    ToggleHatedEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(const ExerciseLoading());
      await _repository.toggleHated(event.exerciseId, event.isHated);

      final exercise = await _repository.getExerciseById(event.exerciseId);
      if (exercise != null) {
        emit(ExerciseHatedToggled(exercise));

        // Reload all exercises to update the list
        final exercises = await _repository.getAllExercises();
        emit(ExerciseLoaded(exercises));
      }
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }

  /// Handle Get Exercises By Muscle Event
  Future<void> _onGetExercisesByMuscle(
    GetExercisesByMuscleEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(const ExerciseLoading());
      final exercises = await _repository.getExercisesByMuscle(event.muscle);
      emit(ExerciseLoaded(exercises));
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }

  /// Handle Get Favorite Exercises Event
  Future<void> _onGetFavoriteExercises(
    GetFavoriteExercisesEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(const ExerciseLoading());
      final exercises = await _repository.getFavoriteExercises();
      emit(ExerciseLoaded(exercises));
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }

  /// Handle Get Hated Exercises Event
  Future<void> _onGetHatedExercises(
    GetHatedExercisesEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(const ExerciseLoading());
      final exercises = await _repository.getHatedExercises();
      emit(ExerciseLoaded(exercises));
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }
}
