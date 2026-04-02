// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:danielfit/core/widgets/gearless_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/gradient_divider.dart';
import '../../../core/widgets/helper.dart';
import '../../../core/widgets/muscle_chip.dart';
import '../../../core/widgets/primary_btn.dart';
import '../../../core/models/challenge_model.dart';
import '../data/bloc/challenge_bloc.dart';
import '../data/bloc/challenge_event.dart';
import '../data/bloc/challenge_state.dart';

class AddChallange extends StatefulWidget {
  const AddChallange({super.key});

  @override
  State<AddChallange> createState() => _AddChallangeState();
}

class _AddChallangeState extends State<AddChallange> {
  final challangeName = TextEditingController();
  final challangeDescription = TextEditingController();
  final targetValue = TextEditingController();
  final progressValue = TextEditingController();
  String? challangeType;
  bool _isSubmitting = false;

  @override
  void dispose() {
    challangeName.dispose();
    challangeDescription.dispose();
    targetValue.dispose();
    progressValue.dispose();
    super.dispose();
  }

  void _selectChallangeType(String type) {
    setState(() {
      challangeType = type;
    });
  }

  String? _validateForm() {
    // Validate challenge name
    if (challangeName.text.trim().isEmpty) {
      return 'Please enter a challenge name';
    }

    // Validate description
    if (challangeDescription.text.trim().isEmpty) {
      return 'Please enter a challenge description';
    }

    // Validate challenge type
    if (challangeType == null) {
      return 'Please select a challenge type (Reps or Weight)';
    }

    // Validate target value
    if (targetValue.text.trim().isEmpty) {
      return 'Please enter a target value';
    }
    final targetNum = double.tryParse(targetValue.text.trim());
    if (targetNum == null || targetNum <= 0) {
      return 'Target value must be a positive number';
    }

    // Validate initial progress
    if (progressValue.text.trim().isEmpty) {
      return 'Please enter initial progress value';
    }
    final progressNum = double.tryParse(progressValue.text.trim());
    if (progressNum == null || progressNum < 0) {
      return 'Initial progress must be a non-negative number';
    }
    if (progressNum > targetNum) {
      return 'Initial progress cannot exceed target value';
    }

    return null; // No errors
  }

  void _addChallenge() async {
    // Validate form
    final error = _validateForm();
    if (error != null) {
      Helper().showSnackBar(
        "Warning",
        error,
        Colors.orange,
        Icons.warning_amber,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Determine unit based on challenge type
    String unit;
    if (challangeType == 'Reps') {
      unit = 'reps';
    } else {
      // Weight - could ask user for kg/lbs, defaulting to kg for now
      unit = 'kg';
    }

    // Create challenge model
    final newChallenge = ChallengeModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      challengeName: challangeName.text.trim(),
      description: challangeDescription.text.trim(),
      targetType: challangeType!,
      targetValue: double.parse(targetValue.text.trim()),
      currentValue: double.parse(progressValue.text.trim()),
      unit: unit,
    );

    // Dispatch event to BLoC
    context.read<ChallengeBloc>().add(AddChallengeEvent(newChallenge));
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return BlocListener<ChallengeBloc, ChallengeState>(
      listener: (context, state) {
        if (state is ChallengeLoading) {
          setState(() {
            _isSubmitting = true;
          });
          // Show loading indicator
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              );
            },
          );
        } else if (state is ChallengeAdded) {
          setState(() {
            _isSubmitting = false;
          });
          // Close loading dialog if open
          Navigator.of(context, rootNavigator: true).pop();

          // Show success message
          Helper().showSnackBar(
            "Success",
            'Challenge "${state.challenge.challengeName}" added successfully! 🎉',
            Colors.green,
            Icons.done_all,
          );

          // Navigate back after a short delay
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is ChallengeError) {
          setState(() {
            _isSubmitting = false;
          });
          // Close loading dialog if open
          Navigator.of(context, rootNavigator: true).pop();

          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: AppBackground(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    GearlessAppBar(width: width),
                    SizedBox(height: height * 0.08),
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
                              title: "Challenge Name",
                              iconUrl: "assets/img/muscle.png",
                            ),
                            SizedBox(height: 5),
                            CustomTextField(
                              width: width,
                              height: 40,
                              controller: challangeName,
                            ),
                            SizedBox(height: height * 0.02),
                            FormHeader(
                              title: "Challenge Description",
                              iconUrl: "assets/img/list.png",
                            ),
                            SizedBox(height: 5),
                            CustomTextField(
                              width: width,
                              height: 70,
                              controller: challangeDescription,
                            ),
                            SizedBox(height: height * 0.02),
                            FormHeader(
                              title: "Challenge Target",
                              iconUrl: "assets/img/dumbell.png",
                            ),
                            SizedBox(height: 5),
                            CustomTextField(
                              width: width,
                              height: 40,
                              controller: targetValue,
                            ),
                            SizedBox(height: height * 0.02),
                            FormHeader(
                              title: "Initial Progress",
                              iconUrl: "assets/img/dumbell.png",
                            ),
                            SizedBox(height: 5),
                            CustomTextField(
                              width: width,
                              height: 40,
                              controller: progressValue,
                            ),
                            SizedBox(height: height * 0.02),
                            FormHeader(
                              title: "Challenge Type",
                              iconUrl: "assets/img/dumbell.png",
                            ),
                            SizedBox(height: 5),
                            Wrap(
                              spacing: 5,
                              children: [
                                MuscleChip(
                                  isSelected: challangeType == "Reps"
                                      ? true
                                      : false,
                                  muscleName: 'Reps',
                                  onTap: () => _selectChallangeType("Reps"),
                                ),
                                MuscleChip(
                                  isSelected: challangeType == "Weight"
                                      ? true
                                      : false,
                                  muscleName: 'Weight',
                                  onTap: () => _selectChallangeType("Weight"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    GradientDivider(width: width * 0.9),
                    SizedBox(height: height * 0.04),
                    FadeInRight(
                      delay: Duration(milliseconds: 800),
                      child: PrimaryBtn(
                        title: _isSubmitting ? "Adding..." : "Add Challenge",
                        widthMargin: width * 0.15,
                        onTap: _isSubmitting ? () {} : _addChallenge,
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
