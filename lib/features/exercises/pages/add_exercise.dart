// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme.dart';
import '../../../core/models/exercise_model.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/gearless_app_bar.dart';
import '../../../core/widgets/gradient_divider.dart';
import '../../../core/widgets/helper.dart';
import '../../../core/widgets/primary_btn.dart';
import '../data/exercise_data.dart';

class AddExercise extends StatefulWidget {
  const AddExercise({super.key});

  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  final exerciseName = TextEditingController();
  final note = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String? targetedMuscle;
  String? selectedBodyPart; // Track which body part is selected
  bool isToggled = false; // false = front view, true = back view
  File? _selectedImage;
  bool _isSelectingImage = false;
  final PageController _pageController = PageController();

  void _selectBodyPart(String bodyPart) {
    setState(() {
      selectedBodyPart = bodyPart;
      targetedMuscle = bodyPart;
    });

    // Haptic feedback for better UX
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _pageController.dispose();
    exerciseName.dispose();
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return AppBackground(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocListener<ExerciseBloc, ExerciseState>(
            listener: (context, state) {
              if (state is ExerciseAdded) {
                // Success - show snackbar and navigate back
                Helper().showSnackBar(
                  "Success",
                  "✅ Exercise added successfully!",
                  Colors.green,
                  Icons.done_all_sharp,
                );

                Navigator.pop(context);
              } else if (state is ExerciseError) {
                // Error - show error message
                Helper().showSnackBar(
                  "Error",
                  "❌ Error: ${state.message}",
                  AppColors.secondary,
                  Icons.error_outline,
                );
              }
            },
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    GearlessAppBar(width: width),
                    SizedBox(height: height * 0.05),
                    ZoomIn(
                      delay: Duration(milliseconds: 600),
                      child: InkWell(
                        onTap: _pickImageFromGallery,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            //main content
                            Container(
                              width: width * 0.8,
                              height: height * 0.2,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.metalLight,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
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
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: Offset(0, -3),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: _selectedImage != null
                                    ? Image.file(
                                        _selectedImage!,
                                        // width: width * 0.8,
                                        // height: height * 0.25,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset("assets/img/c1.png"),
                              ),
                            ),
                            //dark overlay
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ),
                            ),
                            //add icon
                            Positioned(
                              bottom: -4,
                              right: -10,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [
                                      const Color.fromARGB(255, 231, 7, 22),
                                      const Color.fromARGB(255, 180, 11, 11),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
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
                                      color: AppColors.glowRed.withOpacity(0.6),
                                      blurRadius: 6,
                                      offset: Offset(0, -3),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                    GradientDivider(width: width * 0.8),
                    SizedBox(height: height * 0.05),
                    // Muscle Selection Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: FadeInDown(
                        delay: Duration(milliseconds: 650),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FormHeader(
                              title: "Target Muscle",
                              iconUrl: "assets/img/muscle.png",
                            ),
                            SizedBox(height: height * 0.02),
                            // Interactive Body Selector with Swipe Gesture
                            FadeInDown(
                              delay: Duration(milliseconds: 100),
                              child: SizedBox(
                                height: height * 0.5,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // PageView for swipeable front/back views
                                    PageView(
                                      controller: _pageController,
                                      onPageChanged: (index) {
                                        setState(() {
                                          isToggled = index == 1;
                                          selectedBodyPart = "";
                                        });
                                      },
                                      physics: BouncingScrollPhysics(),
                                      children: [
                                        frontBodySelector(height, width),
                                        backBodySelector(height, width),
                                      ],
                                    ),

                                    // Visual indicator dots at the bottom
                                    Positioned(
                                      bottom: 10,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AnimatedContainer(
                                            duration: Duration(
                                              milliseconds: 300,
                                            ),
                                            width: isToggled == false ? 25 : 8,
                                            height: 8,
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isToggled == false
                                                  ? AppColors.primary
                                                  : AppColors.textSecondary
                                                        .withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                          AnimatedContainer(
                                            duration: Duration(
                                              milliseconds: 300,
                                            ),
                                            width: isToggled == true ? 25 : 8,
                                            height: 8,
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isToggled == true
                                                  ? AppColors.primary
                                                  : AppColors.textSecondary
                                                        .withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Optional: Subtle left/right edge tap zones
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: InkWell(
                                        onTap: () {
                                          if (isToggled) {
                                            _pageController.previousPage(
                                              duration: Duration(
                                                milliseconds: 300,
                                              ),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        },
                                        child: Container(
                                          width: 30,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white.withOpacity(0.05),
                                                Colors.transparent,
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.chevron_left,
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: InkWell(
                                        onTap: () {
                                          if (!isToggled) {
                                            _pageController.nextPage(
                                              duration: Duration(
                                                milliseconds: 300,
                                              ),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        },
                                        child: Container(
                                          width: 30,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.transparent,
                                                Colors.white.withOpacity(0.05),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.chevron_right,
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: height * 0.02),

                            // Instructional text
                            Text(
                              "Swipe or tap edges to switch views",
                              style: TextStyle(
                                color: AppColors.textSecondary.withOpacity(0.6),
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: height * 0.03),
                            // the selected muscle
                            Center(
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                curve: Curves.elasticOut,
                                width: targetedMuscle != null
                                    ? width * 0.6
                                    : width * 0.3,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.grey.withOpacity(0.5),
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: targetedMuscle != null
                                        ? AppColors.primary
                                        : AppColors.textSecondary.withOpacity(
                                            0.2,
                                          ),
                                    width: 2,
                                  ),
                                  boxShadow: targetedMuscle != null
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withOpacity(0.3),
                                            blurRadius: 15,
                                            spreadRadius: 2,
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (targetedMuscle != null) ...[
                                      Expanded(
                                        child: Text(
                                          targetedMuscle!.toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                            fontFamily: "Montserrat",
                                          ),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ] else ...[
                                      Text(
                                        "Select a muscle",
                                        style: TextStyle(
                                          color: AppColors.textSecondary
                                              .withOpacity(0.5),
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: height * 0.02),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.04),
                    GradientDivider(width: width * 0.8),
                    SizedBox(height: height * 0.05),
                    //text fields section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: FadeInLeft(
                        delay: Duration(milliseconds: 700),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FormHeader(
                              title: "Exercise Name",
                              iconUrl: "assets/img/dumbell.png",
                            ),
                            SizedBox(height: 5),
                            CustomTextField(
                              width: width,
                              height: 40,
                              controller: exerciseName,
                            ),
                            SizedBox(height: height * 0.03),
                            FormHeader(
                              title: "Notes",
                              iconUrl: "assets/img/list.png",
                            ),
                            SizedBox(height: 5),
                            CustomTextField(
                              width: width,
                              height: 100,
                              controller: note,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.04),
                    FadeInRight(
                      delay: Duration(milliseconds: 800),
                      child: BlocBuilder<ExerciseBloc, ExerciseState>(
                        builder: (context, state) {
                          final isLoading = state is ExerciseLoading;
                          return PrimaryBtn(
                            title: isLoading ? 'Adding...' : 'Add Exercise',
                            widthMargin: width * 0.15,
                            onTap: () {
                              if (!isLoading) {
                                _validateAndAddExercise();
                              }
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _validateAndAddExercise() {
    // Validate inputs
    if (exerciseName.text.trim().isEmpty) {
      Helper().showSnackBar(
        "Warning",
        "⚠ Please enter exercise name",
        Colors.orange,
        Icons.warning_amber,
      );

      return;
    }

    if (targetedMuscle == null || targetedMuscle!.isEmpty) {
      Helper().showSnackBar(
        "Warning",
        "⚠ Please select a target muscle",
        Colors.orange,
        Icons.warning_amber,
      );

      return;
    }

    // Create exercise model
    final exercise = ExerciseModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: exerciseName.text.trim(),
      imagePath: _selectedImage?.path,
      notes: note.text.trim(),
      targetMuscle: normalizeMuscleName(targetedMuscle!),
      isFavorite: false,
      isHated: false,
    );

    // Dispatch event to BLoC
    context.read<ExerciseBloc>().add(AddExerciseEvent(exercise));
  }

  /// Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    if (_isSelectingImage) return;

    setState(() {
      _isSelectingImage = true;
    });

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to pick image: ${e.message}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSelectingImage = false;
        });
      }
    }
  }

  /// Normalize muscle names to match predefined categories
  String normalizeMuscleName(String muscle) {
    final normalized = muscle.toLowerCase();

    // Map variations to standard names
    if (normalized.contains('chest')) return 'Chest';
    if (normalized.contains('back')) return 'Back';
    if (normalized.contains('biecep') || normalized.contains('bicep'))
      return 'Bieceps';
    if (normalized.contains('tricep')) return 'Triceps';
    if (normalized.contains('shoulder')) return 'Shoulders';
    if (normalized.contains('leg')) return 'Legs';
    if (normalized.contains('abs')) return 'Abs';
    if (normalized.contains('lat')) return 'Back';
    if (normalized.contains('forearm')) return 'Forearms';
    if (normalized.contains('quad')) return 'Legs';
    if (normalized.contains('hamstring')) return 'Legs';
    if (normalized.contains('calf') || normalized.contains('calve'))
      return 'Legs';

    // Return capitalized original if no match
    return muscle.substring(0, 1).toUpperCase() + muscle.substring(1);
  }

  Stack backBodySelector(double height, double width) {
    return Stack(
      children: [
        //the bodymap
        Center(
          child: SizedBox(
            height: height * 0.5,
            child: Image.asset('assets/img/backbody.png'),
          ),
        ),
        //Back
        Positioned(
          top: height * 0.07,
          left: width * 0.33,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("Back"),
            child: Container(
              height: height * 0.07,
              width: width * 0.22,
              decoration: BoxDecoration(
                color: selectedBodyPart == "Back"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "Back"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),

                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        //rershoulders
        Positioned(
          top: height * 0.075,
          left: width * 0.19,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("Shoulders"),
            child: Container(
              height: height * 0.05,
              width: width * 0.22,
              decoration: BoxDecoration(
                color: selectedBodyPart == "Shoulders"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "Shoulders"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        //shoulders
        Positioned(
          top: height * 0.075,
          right: width * 0.2,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("Shoulders"),
            child: Container(
              height: height * 0.05,
              width: width * 0.22,
              decoration: BoxDecoration(
                color: selectedBodyPart == "Shoulders"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "Shoulders"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        //Triceps
        Positioned(
          top: height * 0.11,
          right: width * 0.25,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("Triceps"),
            child: Container(
              height: height * 0.07,
              width: width * 0.09,
              decoration: BoxDecoration(
                color: selectedBodyPart == "Triceps"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "Triceps"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        //Triceps
        Positioned(
          top: height * 0.11,
          left: width * 0.25,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("Triceps"),
            child: Container(
              height: height * 0.07,
              width: width * 0.09,
              decoration: BoxDecoration(
                color: selectedBodyPart == "Triceps"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "Triceps"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        //lats
        Positioned(
          top: height * 0.135,
          left: width * 0.33,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("Lats"),
            child: Container(
              height: height * 0.08,
              width: width * 0.215,
              decoration: BoxDecoration(
                color: selectedBodyPart == "Lats"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "Lats"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        //forearm
        Positioned(
          top: height * 0.17,
          left: width * 0.2,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("forearm"),
            child: Container(
              height: height * 0.06,
              width: width * 0.09,
              decoration: BoxDecoration(
                color: selectedBodyPart == "forearm"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "forearm"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        //forearm
        Positioned(
          top: height * 0.17,
          right: width * 0.2,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("forearm"),
            child: Container(
              height: height * 0.06,
              width: width * 0.09,
              decoration: BoxDecoration(
                color: selectedBodyPart == "forearm"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "forearm"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        //Hamstrings
        Positioned(
          top: height * 0.26,
          right: width * 0.31,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("Hamstrings"),
            child: Container(
              height: height * 0.1,
              width: width * 0.12,
              decoration: BoxDecoration(
                color: selectedBodyPart == "Hamstrings"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "Hamstrings"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        //Hamstrings
        Positioned(
          top: height * 0.26,
          left: width * 0.31,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("Hamstrings"),
            child: Container(
              height: height * 0.1,
              width: width * 0.12,
              decoration: BoxDecoration(
                color: selectedBodyPart == "Hamstrings"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "Hamstrings"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        //calves
        Positioned(
          top: height * 0.35,
          left: width * 0.3,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("Calves"),
            child: Container(
              height: height * 0.11,
              width: width * 0.1,
              decoration: BoxDecoration(
                color: selectedBodyPart == "Calves"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "Calves"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        //calves
        Positioned(
          top: height * 0.35,
          right: width * 0.3,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("Calves"),
            child: Container(
              height: height * 0.11,
              width: width * 0.1,
              decoration: BoxDecoration(
                color: selectedBodyPart == "Calves"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "Calves"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Stack frontBodySelector(double height, double width) {
    return Stack(
      children: [
        //the bodymap
        Center(
          child: SizedBox(
            height: height * 0.5,
            child: Image.asset('assets/img/frontbody.png'),
          ),
        ),
        //chest
        Positioned(
          top: height * 0.09,
          left: width * 0.33,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("chest"),
            child: Container(
              height: height * 0.05,
              width: width * 0.22,
              decoration: BoxDecoration(
                color: selectedBodyPart == "chest"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "chest"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),

                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        //shoulders
        Positioned(
          top: height * 0.075,
          left: width * 0.19,
          child: InkWell(
            onTap: () => _selectBodyPart("shoulders"),
            splashColor: Colors.transparent,
            child: Container(
              height: height * 0.05,
              width: width * 0.22,
              decoration: BoxDecoration(
                color: selectedBodyPart == "shoulders"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "shoulders"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        //shoulders
        Positioned(
          top: height * 0.075,
          right: width * 0.2,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("shoulders"),
            child: Container(
              height: height * 0.05,
              width: width * 0.22,
              decoration: BoxDecoration(
                color: selectedBodyPart == "shoulders"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "shoulders"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        //bieceps
        Positioned(
          top: height * 0.12,
          right: width * 0.25,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("bieceps"),
            child: Container(
              height: height * 0.06,
              width: width * 0.09,
              decoration: BoxDecoration(
                color: selectedBodyPart == "bieceps"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "bieceps"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        //bieceps
        Positioned(
          top: height * 0.12,
          left: width * 0.25,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("bieceps"),
            child: Container(
              height: height * 0.06,
              width: width * 0.09,
              decoration: BoxDecoration(
                color: selectedBodyPart == "bieceps"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "bieceps"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        //abs
        Positioned(
          top: height * 0.135,
          left: width * 0.38,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("Abs"),
            child: Container(
              height: height * 0.1,
              width: width * 0.11,
              decoration: BoxDecoration(
                color: selectedBodyPart == "Abs"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "Abs"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        //forearm
        Positioned(
          top: height * 0.17,
          left: width * 0.2,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("forearm"),
            child: Container(
              height: height * 0.06,
              width: width * 0.09,
              decoration: BoxDecoration(
                color: selectedBodyPart == "forearm"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "forearm"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        //forearm
        Positioned(
          top: height * 0.17,
          right: width * 0.2,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("forearm"),
            child: Container(
              height: height * 0.06,
              width: width * 0.09,
              decoration: BoxDecoration(
                color: selectedBodyPart == "forearm"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "forearm"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        //quad
        Positioned(
          top: height * 0.22,
          right: width * 0.31,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("Quad"),
            child: Container(
              height: height * 0.12,
              width: width * 0.12,
              decoration: BoxDecoration(
                color: selectedBodyPart == "Quad"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "Quad"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        //quad
        Positioned(
          top: height * 0.22,
          left: width * 0.31,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () => _selectBodyPart("Quad"),
            child: Container(
              height: height * 0.12,
              width: width * 0.12,
              decoration: BoxDecoration(
                color: selectedBodyPart == "Quad"
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedBodyPart == "Quad"
                      ? AppColors.cardBorder
                      : Colors.transparent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FormHeader extends StatelessWidget {
  const FormHeader({super.key, required this.title, required this.iconUrl});
  final String title;
  final String iconUrl;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(iconUrl, width: 23, height: 23, fit: BoxFit.cover),
        SizedBox(width: 3),
        Text(
          title,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontFamily: "Montserrat",
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
