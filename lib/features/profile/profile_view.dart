// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:danielfit/core/widgets/app_background.dart';
import 'package:danielfit/core/widgets/gradient_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme.dart';
import '../../core/widgets/gearless_app_bar.dart';
import 'data/bloc/profile_bloc.dart';
import 'data/bloc/profile_event.dart';
import 'data/bloc/profile_state.dart';
import 'widgets/status_card.dart';
import 'widgets/muscle_group_pie_chart.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final GetStorage storage = GetStorage();

  List<String> icons = [
    'assets/img/dumbell.png',
    'assets/img/fav.png',
    'assets/img/list.png',
    'assets/img/muscle.png',
  ];

  File? image;
  String? imagePath;
  final imagePicker = ImagePicker();
  @override
  void initState() {
    super.initState();
    // Load statistics when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(const LoadProfileStatisticsEvent());
    });
    imagePath = storage.read('imagePath');
  }

  uploadImage() async {
    var pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imagePath = pickedImage.path;
        storage.write('imagePath', pickedImage.path);
      });
    } else {}
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
            child: Column(
              children: [
                GearlessAppBar(width: width),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //circle avatar and name
                      Row(
                        children: [
                          //avatar image
                          FadeInLeft(
                            delay: Duration(milliseconds: 500),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: width * 0.35,
                                  height: height * 0.3,
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
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
                                        color: Colors.red.withOpacity(0.4),
                                        blurRadius: 15,
                                        offset: Offset(0, -3),
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imagePath == null
                                            ? AssetImage("assets/img/bg3.jpg")
                                            : FileImage(File(imagePath!)),
                                        // fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                //the camera icon
                                Positioned(
                                  bottom: height * 0.07,
                                  right: 3,
                                  child: InkWell(
                                    onTap: () {
                                      uploadImage();
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: AssetImage(
                                            "assets/img/bg3.jpg",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.6,
                                            ),
                                            blurRadius: 10,
                                            offset: Offset(0, 5),
                                            spreadRadius: 0,
                                          ),
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.3,
                                            ),
                                            blurRadius: 15,
                                            offset: Offset(0, 8),
                                            spreadRadius: -3,
                                          ),
                                          BoxShadow(
                                            color: Colors.white.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 6,
                                            offset: Offset(0, -3),
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          color: AppColors.primary.withOpacity(
                                            0.4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          FadeInRight(
                            delay: Duration(milliseconds: 500),
                            child: NameAndTrainingDate(),
                          ),
                        ],
                      ),
                      FadeInLeft(
                        delay: Duration(milliseconds: 550),
                        child: Container(
                          padding: EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
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
                                color: Colors.red.withOpacity(0.1),
                                blurRadius: 6,
                                offset: Offset(0, -3),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Text(
                            "Statistics",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w700,
                              fontSize: 21,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          // Default values for loading or error states
                          int exercisesCount = 0;
                          int favoritesCount = 0;
                          int plansCount = 0;
                          int challengesCount = 0;

                          if (state is ProfileStatisticsLoaded) {
                            exercisesCount = state.totalExercises;
                            favoritesCount = state.totalFavorites;
                            plansCount = state.totalPlans;
                            challengesCount = state.totalChallenges;
                          }

                          final labels = [
                            "Exercises",
                            "Favorites",
                            "Plans",
                            "Challanges",
                          ];
                          final values = [
                            exercisesCount.toString(),
                            favoritesCount.toString(),
                            plansCount.toString(),
                            challengesCount.toString(),
                          ];

                          return SizedBox(
                            width: width,
                            height: height * 0.2,
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 2.8,
                                  ),
                              itemCount: labels.length,
                              itemBuilder: (context, index) {
                                if (index % 2 == 0) {
                                  return FadeInLeft(
                                    delay: Duration(milliseconds: 600),
                                    child: StatusCard(
                                      height: height,
                                      width: width,
                                      label: labels[index],
                                      value: values[index],
                                      iconOverlay: icons[index],
                                    ),
                                  );
                                } else {
                                  return FadeInRight(
                                    delay: Duration(milliseconds: 600),
                                    child: StatusCard(
                                      height: height,
                                      width: width,
                                      label: labels[index],
                                      value: values[index],
                                      iconOverlay: icons[index],
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                      FadeIn(
                        delay: Duration(milliseconds: 750),
                        child: GradientDivider(width: width * 0.9),
                      ),
                      SizedBox(height: height * 0.03),
                      FadeInLeft(
                        delay: Duration(milliseconds: 700),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/img/dumbell.png",
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Favorite Exercise",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      FadeInLeft(
                        delay: Duration(milliseconds: 800),
                        child: FavoriteExerciseTile(
                          width: width,
                          height: height,
                        ),
                      ),
                      SizedBox(height: height * 0.04),
                      GradientDivider(width: width * 0.9),
                      SizedBox(height: height * 0.02),
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          Map<String, int> muscleGroupDistribution = {};

                          if (state is ProfileStatisticsLoaded) {
                            muscleGroupDistribution =
                                state.muscleGroupDistribution;
                          }

                          return FadeIn(
                            delay: Duration(milliseconds: 900),
                            child: MuscleGroupPieChart(
                              muscleGroupDistribution: muscleGroupDistribution,
                              width: width,
                              height: height,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      GradientDivider(width: width * 0.9),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FavoriteExerciseTile extends StatelessWidget {
  const FavoriteExerciseTile({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: width,
          height: height * 0.05,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.metalLight.withOpacity(0.6),
              width: 1.5,
            ),
            image: DecorationImage(
              image: AssetImage("assets/img/bg3.jpg"),
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
                color: Colors.red.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, -3),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Text(
                "Squat 😈",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Container(
            // width: width,
            // height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}

class NameAndTrainingDate extends StatelessWidget {
  const NameAndTrainingDate({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Daniel",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
            fontSize: 19,
          ),
        ),
        Container(
          decoration: BoxDecoration(
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
                color: Colors.red.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, -3),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Text(
            "Training Since: 18/10/2025 🥇",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
        // Text(
        //   "18/10/2025",
        //   style: TextStyle(
        //     color: AppColors.textPrimary,
        //     fontFamily: "Montserrat",
        //     fontWeight: FontWeight.w500,
        //     fontSize: 12,
        //   ),
        // ),
      ],
    );
  }
}
