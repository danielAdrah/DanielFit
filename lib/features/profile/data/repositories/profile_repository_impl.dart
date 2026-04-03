import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/models/hive_registry.dart';

/// Repository for handling user profile operations including image management
abstract class ProfileRepository {
  /// Get current user profile
  Future<UserProfileModel?> getUserProfile();

  /// Update user profile
  Future<void> updateUserProfile(UserProfileModel profile);

  /// Pick image from gallery
  Future<File?> pickImageFromGallery();

  /// Save image to local storage and return path
  Future<String?> saveImageToStorage(File imageFile, String fileName);

  /// Delete profile image
  Future<void> deleteProfileImage(String imagePath);
}

/// Hive implementation of ProfileRepository
class ProfileRepositoryImpl implements ProfileRepository {
  late final Box<UserProfileModel> _profileBox;
  final ImagePicker _imagePicker = ImagePicker();

  ProfileRepositoryImpl() {
    _profileBox = Hive.box<UserProfileModel>(HiveBoxes.userProfile);
  }

  @override
  Future<UserProfileModel?> getUserProfile() async {
    try {
      return _profileBox.get('user_profile');
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUserProfile(UserProfileModel profile) async {
    try {
      await _profileBox.put('user_profile', profile);
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }

  @override
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;

      return File(pickedFile.path);
    } catch (e) {
      throw Exception('Failed to pick image: ${e.toString()}');
    }
  }

  @override
  Future<String?> saveImageToStorage(File imageFile, String fileName) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final profileImagesDir = Directory('${appDir.path}/profile_images');

      // Create directory if it doesn't exist
      if (!await profileImagesDir.exists()) {
        await profileImagesDir.create(recursive: true);
      }

      // Generate unique filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final savedImage = await imageFile.copy(
        '${profileImagesDir.path}/${fileName}_$timestamp.jpg',
      );

      return savedImage.path;
    } catch (e) {
      throw Exception('Failed to save image: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteProfileImage(String imagePath) async {
    try {
      final imageFile = File(imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete image: ${e.toString()}');
    }
  }
}
