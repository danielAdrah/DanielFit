// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:danielfit/core/widgets/app_background.dart';
import 'package:danielfit/core/widgets/gradient_divider.dart';
import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../core/widgets/gearless_app_bar.dart';
import 'status_card.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  List<String> labels = ["Exercises", "Favorites", "Plans", "Challanges"];
  List<String> values = ["20", "5", "3", "2"];
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
                                        //later we will use network image to fetch the real image
                                        image: AssetImage("assets/img/bg3.jpg"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                //the camera icon
                                Positioned(
                                  bottom: height * 0.07,
                                  right: 3,
                                  child: InkWell(
                                    onTap: () {},
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
                      SizedBox(
                        width: width,
                        height: height * 0.2,
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // 2 items per row
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio:
                                    2.8, // Slightly taller than wide
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
                                ),
                              );
                            }
                          },
                        ),
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
