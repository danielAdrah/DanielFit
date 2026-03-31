// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:danielfit/core/widgets/gearless_app_bar.dart';
import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/gradient_divider.dart';
import '../../core/widgets/muscle_chip.dart';
import '../../core/widgets/primary_btn.dart';

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

  void _selectChallangeType(String type) {
    setState(() {
      challangeType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return AppBackground(
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
                            title: "Challange Name",
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
                            title: "Challange Description",
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
                            title: "Challange Target",
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
                            title: "Challange Type",
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
                      title: "Add Challange",
                      widthMargin: width * 0.15,
                      onTap: () {},
                    ),
                  ),
                  SizedBox(height: 50),
                ],
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
