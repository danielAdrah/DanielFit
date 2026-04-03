import 'package:equatable/equatable.dart';

/// Base class for all Profile states
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no actions performed yet
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// Loading state - data is being fetched
class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// Success state - statistics loaded successfully
class ProfileStatisticsLoaded extends ProfileState {
  final int totalExercises;
  final int totalFavorites;
  final int totalPlans;
  final int totalChallenges;
  final Map<String, int> muscleGroupDistribution;

  const ProfileStatisticsLoaded({
    required this.totalExercises,
    required this.totalFavorites,
    required this.totalPlans,
    required this.totalChallenges,
    this.muscleGroupDistribution = const {},
  });

  @override
  List<Object?> get props => [
    totalExercises,
    totalFavorites,
    totalPlans,
    totalChallenges,
    muscleGroupDistribution,
  ];
}

/// State for profile image operations
class ProfileImageUpdated extends ProfileState {
  final String? imagePath;

  const ProfileImageUpdated(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

/// State indicating image is being processed
class ProfileImageLoading extends ProfileState {
  const ProfileImageLoading();
}

/// Error state - operation failed
class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
