// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/muscle_chip.dart';
import '../../../core/models/workout_plan.dart';

class ExerciseTimelineTile extends StatefulWidget {
  const ExerciseTimelineTile({
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
  State<ExerciseTimelineTile> createState() => _ExerciseTimelineTileState();
}

class _ExerciseTimelineTileState extends State<ExerciseTimelineTile> {
  late TextEditingController dayNameController;
  bool isEditingName = false;

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
    );
    widget.onDayUpdated(updatedDay);

    // Scroll to the new exercise
    Future.delayed(const Duration(milliseconds: 100), () {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _removeExercise(String exerciseId) {
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
    final double width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Header Card
          _buildDayHeader(width),

          // Target Muscles Section
          _buildTargetMusclesSection(),

          // Exercises List
          _buildExercisesList(),

          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildDayHeader(double width) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background with image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage('assets/img/bg3.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Dark overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          // Content
          Row(
            children: [
              Expanded(
                child: isEditingName
                    ? TextField(
                        controller: dayNameController,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        autofocus: true,
                        onSubmitted: (value) {
                          setState(() {
                            isEditingName = false;
                          });
                          final updatedDay = widget.day.copyWith(
                            dayName: value,
                          );
                          widget.onDayUpdated(updatedDay);
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onDoubleTap: () {
                          setState(() {
                            isEditingName = true;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.fitness_center,
                              color: AppColors.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.day.dayName,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black,
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isEditingName = true;
                  });
                },
                icon: const Icon(Icons.edit, color: AppColors.textSecondary),
                tooltip: 'Edit day name',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTargetMusclesSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
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
              Icon(Icons.sports_gymnastics, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Target Muscles:',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontFamily: "Montserrat",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.start,
            children: [
              MuscleChip(
                muscleName: 'Chest',
                isSelected: widget.day.targetMuscles.contains('Chest'),
                onTap: () => _updateTargetMuscles('Chest'),
              ),
              MuscleChip(
                muscleName: 'Back',
                isSelected: widget.day.targetMuscles.contains('Back'),
                onTap: () => _updateTargetMuscles('Back'),
              ),
              MuscleChip(
                muscleName: 'Shoulders',
                isSelected: widget.day.targetMuscles.contains('Shoulders'),
                onTap: () => _updateTargetMuscles('Shoulders'),
              ),
              MuscleChip(
                muscleName: 'Biceps',
                isSelected: widget.day.targetMuscles.contains('Biceps'),
                onTap: () => _updateTargetMuscles('Biceps'),
              ),
              MuscleChip(
                muscleName: 'Triceps',
                isSelected: widget.day.targetMuscles.contains('Triceps'),
                onTap: () => _updateTargetMuscles('Triceps'),
              ),
              MuscleChip(
                muscleName: 'Abs',
                isSelected: widget.day.targetMuscles.contains('Abs'),
                onTap: () => _updateTargetMuscles('Abs'),
              ),
              MuscleChip(
                muscleName: 'Quads',
                isSelected: widget.day.targetMuscles.contains('Quads'),
                onTap: () => _updateTargetMuscles('Quads'),
              ),
              MuscleChip(
                muscleName: 'Hamstrings',
                isSelected: widget.day.targetMuscles.contains('Hamstrings'),
                onTap: () => _updateTargetMuscles('Hamstrings'),
              ),
              MuscleChip(
                muscleName: 'Calves',
                isSelected: widget.day.targetMuscles.contains('Calves'),
                onTap: () => _updateTargetMuscles('Calves'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExercisesList() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.list_alt, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Exercises (${widget.day.exercises.length})',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: "Montserrat",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
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
          const SizedBox(height: 12),
          if (widget.day.exercises.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.metalLight.withOpacity(0.2),
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.add_box_outlined,
                      size: 40,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No exercises yet. Tap + to add one!',
                      style: TextStyle(
                        color: AppColors.textSecondary.withOpacity(0.7),
                        fontFamily: "Poppins",
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.day.exercises.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final exercise = widget.day.exercises[index];
                return _ExerciseItemCard(
                  exercise: exercise,
                  onUpdate: (updated) => _updateExercise(exercise.id, updated),
                  onDelete: () => _removeExercise(exercise.id),
                  exerciseNumber: index + 1,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: widget.onDuplicateDay,
              icon: const Icon(Icons.copy, size: 18),
              label: const Text('Duplicate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
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
                widget.day.isCompleted ? 'Completed' : 'Mark Complete',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.day.isCompleted
                    ? AppColors.primary
                    : AppColors.surface,
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: widget.onDeleteDay,
              icon: const Icon(Icons.delete, size: 18),
              label: const Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade800,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseItemCard extends StatefulWidget {
  final Exercise exercise;
  final Function(Exercise) onUpdate;
  final VoidCallback onDelete;
  final int exerciseNumber;

  const _ExerciseItemCard({
    required this.exercise,
    required this.onUpdate,
    required this.onDelete,
    required this.exerciseNumber,
  });

  @override
  State<_ExerciseItemCard> createState() => _ExerciseItemCardState();
}

class _ExerciseItemCardState extends State<_ExerciseItemCard> {
  late TextEditingController nameController;
  late TextEditingController notesController;
  late TextEditingController targetMuscleController;
  String? selectedImagePath;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.exercise.name);
    notesController = TextEditingController(text: widget.exercise.notes);
    targetMuscleController = TextEditingController(
      text: widget.exercise.targetMuscle,
    );
    selectedImagePath = widget.exercise.imagePath;
  }

  @override
  void dispose() {
    nameController.dispose();
    notesController.dispose();
    targetMuscleController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // TODO: Implement image picker when package is added
    // For now, just a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Image picker will be implemented with image_picker package',
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${widget.exerciseNumber}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    widget.onUpdate(widget.exercise.copyWith(name: value));
                  },
                  controller: nameController,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    hintText: 'Exercise Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.metalLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: widget.onDelete,
                icon: const Icon(Icons.close, color: Colors.red, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Remove exercise',
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            onChanged: (value) {
              widget.onUpdate(widget.exercise.copyWith(notes: value));
            },
            controller: notesController,
            maxLines: 2,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontFamily: "Poppins",
              fontSize: 12,
            ),
            decoration: InputDecoration(
              hintText: 'Notes (sets, reps, etc.)',
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.5),
                fontSize: 12,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.metalLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Target Muscle Field
          TextField(
            onChanged: (value) {
              widget.onUpdate(widget.exercise.copyWith(targetMuscle: value));
            },
            controller: targetMuscleController,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontFamily: "Poppins",
              fontSize: 12,
            ),
            decoration: InputDecoration(
              hintText: 'Target Muscle (e.g., Chest, Biceps)',
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.5),
                fontSize: 12,
              ),
              prefixIcon: const Icon(
                Icons.fitness_center,
                color: AppColors.primary,
                size: 20,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.metalLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Exercise Photo Section
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selectedImagePath != null
                            ? AppColors.primary.withOpacity(0.5)
                            : AppColors.metalLight.withOpacity(0.3),
                        width: selectedImagePath != null ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selectedImagePath != null
                              ? Icons.check_circle
                              : Icons.add_photo_alternate_outlined,
                          color: selectedImagePath != null
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            selectedImagePath != null
                                ? 'Photo Added ✓'
                                : 'Add Exercise Photo',
                            style: TextStyle(
                              color: selectedImagePath != null
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontFamily: "Poppins",
                              fontSize: 12,
                              fontWeight: selectedImagePath != null
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (selectedImagePath != null)
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedImagePath = null;
                    });
                    widget.onUpdate(widget.exercise.copyWith(imagePath: null));
                  },
                  icon: const Icon(Icons.close, color: Colors.red, size: 20),
                  tooltip: 'Remove photo',
                ),
            ],
          ),
        ],
      ),
    );
  }
}
