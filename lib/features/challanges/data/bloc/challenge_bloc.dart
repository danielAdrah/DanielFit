import 'package:flutter_bloc/flutter_bloc.dart';
import 'challenge_event.dart';
import 'challenge_state.dart';
import '../repositories/challenge_repository.dart';

/// BLoC for managing Challenge-related state
/// Handles all challenge CRUD operations through the repository pattern
class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  final ChallengeRepository _repository;

  ChallengeBloc({ChallengeRepository? repository})
    : _repository = repository ?? ChallengeRepositoryImpl(),
      super(const ChallengeInitial()) {
    on<LoadAllChallengesEvent>(_onLoadAllChallenges);
    on<LoadChallengeByIdEvent>(_onLoadChallengeById);
    on<AddChallengeEvent>(_onAddChallenge);
    on<UpdateChallengeEvent>(_onUpdateChallenge);
    on<DeleteChallengeEvent>(_onDeleteChallenge);
    on<ToggleChallengeCompletionEvent>(_onToggleChallengeCompletion);
    on<UpdateChallengeProgressEvent>(_onUpdateChallengeProgress);
    on<GetActiveChallengesEvent>(_onGetActiveChallenges);
    on<GetCompletedChallengesEvent>(_onGetCompletedChallenges);
    on<GetChallengesByTypeEvent>(_onGetChallengesByType);
  }

  /// Handle Load All Challenges Event
  Future<void> _onLoadAllChallenges(
    LoadAllChallengesEvent event,
    Emitter<ChallengeState> emit,
  ) async {
    try {
      emit(const ChallengeLoading());
      final challenges = await _repository.getAllChallenges();
      emit(ChallengeLoaded(challenges));
    } catch (e) {
      emit(ChallengeError(e.toString()));
    }
  }

  /// Handle Load Challenge By ID Event
  Future<void> _onLoadChallengeById(
    LoadChallengeByIdEvent event,
    Emitter<ChallengeState> emit,
  ) async {
    try {
      emit(const ChallengeLoading());
      final challenge = await _repository.getChallengeById(event.challengeId);

      if (challenge != null) {
        emit(SingleChallengeLoaded(challenge));
      } else {
        emit(const ChallengeError('Challenge not found'));
      }
    } catch (e) {
      emit(ChallengeError(e.toString()));
    }
  }

  /// Handle Add Challenge Event
  Future<void> _onAddChallenge(
    AddChallengeEvent event,
    Emitter<ChallengeState> emit,
  ) async {
    try {
      emit(const ChallengeLoading());
      await _repository.addChallenge(event.challenge);

      emit(ChallengeAdded(event.challenge));

      // Reload all challenges to update the list
      final challenges = await _repository.getAllChallenges();
      emit(ChallengeLoaded(challenges));
    } catch (e) {
      emit(ChallengeError(e.toString()));
    }
  }

  /// Handle Update Challenge Event
  Future<void> _onUpdateChallenge(
    UpdateChallengeEvent event,
    Emitter<ChallengeState> emit,
  ) async {
    try {
      emit(const ChallengeLoading());
      await _repository.updateChallenge(event.challenge);
      emit(ChallengeUpdated(event.challenge));

      // Reload all challenges to update the list
      final challenges = await _repository.getAllChallenges();
      emit(ChallengeLoaded(challenges));
    } catch (e) {
      emit(ChallengeError(e.toString()));
    }
  }

  /// Handle Delete Challenge Event
  Future<void> _onDeleteChallenge(
    DeleteChallengeEvent event,
    Emitter<ChallengeState> emit,
  ) async {
    try {
      emit(const ChallengeLoading());
      await _repository.deleteChallenge(event.challengeId);
      emit(ChallengeDeleted(event.challengeId));

      // Reload all challenges to update the list
      final challenges = await _repository.getAllChallenges();
      emit(ChallengeLoaded(challenges));
    } catch (e) {
      emit(ChallengeError(e.toString()));
    }
  }

  /// Handle Toggle Challenge Completion Event
  Future<void> _onToggleChallengeCompletion(
    ToggleChallengeCompletionEvent event,
    Emitter<ChallengeState> emit,
  ) async {
    try {
      emit(const ChallengeLoading());
      await _repository.toggleCompletion(event.challengeId, event.isCompleted);

      final challenge = await _repository.getChallengeById(event.challengeId);
      if (challenge != null) {
        emit(ChallengeCompletionToggled(challenge));

        // Reload all challenges to update the list
        final challenges = await _repository.getAllChallenges();
        emit(ChallengeLoaded(challenges));
      }
    } catch (e) {
      emit(ChallengeError(e.toString()));
    }
  }

  /// Handle Update Challenge Progress Event
  Future<void> _onUpdateChallengeProgress(
    UpdateChallengeProgressEvent event,
    Emitter<ChallengeState> emit,
  ) async {
    try {
      emit(const ChallengeLoading());
      await _repository.updateProgress(event.challengeId, event.currentValue);

      final challenge = await _repository.getChallengeById(event.challengeId);
      if (challenge != null) {
        emit(ChallengeProgressUpdated(challenge));

        // Check if target was reached and auto-complete
        if (event.currentValue >= challenge.targetValue &&
            !challenge.isCompleted) {
          await _repository.toggleCompletion(event.challengeId, true);
          final updatedChallenge = await _repository.getChallengeById(
            event.challengeId,
          );
          if (updatedChallenge != null) {
            emit(ChallengeCompletionToggled(updatedChallenge));
          }
        }

        // Reload all challenges to update the list
        final challenges = await _repository.getAllChallenges();
        emit(ChallengeLoaded(challenges));
      }
    } catch (e) {
      emit(ChallengeError(e.toString()));
    }
  }

  /// Handle Get Active Challenges Event
  Future<void> _onGetActiveChallenges(
    GetActiveChallengesEvent event,
    Emitter<ChallengeState> emit,
  ) async {
    try {
      emit(const ChallengeLoading());
      final challenges = await _repository.getActiveChallenges();
      emit(ChallengeLoaded(challenges));
    } catch (e) {
      emit(ChallengeError(e.toString()));
    }
  }

  /// Handle Get Completed Challenges Event
  Future<void> _onGetCompletedChallenges(
    GetCompletedChallengesEvent event,
    Emitter<ChallengeState> emit,
  ) async {
    try {
      emit(const ChallengeLoading());
      final challenges = await _repository.getCompletedChallenges();
      emit(ChallengeLoaded(challenges));
    } catch (e) {
      emit(ChallengeError(e.toString()));
    }
  }

  /// Handle Get Challenges By Type Event
  Future<void> _onGetChallengesByType(
    GetChallengesByTypeEvent event,
    Emitter<ChallengeState> emit,
  ) async {
    try {
      emit(const ChallengeLoading());
      final challenges = await _repository.getChallengesByType(
        event.targetType,
      );
      emit(ChallengeLoaded(challenges));
    } catch (e) {
      emit(ChallengeError(e.toString()));
    }
  }
}
