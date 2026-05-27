import '../../../core/models/workout_day_model.dart';
import 'models/workout_schedule_entry.dart';

/// Generates a dynamic workout schedule from a plan definition.
/// The schedule is derived from plan metadata and does not store fixed dates.
class WorkoutPlanScheduler {
  /// Generate schedule entries starting from [scheduleStartDate].
  ///
  /// If [scheduleStartDate] is after [planStartDate], the rotation is aligned
  /// from the original plan start date so workout order remains consistent.
  static List<WorkoutScheduleEntry> generateSchedule({
    required DateTime planStartDate,
    DateTime? scheduleStartDate,
    required List<WorkoutDayModel> workoutDays,
    List<int>? restWeekDays,
    int horizonDays = 30,
  }) {
    if (workoutDays.isEmpty) {
      return [];
    }

    final normalizedPlanStart = DateTime(
      planStartDate.year,
      planStartDate.month,
      planStartDate.day,
    );

    final normalizedScheduleStart = DateTime(
      (scheduleStartDate ?? normalizedPlanStart).year,
      (scheduleStartDate ?? normalizedPlanStart).month,
      (scheduleStartDate ?? normalizedPlanStart).day,
    );

    final restDays = restWeekDays ?? [];
    final sortedWorkoutDays = List<WorkoutDayModel>.from(workoutDays)
      ..sort((a, b) => a.order.compareTo(b.order));

    int workoutIndex = 0;
    var cursor = normalizedPlanStart;

    // Advance the index until the schedule start date is reached
    while (cursor.isBefore(normalizedScheduleStart)) {
      if (!restDays.contains(cursor.weekday)) {
        workoutIndex = (workoutIndex + 1) % sortedWorkoutDays.length;
      }
      cursor = cursor.add(const Duration(days: 1));
    }

    final entries = <WorkoutScheduleEntry>[];
    var currentDate = normalizedScheduleStart;

    for (var i = 0; i < horizonDays; i++) {
      if (restDays.contains(currentDate.weekday)) {
        entries.add(WorkoutScheduleEntry(date: currentDate, isRestDay: true));
      } else {
        final workoutDay = sortedWorkoutDays[workoutIndex];
        entries.add(
          WorkoutScheduleEntry(
            date: currentDate,
            isRestDay: false,
            workoutDay: workoutDay,
          ),
        );
        workoutIndex = (workoutIndex + 1) % sortedWorkoutDays.length;
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return entries;
  }
}
