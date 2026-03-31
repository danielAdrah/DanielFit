// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/gearless_app_bar.dart';
import '../../core/widgets/primary_btn.dart';
import '../../core/models/workout_plan.dart';
import 'widgets/exercise_timeline_tile.dart';

class AddWorkoutPlan extends StatefulWidget {
  const AddWorkoutPlan({super.key});

  @override
  State<AddWorkoutPlan> createState() => _AddWorkoutPlanState();
}

class _AddWorkoutPlanState extends State<AddWorkoutPlan> {
  final planNameController = TextEditingController();
  int selectedDaysCount = 3;
  List<WorkoutDay> workoutDays = [];
  final ScrollController _scrollController = ScrollController();

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
          WorkoutDay(
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

  void _updateDay(int index, WorkoutDay updatedDay) {
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

  void _savePlan() {
    if (planNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a plan name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (workoutDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please create at least one workout day'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create the workout plan
    final newPlan = WorkoutPlan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      planName: planNameController.text.trim(),
      daysPerWeek: selectedDaysCount,
      days: workoutDays,
    );

    // TODO: Save to database or state management
    print('Saving plan: ${newPlan.planName}');
    print('Days: ${newPlan.days.length}');
    print('JSON: ${newPlan.toJson()}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Workout plan saved successfully!'),
        backgroundColor: AppColors.primary,
      ),
    );

    // Navigate back or to plan details
    // Navigator.pop(context, newPlan);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return AppBackground(
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
                                Future.delayed(Duration(milliseconds: 200), () {
                                  _generateWorkoutDays();
                                });
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
                                            AppColors.primary.withOpacity(0.8),
                                            AppColors.secondary,
                                          ],
                                        )
                                      : null,
                                  color: isSelected ? null : AppColors.surface,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.metalLight.withOpacity(0.4),
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
                                      color: AppColors.primary.withOpacity(0.3),
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
                    title: "Save Workout Plan",
                    widthMargin: width * 0.15,
                    onTap: _savePlan,
                  ),
                ),

                SizedBox(height: height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
