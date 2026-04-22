// ignore_for_file: deprecated_member_use, unused_local_variable

import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/gearless_app_bar.dart';
import '../../../core/models/exercise_model.dart';
import '../../exercises/data/bloc/exercise_bloc.dart';
import '../../exercises/data/bloc/exercise_event.dart';
import '../../exercises/data/bloc/exercise_state.dart';
import '../data/workout_plan_data.dart';
import '../../../core/widgets/helper.dart';

class SelectExerciseForDay extends StatefulWidget {
  const SelectExerciseForDay({
    super.key,
    required this.workoutDayId,
    this.targetMuscles,
  });
  final String workoutDayId;
  final List<String>? targetMuscles;

  @override
  State<SelectExerciseForDay> createState() => _SelectExerciseForDayState();
}

class _SelectExerciseForDayState extends State<SelectExerciseForDay> {
  final Set<String> _selectedExerciseIds = {};
  List<ExerciseModel> _allExercises = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.targetMuscles != null && widget.targetMuscles!.isNotEmpty) {
        context.read<ExerciseBloc>().add(
          GetExercisesByMuscleList(widget.targetMuscles!),
        );
      } else {
        context.read<ExerciseBloc>().add(const LoadAllExercisesEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return AppBackground(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,

          appBar: AppBar(
            toolbarHeight: height * 0.1,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
              onPressed: () => Get.back(),
            ),
            actions: [
              (_selectedExerciseIds.isNotEmpty)
                  ? InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: _addSelectedExercises,

                      child: Container(
                        height: 60,
                        width: 100,
                        margin: EdgeInsets.only(top: 5, bottom: 5, right: 15),
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.secondary,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Add ${_selectedExerciseIds.length} Exercise${_selectedExerciseIds.length > 1 ? 's' : ''}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        //  ElevatedButton.icon(
                        //   onPressed: _addSelectedExercises,
                        //   icon: Icon(Icons.add_circle, size: 24),
                        // label: Text(
                        //   'Add ${_selectedExerciseIds.length} Exercise${_selectedExerciseIds.length > 1 ? 's' : ''}',
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: AppColors.primary,
                        //     foregroundColor: Colors.white,
                        //     padding: EdgeInsets.symmetric(vertical: 16),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(12),
                        //     ),
                        //   ),
                        // ),
                      ),
                    )
                  : Container(),
            ],
            title: Text(
              'Add Exercises',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontFamily: 'Arvo',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocListener<ExerciseBloc, ExerciseState>(
                  listener: (context, state) {
                    if (state is ExerciseLoaded) {
                      setState(() {
                        _allExercises = state.exercises;
                        _isLoading = false;
                      });
                    } else if (state is FilterdExercisesLoaded) {
                      setState(() {
                        _allExercises = state.exercises;
                        _isLoading = false;
                      });
                    } else if (state is ExerciseError ||
                        state is FilteredExerciseError) {
                      setState(() {
                        _isLoading = false;
                      });
                      final errorMessage = state is ExerciseError
                          ? state.message
                          : state is FilteredExerciseError
                          ? state.message
                          : 'Unknown error';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Error loading exercises: $errorMessage',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        )
                      : _allExercises.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.fitness_center,
                                size: 80,
                                color: AppColors.textSecondary.withOpacity(0.3),
                              ),
                              SizedBox(height: 16),
                              Text(
                                widget.targetMuscles != null &&
                                        widget.targetMuscles!.isNotEmpty
                                    ? 'No exercises found for ${widget.targetMuscles!.join("/")}'
                                    : 'No exercises available',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                widget.targetMuscles != null &&
                                        widget.targetMuscles!.isNotEmpty
                                    ? 'Try adding exercises for these muscle groups'
                                    : 'Create exercises first to add them here',
                                style: TextStyle(
                                  color: AppColors.textSecondary.withOpacity(
                                    0.6,
                                  ),
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          itemCount: _allExercises.length,
                          itemBuilder: (context, index) {
                            final exercise = _allExercises[index];
                            final isSelected = _selectedExerciseIds.contains(
                              exercise.id,
                            );
                            return FadeInLeft(
                              delay: Duration(milliseconds: 100 * index),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedExerciseIds.remove(exercise.id);
                                    } else {
                                      _selectedExerciseIds.add(exercise.id);
                                    }
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.metalLight.withOpacity(
                                              0.6,
                                            ),
                                      width: isSelected ? 2 : 1.5,
                                    ),
                                    color: isSelected
                                        ? AppColors.primary.withOpacity(0.1)
                                        : Colors.black.withOpacity(0.3),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isSelected
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.textSecondary,
                                        size: 28,
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              exercise.name,
                                              style: TextStyle(
                                                color: AppColors.textPrimary,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              exercise.targetMuscle,
                                              style: TextStyle(
                                                color: AppColors.secondary
                                                    .withOpacity(0.7),
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (exercise.imagePath != null &&
                                          exercise.imagePath!.isNotEmpty)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child:
                                              (exercise.imagePath!.startsWith(
                                                    'http',
                                                  ) ||
                                                  exercise.imagePath!
                                                      .startsWith('/'))
                                              ? Image.file(
                                                  File(exercise.imagePath!),
                                                  width: width * 0.2,
                                                  height: height * 0.1,
                                                  // color: Colors.white.withOpacity(0.5),
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Container(
                                                          width: 100,
                                                          height: height,
                                                          color: Colors
                                                              .grey
                                                              .shade800,
                                                          child: Icon(
                                                            Icons
                                                                .fitness_center,
                                                            color:
                                                                Colors.white54,
                                                            size: 40,
                                                          ),
                                                        );
                                                      },
                                                )
                                              : Image.asset(
                                                  exercise.imagePath!,
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Container(
                                                          width: 60,
                                                          height: 60,
                                                          color: Colors
                                                              .grey
                                                              .shade800,
                                                          child: Icon(
                                                            Icons
                                                                .fitness_center,
                                                            color:
                                                                Colors.white54,
                                                            size: 30,
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

  void _addSelectedExercises() {
    final bloc = context.read<WorkoutPlanBloc>();

    // Add each selected exercise
    for (final exerciseId in _selectedExerciseIds) {
      bloc.add(AddExerciseToDayEvent(widget.workoutDayId, exerciseId));
    }

    // Navigate back
    Get.back();
    Get.back();
    Get.back();
  }
}
