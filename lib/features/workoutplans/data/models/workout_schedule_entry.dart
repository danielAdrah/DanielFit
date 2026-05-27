import '../../../../core/models/workout_day_model.dart';

/// Represents one scheduled day in a workout plan.
/// It can be either a workout day or a rest day.
class WorkoutScheduleEntry {
  final DateTime date;
  final bool isRestDay;
  final WorkoutDayModel? workoutDay;

  WorkoutScheduleEntry({
    required this.date,
    required this.isRestDay,
    this.workoutDay,
  }) : assert(
         isRestDay == (workoutDay == null),
         'Rest day entries must not have a workoutDay.',
       );

  String get subject =>
      isRestDay ? 'Rest Day' : workoutDay?.dayName ?? 'Workout';

  String get targetMuscles =>
      workoutDay?.targetMuscles.join(', ') ?? 'Recovery and mobility';

  bool get hasWorkout => !isRestDay && workoutDay != null;
}
