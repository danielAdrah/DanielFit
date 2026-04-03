import 'package:equatable/equatable.dart';

/// Base class for all Profile events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all statistics data
class LoadProfileStatisticsEvent extends ProfileEvent {
  const LoadProfileStatisticsEvent();
}

/// Event to load user profile data
class LoadUserProfileEvent extends ProfileEvent {
  const LoadUserProfileEvent();
}

/// Event to update profile image
class UpdateProfileImageEvent extends ProfileEvent {
  const UpdateProfileImageEvent();
}
