// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:danielfit/core/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/gearless_app_bar.dart';
import '../../../core/widgets/helper.dart';
import 'add_exercise.dart';
import '../data/exercise_data.dart';
import '../widgets/muscle_exercise_tile.dart';

class MuscleExercise extends StatefulWidget {
  const MuscleExercise({
    super.key,
    required this.title,
    required this.targetedMuscle,
  });
  final String title;
  final String targetedMuscle;

  @override
  State<MuscleExercise> createState() => _MuscleExerciseState();
}

class _MuscleExerciseState extends State<MuscleExercise> {
  final highestWeight = TextEditingController();
  double currentWeightValue = 0.0;

  void _incrementWeight() {
    setState(() {
      currentWeightValue += 2.5;
      highestWeight.text = currentWeightValue.toStringAsFixed(1);
    });
  }

  void _decrementWeight() {
    setState(() {
      if (currentWeightValue > 0) {
        currentWeightValue -= 2.5;
        highestWeight.text = currentWeightValue.toStringAsFixed(1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (_) =>
          ExerciseBloc()..add(GetExercisesByMuscleEvent(widget.targetedMuscle)),
      child: AppBackground(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,

            body: BlocListener<ExerciseBloc, ExerciseState>(
              listener: (context, state) {
                if (state is ExerciseError) {
                  Helper().showSnackBar(
                    "Error",
                    "❌ Error: ${state.message}",
                    AppColors.secondary,
                    Icons.error_outline,
                  );
                } else if (state is ExerciseHighestWeightUpdated) {
                  Helper().showSnackBar(
                    "Success",
                    "✅ Highest weight updated to ${state.exercise.highestWeight?.toStringAsFixed(1)} kg",
                    Colors.green,
                    Icons.check_circle,
                  );
                }
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
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
                  // title section
                  SliverToBoxAdapter(
                    child: Center(
                      child: ZoomIn(
                        delay: Duration(milliseconds: 600),
                        child: Text(
                          widget.title,
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
                    ),
                  ),
                  // Exercise list with BLoC integration
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 20,
                    ),
                    sliver: BlocBuilder<ExerciseBloc, ExerciseState>(
                      builder: (context, state) {
                        if (state is ExerciseLoading) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Loading exercises...',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        if (state is ExerciseLoaded) {
                          if (state.exercises.isEmpty) {
                            return SliverToBoxAdapter(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: ZoomIn(
                                    child: Column(
                                      children: [
                                        SizedBox(height: height * 0.2),
                                        Icon(
                                          Icons.fitness_center_outlined,
                                          size: 80,
                                          color: AppColors.textSecondary
                                              .withOpacity(0.5),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No exercises found for ${widget.targetedMuscle}',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Add your first move 💪',
                                          style: TextStyle(
                                            color: AppColors.textSecondary
                                                .withOpacity(0.7),
                                            fontSize: 15,
                                            fontFamily: 'Montserrat',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 24),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Get.to(() => AddExercise());
                                          },
                                          icon: const Icon(Icons.add),
                                          label: const Text('Add Exercise'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.secondary,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              childCount: state.exercises.length,
                              (context, index) {
                                final exercise = state.exercises[index];

                                // Generate status based on exercise properties
                                String statusText = 'Great exercise';
                                if (exercise.isFavorite) {
                                  statusText = '❤️ Favorite';
                                } else if (exercise.isHated) {
                                  statusText = '😤 Hated';
                                } else if (exercise.notes.isNotEmpty) {
                                  statusText = exercise.notes.length > 20
                                      ? '${exercise.notes.substring(0, 20)}...'
                                      : exercise.notes;
                                }

                                return FadeInLeft(
                                  delay: Duration(
                                    milliseconds: 700 + (index * 100),
                                  ),
                                  child: Slidable(
                                    endActionPane: ActionPane(
                                      motion: const BehindMotion(),
                                      // extentRatio: 0.25,
                                      children: [
                                        //delete action
                                        SlidableAction(
                                          onPressed: (context) async {
                                            return await _showDeleteConfirmation(
                                              context,
                                              exercise.name,
                                              exercise.id,
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
                                        //favorite action
                                        SlidableAction(
                                          onPressed: (context) {
                                            final newFavoriteStatus =
                                                !exercise.isFavorite;

                                            context.read<ExerciseBloc>().add(
                                              ToggleFavoriteEvent(
                                                exercise.id,
                                                newFavoriteStatus,
                                              ),
                                            );

                                            // If marking as favorite, remove from hated
                                            if (newFavoriteStatus &&
                                                exercise.isHated) {
                                              context.read<ExerciseBloc>().add(
                                                ToggleHatedEvent(
                                                  exercise.id,
                                                  false,
                                                ),
                                              );
                                            }
                                            Helper().showSnackBar(
                                              exercise.name,
                                              newFavoriteStatus
                                                  ? "Added to favorites ❤️"
                                                  : "Removed from favorites",
                                              newFavoriteStatus
                                                  ? Colors.green
                                                  : Colors.grey,
                                              Icons.done_all,
                                            );

                                            Navigator.pop(context);
                                          },
                                          icon: exercise.isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          backgroundColor: exercise.isFavorite
                                              ? Colors.red.shade400
                                              : Colors.green.shade400,
                                          foregroundColor: Colors.white,
                                          label: exercise.isFavorite
                                              ? "Remove Favorite"
                                              : "Favorite",
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          padding: const EdgeInsets.all(6),
                                        ),
                                        //hate action
                                        SlidableAction(
                                          onPressed: (context) {
                                            final newHatedStatus =
                                                !exercise.isHated;

                                            context.read<ExerciseBloc>().add(
                                              ToggleHatedEvent(
                                                exercise.id,
                                                newHatedStatus,
                                              ),
                                            );

                                            // If marking as hated, remove from favorites
                                            if (newHatedStatus &&
                                                exercise.isFavorite) {
                                              context.read<ExerciseBloc>().add(
                                                ToggleFavoriteEvent(
                                                  exercise.id,
                                                  false,
                                                ),
                                              );
                                            }

                                            Helper().showSnackBar(
                                              exercise.name,
                                              newHatedStatus
                                                  ? "Added to Hated 😤"
                                                  : "Removed from Hated",
                                              newHatedStatus
                                                  ? Colors.orange
                                                  : Colors.grey,
                                              Icons.heart_broken,
                                            );

                                            Navigator.pop(context);
                                          },
                                          icon: exercise.isHated
                                              ? Icons
                                                    .sentiment_very_dissatisfied
                                              : Icons.sentiment_dissatisfied,
                                          backgroundColor: exercise.isHated
                                              ? Colors.red.shade400
                                              : Colors.orange.shade400,
                                          foregroundColor: Colors.white,
                                          label: exercise.isHated
                                              ? "Remove Hate"
                                              : "Hate",
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          padding: const EdgeInsets.all(6),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 20,
                                      ),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          // Initialize current weight value
                                          setState(() {
                                            currentWeightValue =
                                                exercise.highestWeight ?? 0.0;
                                            if (currentWeightValue > 0) {
                                              highestWeight.text =
                                                  currentWeightValue
                                                      .toStringAsFixed(1);
                                            } else {
                                              highestWeight.clear();
                                            }
                                          });

                                          showBottomSheet(
                                            height,
                                            width,
                                            exercise.name,
                                            exercise.id,
                                            highestWeight,
                                            exercise.highestWeight,
                                            () {
                                              // Validate and update highest weight
                                              if (highestWeight.text.isEmpty) {
                                                Helper().showSnackBar(
                                                  "Error",
                                                  "Please enter a weight value",
                                                  Colors.red,
                                                  Icons.error_outline,
                                                );
                                                return;
                                              }

                                              final weightValue =
                                                  double.tryParse(
                                                    highestWeight.text,
                                                  );

                                              if (weightValue == null ||
                                                  weightValue <= 0) {
                                                Helper().showSnackBar(
                                                  "Error",
                                                  "Please enter a valid weight value",
                                                  Colors.red,
                                                  Icons.error_outline,
                                                );
                                                return;
                                              }

                                              // Dispatch event to update highest weight
                                              context.read<ExerciseBloc>().add(
                                                UpdateHighestWeightEvent(
                                                  exercise.id,
                                                  weightValue,
                                                ),
                                              );
                                              highestWeight.clear();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                        child: MuscleExerciseTile(
                                          isDisplay: true,
                                          width: width,
                                          height: height,
                                          exeNumber: statusText,
                                          muscleName: exercise.name,
                                          imgUrl:
                                              exercise.imagePath ??
                                              'assets/img/chest1.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }

                        if (state is ExerciseError) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 80,
                                      color: Colors.red.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Failed to load exercises',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        context.read<ExerciseBloc>().add(
                                          GetExercisesByMuscleEvent(
                                            widget.targetedMuscle,
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Retry'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        // Default empty state
                        return SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Text(
                                'No data available',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
                                ),
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
      ),
    );
  }

  /// Show delete confirmation dialog
  Future<void> _showDeleteConfirmation(
    BuildContext context,
    String exerciseName,
    String exerciseId,
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
              'Are you sure you want to delete "$exerciseName"?',
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
              context.read<ExerciseBloc>().add(DeleteExerciseEvent(exerciseId));
              Helper().showSnackBar(
                "Success",
                "$exerciseName deleted",
                Colors.green,
                Icons.done_all,
              );

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

  //=======================
  void showBottomSheet(
    double height,
    double width,
    String exerciseName,
    String exerciseId,
    TextEditingController weightController,
    double? previousWeight,
    void Function() onTap,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 100),
              child: Container(
                height: previousWeight != null ? height * 0.55 : height * 0.45,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  image: DecorationImage(
                    image: AssetImage("assets/img/bg3.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    // Handle bar at top
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 50,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Header with exercise name and icon
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.fitness_center,
                              color: AppColors.secondary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'New Record',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  exerciseName,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontFamily: 'Montserrat',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Weight display card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.secondary.withOpacity(0.2),
                            AppColors.secondary.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.secondary.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Current/Highest weight display
                          if (previousWeight != null && previousWeight > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.trending_up,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Current Record: ',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${previousWeight.toStringAsFixed(1)} kg',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontFamily: 'Montserrat',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (previousWeight != null && previousWeight > 0)
                            const SizedBox(height: 15),

                          // Increment/Decrement buttons and input field
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Decrement button
                              GestureDetector(
                                onTap: _decrementWeight,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.secondary,
                                        AppColors.secondary.withOpacity(0.7),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.secondary.withOpacity(
                                          0.5,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 15),

                              // Weight input display
                              Expanded(
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: AppColors.secondary.withOpacity(
                                        0.5,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                  child: TextField(
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    controller: weightController,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Arvo',
                                    ),
                                    cursorColor: AppColors.secondary,
                                    decoration: InputDecoration(
                                      hintText: '0.0',
                                      hintStyle: TextStyle(
                                        color: AppColors.textSecondary
                                            .withOpacity(0.4),
                                        fontSize: 24,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                    ),
                                    onChanged: (value) {
                                      final parsed = double.tryParse(value);
                                      if (parsed != null) {
                                        setModalState(() {
                                          currentWeightValue = parsed;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(width: 15),

                              // Increment button
                              GestureDetector(
                                onTap: _incrementWeight,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.secondary,
                                        AppColors.secondary.withOpacity(0.7),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.secondary.withOpacity(
                                          0.5,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Unit label
                          Text(
                            'kilograms (kg)',
                            style: TextStyle(
                              color: AppColors.textSecondary.withOpacity(0.7),
                              fontFamily: 'Montserrat',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Confirm button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: InkWell(
                        onTap: () {
                          onTap();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.secondary,
                                AppColors.secondary.withOpacity(0.8),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondary.withOpacity(0.5),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Save New Record',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Montserrat",
                                  fontSize: 18,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
