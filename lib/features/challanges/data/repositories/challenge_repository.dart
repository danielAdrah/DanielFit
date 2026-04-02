import 'package:hive/hive.dart';
import '../../../../core/models/challenge_model.dart' show ChallengeModel;
import '../../../../core/models/hive_registry.dart' show HiveBoxes;

/// Repository interface for Challenge data operations
/// Defines the contract that all challenge repositories must implement
abstract class ChallengeRepository {
  /// Get all challenges from the database
  Future<List<ChallengeModel>> getAllChallenges();

  /// Get a single challenge by ID
  Future<ChallengeModel?> getChallengeById(String id);

  /// Add a new challenge to the database
  Future<void> addChallenge(ChallengeModel challenge);

  /// Update an existing challenge
  Future<void> updateChallenge(ChallengeModel challenge);

  /// Delete a challenge by ID
  Future<void> deleteChallenge(String id);

  /// Toggle completion status
  Future<void> toggleCompletion(String id, bool isCompleted);

  /// Update challenge progress (current value)
  Future<void> updateProgress(String id, double currentValue);

  /// Get active challenges (not completed)
  Future<List<ChallengeModel>> getActiveChallenges();

  /// Get completed challenges
  Future<List<ChallengeModel>> getCompletedChallenges();

  /// Get challenges by target type
  Future<List<ChallengeModel>> getChallengesByType(String targetType);
}

/// Hive implementation of the ChallengeRepository
class ChallengeRepositoryImpl implements ChallengeRepository {
  final Box<ChallengeModel> _challengesBox;

  ChallengeRepositoryImpl()
    : _challengesBox = Hive.box<ChallengeModel>(HiveBoxes.challenges);

  @override
  Future<List<ChallengeModel>> getAllChallenges() async {
    try {
      return _challengesBox.values.toList();
    } catch (e) {
      throw Exception('Failed to load challenges: ${e.toString()}');
    }
  }

  @override
  Future<ChallengeModel?> getChallengeById(String id) async {
    try {
      return _challengesBox.get(id);
    } catch (e) {
      throw Exception('Failed to load challenge: ${e.toString()}');
    }
  }

  @override
  Future<void> addChallenge(ChallengeModel challenge) async {
    try {
      await _challengesBox.put(challenge.id, challenge);
    } catch (e) {
      throw Exception('Failed to add challenge: ${e.toString()}');
    }
  }

  @override
  Future<void> updateChallenge(ChallengeModel challenge) async {
    try {
      await _challengesBox.put(challenge.id, challenge);
    } catch (e) {
      throw Exception('Failed to update challenge: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteChallenge(String id) async {
    try {
      await _challengesBox.delete(id);
    } catch (e) {
      throw Exception('Failed to delete challenge: ${e.toString()}');
    }
  }

  @override
  Future<void> toggleCompletion(String id, bool isCompleted) async {
    try {
      final challenge = _challengesBox.get(id);
      if (challenge != null) {
        final updated = challenge.copyWith(
          isCompleted: isCompleted,
          completedAt: isCompleted ? DateTime.now() : null,
        );
        await _challengesBox.put(id, updated);
      } else {
        throw Exception('Challenge not found: $id');
      }
    } catch (e) {
      throw Exception('Failed to toggle completion: ${e.toString()}');
    }
  }

  @override
  Future<void> updateProgress(String id, double currentValue) async {
    try {
      final challenge = _challengesBox.get(id);
      if (challenge != null) {
        // Check if target reached
        final isCompleted = currentValue >= challenge.targetValue;
        final updated = challenge.copyWith(
          currentValue: currentValue,
          isCompleted: isCompleted,
          completedAt: isCompleted ? DateTime.now() : challenge.completedAt,
        );
        await _challengesBox.put(id, updated);
      } else {
        throw Exception('Challenge not found: $id');
      }
    } catch (e) {
      throw Exception('Failed to update progress: ${e.toString()}');
    }
  }

  @override
  Future<List<ChallengeModel>> getActiveChallenges() async {
    try {
      return _challengesBox.values
          .where((challenge) => !challenge.isCompleted)
          .toList();
    } catch (e) {
      throw Exception('Failed to load active challenges: ${e.toString()}');
    }
  }

  @override
  Future<List<ChallengeModel>> getCompletedChallenges() async {
    try {
      return _challengesBox.values
          .where((challenge) => challenge.isCompleted)
          .toList();
    } catch (e) {
      throw Exception('Failed to load completed challenges: ${e.toString()}');
    }
  }

  @override
  Future<List<ChallengeModel>> getChallengesByType(String targetType) async {
    try {
      return _challengesBox.values
          .where((challenge) => challenge.targetType == targetType)
          .toList();
    } catch (e) {
      throw Exception('Failed to filter challenges by type: ${e.toString()}');
    }
  }
}
