// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/gearless_app_bar.dart';
import '../../../core/models/workout_day_model.dart';
import '../data/workout_plan_data.dart';
import '../widgets/exercise_detail_card.dart';

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
                sliver: BlocBuilder<WorkoutPlanBloc, WorkoutPlanState>(
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
                                    color: AppColors.textSecondary.withOpacity(
                                      0.6,
                                    ),
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
}
