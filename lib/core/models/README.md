# Hive Database Models - DanielFit

## 📦 Created Models

This directory contains all the Hive database models for the DanielFit fitness application. Each model is annotated with `@HiveType` and `@HiveField` for code generation.

### Model List

1. **ExerciseModel** (`typeId: 0`)

   - Stores individual exercise information
   - Fields: id, name, imagePath, notes, targetMuscle, createdAt, isFavorite, isHated

2. **WorkoutDayModel** (`typeId: 1`)

   - Represents a single training day within a workout plan
   - Fields: id, dayName, targetMuscles, exerciseIds, isCompleted, isExpanded, order

3. **WorkoutPlanModel** (`typeId: 2`)

   - Complete workout plan structure
   - Fields: id, planName, daysPerWeek, workoutDayIds, createdAt, description, muscleCombinations

4. **ChallengeModel** (`typeId: 3`)

   - User challenges with progress tracking
   - Fields: id, challengeName, description, targetType, targetValue, currentValue, isCompleted, createdAt, completedAt, unit

5. **UserProfileModel** (`typeId: 4`)

   - User personal information and statistics
   - Fields: id, username, profileImagePath, trainingStartDate, totalExercises, totalFavorites, totalPlans, totalChallenges, favoriteExerciseId, defaultWeightUnit, theme

6. **ExerciseLogModel** (`typeId: 7`)

   - Tracks completed workout sessions
   - Contains nested models:
     - **SetModel** (`typeId: 5`): Individual set data (reps, weight, completed)
     - **ExerciseLogEntry** (`typeId: 6`): Exercise entry with multiple sets
   - Main fields: id, workoutDayId, workoutPlanId, completedAt, duration, exercises, notes, rating

7. **MuscleGroupModel** (`typeId: 8`)

   - Categorizes exercises by muscle groups
   - Fields: id, name, muscleGroup, exerciseIds, frontImageMap, backImageMap, displayOrder

8. **BodyPartModel** (`typeId: 10`)
   - Maps interactive body map regions to muscle groups
   - Contains nested model:
     - **BodyPartCoordinates** (`typeId: 9`): Touch area coordinates
   - Main fields: id, bodyPartName, muscleCategory, view, coordinates

## 🔧 Setup Instructions

### 1. Install Dependencies

Run the following command to install required packages:

```bash
flutter pub get
```

### 2. Generate Adapter Files

The models use Hive's code generation. Run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This will generate `.g.dart` files for each model containing the adapters.

### 3. Initialize Hive in main.dart

Update your `main.dart` to initialize Hive:

```dart
import 'package:hive_flutter/hive_flutter.dart';
import 'core/models/hive_registry.dart';

void main() async {
  await Hive.initFlutter();

  // Register all adapters
  await initializeHiveAdapters();

  // Open boxes as needed
  // await Hive.openBox(HiveBoxes.exercises);
  // await Hive.openBox(HiveBoxes.workoutPlans);
  // etc.

  runApp(const MyApp());
}
```

## 📂 File Structure

```
lib/core/models/
├── exercise_model.dart
├── workout_day_model.dart
├── workout_plan_model.dart
├── challenge_model.dart
├── user_profile_model.dart
├── exercise_log_model.dart
├── muscle_group_model.dart
├── body_part_model.dart
├── hive_registry.dart
└── [generated .g.dart files will appear here after build_runner]
```

## 🗃️ Box Names

Use the `HiveBoxes` class for consistent box names:

```dart
import 'core/models/hive_registry.dart';

// Example: Opening boxes
final exercisesBox = await Hive.openBox(HiveBoxes.exercises);
final workoutPlansBox = await Hive.openBox(HiveBoxes.workoutPlans);
final challengesBox = await Hive.openBox(HiveBoxes.challenges);
final userProfileBox = await Hive.openBox(HiveBoxes.userProfile);
```

## 🎯 Usage Examples

### Creating an Exercise

```dart
final exercise = ExerciseModel(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
  name: 'Bench Press',
  notes: 'Keep feet flat on the ground',
  targetMuscle: 'Chest',
);

final box = await Hive.openBox(HiveBoxes.exercises);
await box.put(exercise.id, exercise);
```

### Updating a Challenge

```dart
final challenge = box.get(challengeId);
final updatedChallenge = challenge.copyWith(
  currentValue: challenge.currentValue + 1,
  isCompleted: challenge.currentValue + 1 >= challenge.targetValue,
);

await updatedChallenge.save();
```

### Querying Exercises by Muscle

```dart
final exercisesBox = Hive.box(HiveBoxes.exercises);
final chestExercises = exercisesBox.values.where(
  (exercise) => exercise.targetMuscle == 'Chest'
).toList();
```

## ⚠️ Important Notes

1. **Type IDs**: Each `@HiveType` must have a unique `typeId`. Never change these once generated.
2. **Field IDs**: `@HiveField` IDs should be sequential and not changed after data is stored.
3. **Schema Changes**: If you need to add/remove fields:
   - Add new fields with new IDs
   - Never reuse old field IDs
   - Update the `toJson` and `fromJson` methods
4. **Generated Files**: Never manually edit the `.g.dart` files - they are auto-generated.

## 🔄 Next Steps

After running `build_runner`, the following will be generated:

- `exercise_model.g.dart`
- `workout_day_model.g.dart`
- `workout_plan_model.g.dart`
- `challenge_model.g.dart`
- `user_profile_model.g.dart`
- `exercise_log_model.g.dart`
- `muscle_group_model.g.dart`
- `body_part_model.g.dart`

These files contain the adapter classes needed for Hive serialization.

## 📝 Model Relationships

```
UserProfile (1) ───────────────┬──────────────────────────────┐
                               │                              │
                               ▼                              ▼
                        ExerciseLog (M)                  Challenge (M)
                               │                              │
                               │                              │
                               ▼
                    WorkoutPlan (1) ──────► WorkoutDay (M)
                               │                   │
                               │                   │
                               ▼                   ▼
                          Exercise (M) ◄───────────┘
                               │
                               │
                               ▼
                         MuscleGroup (1)
```

## 🚀 Database Operations Helper

Consider creating a database helper class for common operations:

```dart
class DatabaseHelper {
  static Future<void> init() async {
    await initializeHiveAdapters();
    await Hive.openBox(HiveBoxes.exercises);
    await Hive.openBox(HiveBoxes.workoutPlans);
    await Hive.openBox(HiveBoxes.challenges);
    await Hive.openBox(HiveBoxes.userProfile);
    // ... open other boxes
  }

  // CRUD operations
  static Future<void> saveExercise(ExerciseModel exercise) async {
    final box = Hive.box(HiveBoxes.exercises);
    await box.put(exercise.id, exercise);
  }

  static ExerciseModel? getExercise(String id) {
    final box = Hive.box(HiveBoxes.exercises);
    return box.get(id);
  }

  // ... more methods
}
```

---

**Created:** 2026-03-28  
**Last Updated:** 2026-03-28
