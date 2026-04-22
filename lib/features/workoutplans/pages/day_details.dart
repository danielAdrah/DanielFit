// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import '../../../core/models/exercise_model.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/gearless_app_bar.dart';
import '../../../core/models/workout_day_model.dart';
import '../../../core/widgets/helper.dart';
import '../data/workout_plan_data.dart';
import '../widgets/exercise_detail_card.dart';
import 'select_exercise_for_day.dart';

class DayDetails extends StatefulWidget {
  const DayDetails({super.key, required this.day});
  final WorkoutDayModel day;

  @override
  State<DayDetails> createState() => _DayDetailsState();
}

class _DayDetailsState extends State<DayDetails> {
  @override
  void initState() {
    super.initState();
    // Dispatch event to load exercises
    context.read<WorkoutPlanBloc>().add(
      LoadExercisesForDayEvent(widget.day.exerciseIds),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return AppBackground(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FadeInRight(
            delay: Duration(milliseconds: 700),
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              onPressed: () {
                // Extract muscles from day name (e.g., "Chest/Triceps" -> ["Chest", "Triceps"])
                final targetMuscles = widget.day.dayName
                    .split('/')
                    .map((muscle) => muscle.trim())
                    .where((muscle) => muscle.isNotEmpty)
                    .toList();

                Get.to(
                  () => SelectExerciseForDay(
                    workoutDayId: widget.day.id,
                    targetMuscles: targetMuscles.isNotEmpty
                        ? targetMuscles
                        : null,
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    // width: 100,
                    // height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assets/img/bg3.jpg"),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                          spreadRadius: -3,
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 6,
                          offset: Offset(0, -3),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      // width: 100,
                      // height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                stretch: true,
                expandedHeight: width * 0.25,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: GearlessAppBar(width: width),
                ),
              ),
              SliverToBoxAdapter(child: dayTitleSection()),
              // Use BlocBuilder to handle states
              SliverPadding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 20),
                sliver: BlocListener<WorkoutPlanBloc, WorkoutPlanState>(
                  listener: (context, state) {
                    if (state is ExerciseUpdatedForDay) {
                    } else if (state is WorkoutPlanError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${state.message}'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  child: BlocBuilder<WorkoutPlanBloc, WorkoutPlanState>(
                    builder: (context, state) {
                      // Handle loading state
                      if (state is WorkoutPlanLoading) {
                        return SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          ),
                        );
                      }

                      // Handle error state
                      if (state is WorkoutPlanError) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.red.withOpacity(0.7),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Error loading exercises',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  state.message,
                                  style: TextStyle(
                                    color: AppColors.textSecondary.withOpacity(
                                      0.7,
                                    ),
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Handle loaded state
                      if (state is ExercisesLoaded) {
                        final exercises = state.exercises;

                        if (exercises.isEmpty) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.fitness_center,
                                    size: 80,
                                    color: AppColors.textSecondary.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No exercises added yet',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Add exercises to this training day',
                                    style: TextStyle(
                                      color: AppColors.textSecondary
                                          .withOpacity(0.6),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: exercises.length,
                            (context, index) {
                              final exercise = exercises[index];
                              return FadeInLeft(
                                delay: Duration(milliseconds: 600),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 25),
                                  child: Slidable(
                                    endActionPane: ActionPane(
                                      motion: const BehindMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) async {
                                            return await _showDeleteConfirmation(
                                              context,
                                              exercise,
                                            );
                                          },
                                          icon: Icons.delete_rounded,
                                          backgroundColor: Colors.red.shade400,
                                          foregroundColor: Colors.white,
                                          label: "Delete",
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          padding: const EdgeInsets.all(6),
                                        ),
                                      ],
                                    ),
                                    child: ExerciseDetaisCard(
                                      order: "${index + 1}",
                                      targetedMuscle: exercise.targetMuscle,
                                      trainingName: exercise.name,
                                      imgUrl:
                                          exercise.imagePath ??
                                          "assets/img/chest1.png",
                                      width: width,
                                    ),
                                  ),
                                ),
                                // Dismissible(
                                //   key: Key(exercise.id),
                                //   direction: DismissDirection.endToStart,
                                //   background: Container(
                                //     margin: EdgeInsets.symmetric(
                                //       horizontal: 15,
                                //       vertical: 0,
                                //     ),
                                //     decoration: BoxDecoration(
                                //       color: Colors.red.withOpacity(0.7),
                                //       borderRadius: BorderRadius.circular(15),
                                //       boxShadow: [
                                //         BoxShadow(
                                //           color: Colors.red.withOpacity(0.4),
                                //           blurRadius: 8,
                                //           offset: Offset(0, 4),
                                //         ),
                                //       ],
                                //     ),
                                //     alignment: Alignment.centerRight,
                                //     padding: EdgeInsets.only(right: 30),
                                //     child: Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.end,
                                //       children: [
                                //         Icon(
                                //           Icons.delete_outline,
                                //           color: Colors.white,
                                //           size: 30,
                                //         ),
                                //         SizedBox(width: 10),
                                //         Text(
                                //           'Delete Exercise',
                                //           style: TextStyle(
                                //             color: Colors.white,
                                //             fontSize: 16,
                                //             fontWeight: FontWeight.w600,
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                //   confirmDismiss: (direction) async {
                                //     return await showDialog(
                                //       context: context,
                                //       builder: (BuildContext context) {
                                //         return AlertDialog(
                                //           backgroundColor: AppColors.surface,
                                //           title: Text(
                                //             'Delete Exercise',
                                //             style: TextStyle(
                                //               color: AppColors.textPrimary,
                                //               fontFamily: 'Arvo',
                                //             ),
                                //           ),
                                //           content: Text(
                                //             'Are you sure you want to remove "${exercise.name}" from this day?',
                                //             style: TextStyle(
                                //               color: AppColors.textSecondary,
                                //             ),
                                //           ),
                                //           actions: [
                                //             TextButton(
                                //               onPressed: () => Navigator.of(
                                //                 context,
                                //               ).pop(false),
                                //               child: Text(
                                //                 'Cancel',
                                //                 style: TextStyle(
                                //                   color:
                                //                       AppColors.textSecondary,
                                //                 ),
                                //               ),
                                //             ),
                                //             TextButton(
                                //               onPressed: () => Navigator.of(
                                //                 context,
                                //               ).pop(true),
                                //               child: Text(
                                //                 'Delete',
                                //                 style: TextStyle(
                                //                   color: Colors.red,
                                //                   fontWeight: FontWeight.bold,
                                //                 ),
                                //               ),
                                //             ),
                                //           ],
                                //         );
                                //       },
                                //     );
                                //   },
                                //   onDismissed: (direction) {
                                // context.read<WorkoutPlanBloc>().add(
                                //   RemoveExerciseFromDayEvent(
                                //     widget.day.id,
                                //     exercise.id,
                                //   ),
                                // );

                                //     ScaffoldMessenger.of(
                                //       context,
                                //     ).showSnackBar(
                                //       SnackBar(
                                //         content: Text(
                                //           '"${exercise.name}" removed',
                                //         ),
                                //         backgroundColor: Colors.red,
                                //         duration: Duration(seconds: 2),
                                //       ),
                                //     );
                                //     context.read<WorkoutPlanBloc>().add(
                                //       LoadExercisesForDayEvent(
                                //         widget.day.exerciseIds,
                                //       ),
                                //     );
                                //     Get.back();
                                //   },
                                //   child:
                                //   ExerciseDetaisCard(
                                //     order: "${index + 1}",
                                //     targetedMuscle: exercise.targetMuscle,
                                //     trainingName: exercise.name,
                                //     imgUrl:
                                //         exercise.imagePath ??
                                //         "assets/img/chest1.png",
                                //     width: width,
                                //   ),
                                // ),

                                //   ),
                                // );
                              );
                            },
                          ),
                        );
                      }

                      // Default/initial state
                      return SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FadeInDown dayTitleSection() {
    return FadeInDown(
      delay: Duration(milliseconds: 500),
      child: Center(
        child: Text(
          widget.day.dayName,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: "Arvo",
            fontSize: 22,
            shadows: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 15,
                offset: Offset(0, 8),
                spreadRadius: -3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    ExerciseModel exe,
    // String exerciseName,
    // String exerciseId,
  ) async {
    await showDialog<bool>(
      context: context,

      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            const SizedBox(width: 8),
            const Text(
              'Delete Exercise?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "Montserrat",
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete "${exe.name}"?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: "Montserrat",
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 20, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This action cannot be undone.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white, fontFamily: "Arvo"),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<WorkoutPlanBloc>().add(
                RemoveExerciseFromDayEvent(widget.day.id, exe.id),
              );

              Helper().showSnackBar(
                "Success",
                "${exe.name} deleted",
                Colors.green,
                Icons.done_all,
              );

              Navigator.pop(context, true);
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_forever, size: 18),
                SizedBox(width: 4),
                Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,

                    // fontWeight: FontWeight.bold,
                    fontFamily: "Arvo",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // return confirmed ?? false;
  }
}
