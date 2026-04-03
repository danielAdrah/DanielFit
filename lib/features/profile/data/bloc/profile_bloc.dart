import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../repositories/profile_repository.dart';

/// BLoC for managing Profile-related state
/// Handles fetching statistics from multiple data sources
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;

  ProfileBloc({ProfileRepository? repository})
    : _repository = repository ?? ProfileRepositoryImpl(),
      super(const ProfileInitial()) {
    on<LoadProfileStatisticsEvent>(_onLoadProfileStatistics);
    on<LoadUserProfileEvent>(_onLoadUserProfile);
    on<UpdateProfileImageEvent>(_onUpdateProfileImage);
  }

  /// Handle Load Profile Statistics Event
  Future<void> _onLoadProfileStatistics(
    LoadProfileStatisticsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(const ProfileLoading());

      final statistics = await _repository.getProfileStatistics();
      final muscleGroupDistribution = await _repository
          .getMuscleGroupDistribution();

      emit(
        ProfileStatisticsLoaded(
          totalExercises: statistics['totalExercises'] ?? 0,
          totalFavorites: statistics['totalFavorites'] ?? 0,
          totalPlans: statistics['totalPlans'] ?? 0,
          totalChallenges: statistics['totalChallenges'] ?? 0,
          muscleGroupDistribution: muscleGroupDistribution,
        ),
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  /// Handle Load User Profile Event
  Future<void> _onLoadUserProfile(
    LoadUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final profile = await _repository.getUserProfile();
      if (profile != null) {
        emit(ProfileImageUpdated(profile.profileImagePath));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  /// Handle Update Profile Image Event
  Future<void> _onUpdateProfileImage(
    UpdateProfileImageEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(const ProfileImageLoading());

      // Pick image from gallery
      final pickedImage = await _repository.pickImageFromGallery();

      if (pickedImage == null) {
        // User canceled - return current state
        final profile = await _repository.getUserProfile();
        emit(ProfileImageUpdated(profile?.profileImagePath));
        return;
      }

      // Save image to local storage
      final imagePath = await _repository.saveImageToStorage(
        pickedImage,
        'profile_image',
      );

      if (imagePath != null) {
        // Get current profile
        final profile = await _repository.getUserProfile();

        if (profile != null) {
          // Delete old image if exists
          if (profile.profileImagePath != null) {
            await _repository.deleteProfileImage(profile.profileImagePath!);
          }

          // Update profile with new image path
          final updatedProfile = profile.copyWith(profileImagePath: imagePath);
          await _repository.updateUserProfile(updatedProfile);

          // Emit image updated state
          emit(ProfileImageUpdated(imagePath));

          // Also reload and emit statistics to keep everything in sync
          final statistics = await _repository.getProfileStatistics();
          final muscleGroupDistribution = await _repository
              .getMuscleGroupDistribution();

          emit(
            ProfileStatisticsLoaded(
              totalExercises: statistics['totalExercises'] ?? 0,
              totalFavorites: statistics['totalFavorites'] ?? 0,
              totalPlans: statistics['totalPlans'] ?? 0,
              totalChallenges: statistics['totalChallenges'] ?? 0,
              muscleGroupDistribution: muscleGroupDistribution,
            ),
          );

          return;
        }
      }

      // If we reach here, something went wrong
      final profile = await _repository.getUserProfile();
      emit(ProfileImageUpdated(profile?.profileImagePath));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
