// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:danielfit/core/widgets/gearless_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_background.dart';
import '../data/bloc/exercise_bloc.dart';
import '../data/bloc/exercise_event.dart';
import '../data/bloc/exercise_state.dart';
import 'add_exercise.dart';
import 'muscle_exercise.dart';
import '../widgets/muscle_tile.dart';

class ExercisesView extends StatefulWidget {
  const ExercisesView({super.key});

  @override
  State<ExercisesView> createState() => _ExercisesViewState();
}

class _ExercisesViewState extends State<ExercisesView> {
  List<String> muscleNames = [
    "Chest Exercises",
    "Back Exercises",
    "Bieceps Exercises",
    "Shoulders Exercises",
    "Triceps Exercises",
    "Legs Exercises",
    "Forearms Exercises",
    "Abs Exercises",
  ];
  List<String> muscleImg = [
    "assets/img/chestworkout.png",
    "assets/img/backworkout.png",
    "assets/img/armsworkout.png",
    "assets/img/shoulderworkout.png",
    "assets/img/armsworkout.png",
    "assets/img/legsworkout.png",
    "assets/img/forearmworkout.png",
    "assets/img/chestworkout.png",
  ];
  List<String> targetedMuscles = [
    "Chest",
    "Back",
    "Bieceps",
    "Shoulders",
    "Triceps",
    "Legs",
    "Forearms",
    "Abs",
  ];

  // Map to store exercise counts for each muscle
  Map<String, int> exerciseCounts = {};

  @override
  void initState() {
    super.initState();
    // Load all exercises when the page initializes
    Future.microtask(() {
      context.read<ExerciseBloc>().add(const LoadAllExercisesEvent());
    });
  }

  /// Calculate exercise count for a specific muscle
  int _getExerciseCountForMuscle(String muscle) {
    return exerciseCounts[muscle] ?? 0;
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
                Get.to(() => AddExercise());
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

          body: BlocConsumer<ExerciseBloc, ExerciseState>(
            listener: (context, state) {
              if (state is ExerciseLoaded) {
                // Update exercise counts when exercises are loaded
                exerciseCounts.clear();
                for (var exercise in state.exercises) {
                  final muscle = exercise.targetMuscle;
                  exerciseCounts[muscle] = (exerciseCounts[muscle] ?? 0) + 1;
                }
                // Trigger rebuild to update the UI
                setState(() {});
              }
            },
            builder: (context, state) {
              return CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  //first sliver for the appbar
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
                  //second sliver for the title
                  SliverToBoxAdapter(child: headerTile()),
                  //third is a sliver list for the exercises
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 10,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: muscleNames.length,
                        (context, index) {
                          final muscleName = muscleNames[index];
                          final targetedMuscle = targetedMuscles[index];
                          final exerciseCount = _getExerciseCountForMuscle(
                            targetedMuscle,
                          );

                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              Get.to(
                                () => MuscleExercise(
                                  title: muscleName,
                                  targetedMuscle: targetedMuscle,
                                ),
                              );
                            },
                            child: FadeInLeft(
                              delay: Duration(milliseconds: 750),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: MuscleTile(
                                  isDisplay: false,
                                  muscleName: muscleName,
                                  exeNumber: "Total: $exerciseCount",
                                  imgUrl: muscleImg[index],
                                  width: width,
                                  height: height,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  FadeInLeft headerTile() {
    return FadeInLeft(
      delay: Duration(milliseconds: 600),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10),
        child: Row(
          children: [
            Image.asset("assets/img/dumbell.png", width: 25, height: 25),
            const SizedBox(width: 5),
            Text(
              "Exercises",
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
          ],
        ),
      ),
    );
  }
}
