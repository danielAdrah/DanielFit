import 'package:equatable/equatable.dart';
import '../../../../core/models/challenge_model.dart';

/// Base event for Challenge BLoC
abstract class ChallengeEvent extends Equatable {
  const ChallengeEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all challenges from the database
class LoadAllChallengesEvent extends ChallengeEvent {
  const LoadAllChallengesEvent();
}

/// Event to load a specific challenge by ID
class LoadChallengeByIdEvent extends ChallengeEvent {
  final String challengeId;

  const LoadChallengeByIdEvent(this.challengeId);

  @override
  List<Object?> get props => [challengeId];
}

/// Event to add a new challenge to the database
class AddChallengeEvent extends ChallengeEvent {
  final ChallengeModel challenge;

  const AddChallengeEvent(this.challenge);

  @override
  List<Object?> get props => [challenge];
}

/// Event to update an existing challenge
class UpdateChallengeEvent extends ChallengeEvent {
  final ChallengeModel challenge;

  const UpdateChallengeEvent(this.challenge);

  @override
  List<Object?> get props => [challenge];
}

/// Event to delete a challenge by ID
class DeleteChallengeEvent extends ChallengeEvent {
  final String challengeId;

  const DeleteChallengeEvent(this.challengeId);

  @override
  List<Object?> get props => [challengeId];
}

/// Event to toggle challenge completion status
class ToggleChallengeCompletionEvent extends ChallengeEvent {
  final String challengeId;
  final bool isCompleted;

  const ToggleChallengeCompletionEvent(this.challengeId, this.isCompleted);

  @override
  List<Object?> get props => [challengeId, isCompleted];
}

/// Event to update challenge progress (current value)
class UpdateChallengeProgressEvent extends ChallengeEvent {
  final String challengeId;
  final double currentValue;

  const UpdateChallengeProgressEvent(this.challengeId, this.currentValue);

  @override
  List<Object?> get props => [challengeId, currentValue];
}

/// Event to get active challenges (not completed)
class GetActiveChallengesEvent extends ChallengeEvent {
  const GetActiveChallengesEvent();
}

/// Event to get completed challenges
class GetCompletedChallengesEvent extends ChallengeEvent {
  const GetCompletedChallengesEvent();
}

/// Event to get challenges by type (Reps or Weight)
class GetChallengesByTypeEvent extends ChallengeEvent {
  final String targetType;

  const GetChallengesByTypeEvent(this.targetType);

  @override
  List<Object?> get props => [targetType];
}
