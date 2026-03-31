// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/muscle_chip.dart';
import '../../../core/models/workout_plan.dart';

class WorkoutDayCard extends StatefulWidget {
  const WorkoutDayCard({
    super.key,
    required this.day,
    required this.dayIndex,
    required this.onDayUpdated,
    required this.onDeleteDay,
    required this.onDuplicateDay,
  });

  final WorkoutDay day;
  final int dayIndex;
  final Function(WorkoutDay updatedDay) onDayUpdated;
  final VoidCallback onDeleteDay;
  final VoidCallback onDuplicateDay;

  @override
  State<WorkoutDayCard> createState() => _WorkoutDayCardState();
}

class _WorkoutDayCardState extends State<WorkoutDayCard> {
  late TextEditingController dayNameController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    dayNameController = TextEditingController(text: widget.day.dayName);
  }

  @override
  void dispose() {
    dayNameController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    final updatedDay = widget.day.copyWith(isExpanded: !widget.day.isExpanded);
    widget.onDayUpdated(updatedDay);
  }

  void _updateTargetMuscles(String muscle) {
    List<String> updatedMuscles = List.from(widget.day.targetMuscles);
    if (updatedMuscles.contains(muscle)) {
      updatedMuscles.remove(muscle);
    } else {
      updatedMuscles.add(muscle);
    }
    final updatedDay = widget.day.copyWith(targetMuscles: updatedMuscles);
    widget.onDayUpdated(updatedDay);
  }

  void _addExercise() {
    final newExercise = Exercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'New Exercise',
      notes: '',
      targetMuscle: widget.day.targetMuscles.isNotEmpty
          ? widget.day.targetMuscles.first
          : 'Chest',
    );

    final updatedDay = widget.day.copyWith(
      exercises: [...widget.day.exercises, newExercise],
      isExpanded: true,
    );
    widget.onDayUpdated(updatedDay);
  }

  void _RemoveExercise(String exerciseId) {
    final updatedDay = widget.day.copyWith(
      exercises: widget.day.exercises.where((e) => e.id != exerciseId).toList(),
    );
    widget.onDayUpdated(updatedDay);
  }

  void _updateExercise(String exerciseId, Exercise updatedExercise) {
    final updatedExercises = widget.day.exercises.map((e) {
      if (e.id == exerciseId) {
        return updatedExercise;
      }
      return e;
    }).toList();

    final updatedDay = widget.day.copyWith(exercises: updatedExercises);
    widget.onDayUpdated(updatedDay);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return FadeInDown(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.day.isCompleted
                ? AppColors.primary.withOpacity(0.5)
                : AppColors.metalLight.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            if (widget.day.isCompleted)
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background with image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage('assets/img/bg3.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Dark overlay
            // Positioned.fill(
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: Colors.black.withOpacity(0.4),
            //       borderRadius: BorderRadius.circular(16),
            //     ),
            //   ),
            // ),
            // Content
            Column(
              children: [
                // Header
                InkWell(
                  onTap: _toggleExpand,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/img/bg3.jpg'),
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
                            // BoxShadow(
                            //   color: Colors.white.withOpacity(0.1),
                            //   blurRadius: 6,
                            //   offset: Offset(0, -3),
                            //   spreadRadius: 0,
                            // ),
                          ],
                          // gradient: LinearGradient(
                          //   begin: Alignment.topLeft,
                          //   end: Alignment.bottomRight,
                          //   colors: [
                          //     AppColors.primary.withOpacity(0.2),
                          //     Colors.transparent,
                          //   ],
                          // ),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: isEditing
                                  ? TextField(
                                      controller: dayNameController,
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                      autofocus: true,
                                      onSubmitted: (value) {
                                        setState(() {
                                          isEditing = false;
                                        });
                                        final updatedDay = widget.day.copyWith(
                                          dayName: value,
                                        );
                                        widget.onDayUpdated(updatedDay);
                                      },
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors.primary,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onDoubleTap: () {
                                        setState(() {
                                          isEditing = true;
                                        });
                                      },
                                      child: Text(
                                        widget.day.dayName,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withOpacity(
                                                0.5,
                                              ),
                                              offset: Offset(0, 2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                            Icon(
                              widget.day.isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: AppColors.textPrimary,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          // width: width,
                          // height: 60,
                          // margin: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(10),
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: width * 0.35),
                        height: 1.7, //1.5
                        width: width * 0.5,
                        decoration: BoxDecoration(
                          // color: AppColors.glowRed.withOpacity(0.6),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.glowRed.withOpacity(0.1),
                              AppColors.glowRed,
                              AppColors.glowRed.withOpacity(0.1),
                            ],
                          ),

                          boxShadow: [
                            // BoxShadow(
                            //   color: AppColors.glowRed,
                            //   blurRadius: 5,
                            //   offset: Offset(8, -1),
                            //   spreadRadius: 3,
                            // ),
                            BoxShadow(
                              color: Colors.red,
                              blurRadius: 10, //5
                              offset: Offset(2, -1),
                              spreadRadius: 0.5, //3
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Expanded content
                if (widget.day.isExpanded) ...[
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Target Muscles Section
                        Text(
                          'Target Muscles:',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontFamily: "Montserrat",
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 5,
                          alignment: WrapAlignment.start,
                          children: [
                            MuscleChip(
                              muscleName: 'Chest',
                              isSelected: widget.day.targetMuscles.contains(
                                'Chest',
                              ),
                              onTap: () => _updateTargetMuscles('Chest'),
                            ),
                            MuscleChip(
                              muscleName: 'Back',
                              isSelected: widget.day.targetMuscles.contains(
                                'Back',
                              ),
                              onTap: () => _updateTargetMuscles('Back'),
                            ),
                            MuscleChip(
                              muscleName: 'Shoulders',
                              isSelected: widget.day.targetMuscles.contains(
                                'Shoulders',
                              ),
                              onTap: () => _updateTargetMuscles('Shoulders'),
                            ),
                            MuscleChip(
                              muscleName: 'Biceps',
                              isSelected: widget.day.targetMuscles.contains(
                                'Biceps',
                              ),
                              onTap: () => _updateTargetMuscles('Biceps'),
                            ),
                            MuscleChip(
                              muscleName: 'Triceps',
                              isSelected: widget.day.targetMuscles.contains(
                                'Triceps',
                              ),
                              onTap: () => _updateTargetMuscles('Triceps'),
                            ),
                            MuscleChip(
                              muscleName: 'Abs',
                              isSelected: widget.day.targetMuscles.contains(
                                'Abs',
                              ),
                              onTap: () => _updateTargetMuscles('Abs'),
                            ),

                            MuscleChip(
                              muscleName: 'Legs',
                              isSelected: widget.day.targetMuscles.contains(
                                'Legs',
                              ),
                              onTap: () => _updateTargetMuscles('Legs'),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // Exercises Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Exercises (${widget.day.exercises.length})',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontFamily: "Montserrat",
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              onPressed: _addExercise,
                              icon: Icon(
                                Icons.add_circle,
                                color: AppColors.primary,
                                size: 24,
                              ),
                              tooltip: 'Add Exercise',
                            ),
                          ],
                        ),
                        SizedBox(height: 10),

                        // Exercise List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.day.exercises.length,
                          itemBuilder: (context, index) {
                            final exercise = widget.day.exercises[index];
                            return ExerciseTile(
                              exercise: exercise,
                              onUpdate: (updated) =>
                                  _updateExercise(exercise.id, updated),
                              onDelete: () => _RemoveExercise(exercise.id),
                            );
                          },
                        ),

                        SizedBox(height: 16),

                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: widget.onDuplicateDay,
                                icon: Icon(Icons.copy, size: 18),
                                label: Text('Duplicate'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.surface,
                                  foregroundColor: AppColors.textPrimary,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 6),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  final updatedDay = widget.day.copyWith(
                                    isCompleted: !widget.day.isCompleted,
                                  );
                                  widget.onDayUpdated(updatedDay);
                                },
                                icon: Icon(
                                  widget.day.isCompleted
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  size: 18,
                                ),
                                label: Text(
                                  widget.day.isCompleted
                                      ? 'Completed'
                                      : 'Mark Complete',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: widget.day.isCompleted
                                      ? AppColors.primary
                                      : AppColors.surface,
                                  foregroundColor: AppColors.textPrimary,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: widget.onDeleteDay,
                                icon: Icon(Icons.delete, size: 18),
                                label: Text('Delete'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade800,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseTile extends StatefulWidget {
  final Exercise exercise;
  final Function(Exercise) onUpdate;
  final VoidCallback onDelete;

  const ExerciseTile({
    super.key,
    required this.exercise,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  late TextEditingController nameController;
  late TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.exercise.name);
    notesController = TextEditingController(text: widget.exercise.notes);
  }

  @override
  void dispose() {
    nameController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.metalLight.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    widget.onUpdate(widget.exercise.copyWith(name: value));
                  },
                  controller: nameController,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.metalLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.onDelete,
                icon: Icon(Icons.close, color: Colors.red, size: 20),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: 8),
          TextField(
            onChanged: (value) {
              widget.onUpdate(widget.exercise.copyWith(notes: value));
            },
            controller: notesController,
            maxLines: 2,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontFamily: "Poppins",
              fontSize: 12,
            ),
            decoration: InputDecoration(
              hintText: 'Notes (optional)',
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.5),
                fontSize: 12,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.metalLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
