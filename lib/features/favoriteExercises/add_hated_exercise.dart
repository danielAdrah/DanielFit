// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:danielfit/core/widgets/gearless_app_bar.dart';
import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/gradient_divider.dart';
import '../../core/widgets/image_section.dart';
import '../../core/widgets/primary_btn.dart';

class AddHatedExercise extends StatefulWidget {
  const AddHatedExercise({super.key});

  @override
  State<AddHatedExercise> createState() => _AddHatedExerciseState();
}

class _AddHatedExerciseState extends State<AddHatedExercise> {
  final exerciseName = TextEditingController();

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
                  ZoomIn(
                    delay: Duration(milliseconds: 600),
                    child: ImageSection(
                      width: width,
                      height: height,
                      onTap: () {},
                      img: 'assets/img/c1.png',
                    ),
                  ),
                  SizedBox(height: height * 0.05),
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  FadeInRight(
                    delay: Duration(milliseconds: 800),
                    child: PrimaryBtn(
                      title: "Add to Hated 😡",
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
