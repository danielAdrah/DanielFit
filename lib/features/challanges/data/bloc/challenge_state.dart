import 'package:equatable/equatable.dart';
import '../../../../core/models/challenge_model.dart';

/// Base state for Challenge BLoC
abstract class ChallengeState extends Equatable {
  const ChallengeState();

  @override
  List<Object?> get props => [];
}

/// Initial state when no events have been triggered
class ChallengeInitial extends ChallengeState {
  const ChallengeInitial();
}

/// State when challenges are being loaded
class ChallengeLoading extends ChallengeState {
  const ChallengeLoading();
}

/// State when all challenges have been loaded successfully
class ChallengeLoaded extends ChallengeState {
  final List<ChallengeModel> challenges;

  const ChallengeLoaded(this.challenges);

  @override
  List<Object?> get props => [challenges];
}

/// State when a single challenge has been loaded
class SingleChallengeLoaded extends ChallengeState {
  final ChallengeModel challenge;

  const SingleChallengeLoaded(this.challenge);

  @override
  List<Object?> get props => [challenge];
}

/// State when there's an error loading challenges
class ChallengeError extends ChallengeState {
  final String message;

  const ChallengeError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when a challenge has been successfully added
class ChallengeAdded extends ChallengeState {
  final ChallengeModel challenge;

  const ChallengeAdded(this.challenge);

  @override
  List<Object?> get props => [challenge];
}

/// State when a challenge has been successfully updated
class ChallengeUpdated extends ChallengeState {
  final ChallengeModel challenge;

  const ChallengeUpdated(this.challenge);

  @override
  List<Object?> get props => [challenge];
}

/// State when a challenge has been deleted
class ChallengeDeleted extends ChallengeState {
  final String challengeId;

  const ChallengeDeleted(this.challengeId);

  @override
  List<Object?> get props => [challengeId];
}

/// State when challenge completion status has been toggled
class ChallengeCompletionToggled extends ChallengeState {
  final ChallengeModel challenge;

  const ChallengeCompletionToggled(this.challenge);

  @override
  List<Object?> get props => [challenge];
}

/// State when challenge progress has been updated
class ChallengeProgressUpdated extends ChallengeState {
  final ChallengeModel challenge;

  const ChallengeProgressUpdated(this.challenge);

  @override
  List<Object?> get props => [challenge];
}
