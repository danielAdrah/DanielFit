// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/gearless_app_bar.dart';
import '../../../core/models/workout_plan_model.dart';
import '../data/bloc/workout_plan_bloc.dart';
import '../data/bloc/workout_plan_event.dart';
import '../data/bloc/workout_plan_state.dart';
import 'day_details.dart';
import '../widgets/training_day_tile.dart';

class PlanDetail extends StatefulWidget {
  const PlanDetail({super.key, required this.plan});
  final WorkoutPlanModel plan;
  @override
  State<PlanDetail> createState() => _PlanDetailState();
}

class _PlanDetailState extends State<PlanDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    // Provide a new BLoC instance for this specific plan
    return BlocProvider(
      create: (context) =>
          WorkoutPlanBloc()
            ..add(LoadWorkoutDaysForPlanEvent(widget.plan.workoutDayIds)),
      child: AppBackground(
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
                SliverToBoxAdapter(child: planTitleSection()),

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
                                  'Error loading days',
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
                      if (state is WorkoutDaysLoaded) {
                        final workoutDays = state.workoutDays;

                        if (workoutDays.isEmpty) {
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
                                    'No training days yet',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Add days to this workout plan',
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
                            childCount: workoutDays.length,
                            (context, index) {
                              final day = workoutDays[index];
                              return FadeInLeft(
                                delay: Duration(milliseconds: 600),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    Get.to(() => DayDetails(day: day));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: TrainigDaysTille(
                                      muscles: day.dayName,
                                      //display the number of exercises for each day.
                                      days: day.targetMuscles.length.toString(),
                                      width: width,
                                      height: height,
                                    ),
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
      ),
    );
  }

  FadeInDown planTitleSection() {
    return FadeInDown(
      delay: Duration(milliseconds: 500),
      child: Center(
        child: Text(
          widget.plan.planName,
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
