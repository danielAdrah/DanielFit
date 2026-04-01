// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/exercise_model.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/gearless_app_bar.dart';
import '../../../core/widgets/helper.dart';
import '../../../core/widgets/primary_btn.dart';
import '../../../core/models/workout_plan_model.dart';
import '../../../core/models/workout_day_model.dart';
import 'package:hive/hive.dart';
import '../../../core/models/workout_plan.dart' as ui;
import '../data/workout_plan_data.dart';
import '../widgets/exercise_timeline_tile.dart';

class AddWorkoutPlan extends StatefulWidget {
  const AddWorkoutPlan({super.key});

  @override
  State<AddWorkoutPlan> createState() => _AddWorkoutPlanState();
}

class _AddWorkoutPlanState extends State<AddWorkoutPlan> {
  final planNameController = TextEditingController();
  int selectedDaysCount = 3;
  List<ui.WorkoutDay> workoutDays = [];
  final ScrollController _scrollController = ScrollController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    planNameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _generateWorkoutDays() {
    setState(() {
      workoutDays.clear();
      for (int i = 0; i < selectedDaysCount; i++) {
        workoutDays.add(
          ui.WorkoutDay(
            id: DateTime.now().millisecondsSinceEpoch.toString() + i.toString(),
            dayName: 'Day ${i + 1}',
            targetMuscles: [],
            exercises: [],
            isExpanded: true, // All days expanded by default in timeline view
          ),
        );
      }
    });
  }

  void _updateDay(int index, ui.WorkoutDay updatedDay) {
    setState(() {
      workoutDays[index] = updatedDay;
    });
  }

  void _deleteDay(int index) {
    setState(() {
      workoutDays.removeAt(index);
    });
  }

  void _duplicateDay(int index) {
    final originalDay = workoutDays[index];
    final duplicatedDay = originalDay.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      dayName: '${originalDay.dayName} (Copy)',
      isExpanded: false,
    );

    setState(() {
      workoutDays.insert(index + 1, duplicatedDay);
    });
  }

  void _savePlan() async {
    // Validation
    if (planNameController.text.trim().isEmpty) {
      Helper().showSnackBar(
        "Warning",
        "⚠ Please enter plan name",
        Colors.orange,
        Icons.warning_amber,
      );

      return;
    }

    if (workoutDays.isEmpty) {
      Helper().showSnackBar(
        "Warning",
        "Please create at least one workout day",
        Colors.orange,
        Icons.warning_amber,
      );

      return;
    }

    // Prevent multiple submissions
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    // Create and save workout days to Hive first
    List<String> savedDayIds = [];
    for (int i = 0; i < workoutDays.length; i++) {
      final day = workoutDays[i];

      // First, save all exercises for this day to Hive
      List<String> savedExerciseIds = [];
      for (final exercise in day.exercises) {
        // Create ExerciseModel from UI Exercise
        final exerciseModel = ExerciseModel(
          id: exercise.id,
          name: exercise.name,
          notes: exercise.notes,
          targetMuscle: exercise.targetMuscle,
          imagePath: exercise.imagePath,
          isPlanExercise: true, // Mark as plan-specific exercise
        );

        // Save exercise to Hive 'exercises' box
        await Hive.box<ExerciseModel>(
          'exercises',
        ).put(exerciseModel.id, exerciseModel);
        savedExerciseIds.add(exerciseModel.id);
      }

      // Create WorkoutDayModel with the data from UI WorkoutDay
      final dayModel = WorkoutDayModel(
        id: day.id,
        dayName: day.dayName,
        targetMuscles: day.targetMuscles,
        exerciseIds: savedExerciseIds, // Now populated with saved exercise IDs
        isCompleted: false,
        isExpanded: day.isExpanded,
        order: i,
      );

      // Save to Hive
      await Hive.box<WorkoutDayModel>(
        'workout_days',
      ).put(dayModel.id, dayModel);
      savedDayIds.add(dayModel.id);
    }

    // Create the workout plan model
    final newPlan = WorkoutPlanModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      planName: planNameController.text.trim(),
      daysPerWeek: selectedDaysCount,
      workoutDayIds: savedDayIds,
      muscleCombinations: workoutDays
          .expand((day) => day.targetMuscles)
          .cast<String>()
          .toSet()
          .toList(),
    );

    // Dispatch event to BLoC
    context.read<WorkoutPlanBloc>().add(AddWorkoutPlanEvent(newPlan));
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return BlocListener<WorkoutPlanBloc, WorkoutPlanState>(
      listener: (context, state) {
        if (state is WorkoutPlanLoading) {
          setState(() {
            _isSubmitting = true;
          });
          // Show loading indicator
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              );
            },
          );
        } else if (state is WorkoutPlanAdded) {
          setState(() {
            _isSubmitting = false;
          });
          // Close loading dialog if open
          Navigator.of(context, rootNavigator: true).pop();

          // Show success message
          Helper().showSnackBar(
            "Success",
            'Workout plan "${state.workoutPlan.planName}" saved successfully! 🎉',
            Colors.green,
            Icons.done_all,
          );

          // Navigate back after a short delay
          Future.delayed(Duration(milliseconds: 1500), () {
            if (mounted) {
              Navigator.pop(context);
            }
          });
        } else if (state is WorkoutPlanError) {
          setState(() {
            _isSubmitting = false;
          });
          // Close loading dialog if open
          Navigator.of(context, rootNavigator: true).pop();

          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: AppBackground(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  GearlessAppBar(width: width),
                  SizedBox(height: height * 0.03),

                  // Plan Name Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: FadeInDown(
                      delay: Duration(milliseconds: 300),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/img/dumbell.png',
                                width: 23,
                                height: 23,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Plan Name',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontFamily: "Montserrat",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            width: width,
                            height: 50,
                            controller: planNameController,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.04),

                  // Days Selection Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: FadeInDown(
                      delay: Duration(milliseconds: 400),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/img/list.png',
                                width: 23,
                                height: 23,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Training Days per Week',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontFamily: "Montserrat",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.start,
                            children: List.generate(7, (index) {
                              final days = index + 1;
                              final isSelected = selectedDaysCount == days;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedDaysCount = days;
                                  });
                                  // Regenerate days after a short delay
                                  Future.delayed(
                                    Duration(milliseconds: 200),
                                    () {
                                      _generateWorkoutDays();
                                    },
                                  );
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  width: width * 0.12,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              AppColors.primary.withOpacity(
                                                0.8,
                                              ),
                                              AppColors.secondary,
                                            ],
                                          )
                                        : null,
                                    color: isSelected
                                        ? null
                                        : AppColors.surface,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.metalLight.withOpacity(
                                              0.4,
                                            ),
                                      width: isSelected ? 2 : 1.5,
                                    ),
                                    boxShadow: [
                                      if (isSelected)
                                        BoxShadow(
                                          color: AppColors.primary.withOpacity(
                                            0.4,
                                          ),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$days',
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.textSecondary,
                                        fontFamily: "Poppins",
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.05),

                  // Generated Workout Days Timeline
                  if (workoutDays.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: FadeInDown(
                        delay: const Duration(milliseconds: 500),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Icon(
                                Icons.timeline,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Workout Plan Timeline',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontFamily: "Montserrat",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Vertical Timeline with Custom Design
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: workoutDays.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: 20,
                        child: Center(
                          child: Container(
                            width: 3,
                            height: 2,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Timeline indicator
                            Container(
                              width: 60,
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.primary,
                                          AppColors.secondary,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withOpacity(
                                            0.4,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (index < workoutDays.length - 1)
                                    Container(
                                      width: 3,
                                      height: 60,
                                      margin: const EdgeInsets.only(top: 10),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(
                                          0.3,
                                        ),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // Day content
                            Expanded(
                              child: ExerciseTimelineTile(
                                day: workoutDays[index],
                                dayIndex: index,
                                onDayUpdated: (updatedDay) =>
                                    _updateDay(index, updatedDay),
                                onDeleteDay: () => _deleteDay(index),
                                onDuplicateDay: () => _duplicateDay(index),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],

                  SizedBox(height: height * 0.05),

                  // Save Button
                  FadeInUp(
                    delay: Duration(milliseconds: 1000),
                    child: PrimaryBtn(
                      title: _isSubmitting ? "Saving..." : "Save Workout Plan",
                      widthMargin: width * 0.15,
                      onTap: _isSubmitting ? () {} : _savePlan,
                    ),
                  ),

                  SizedBox(height: height * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
