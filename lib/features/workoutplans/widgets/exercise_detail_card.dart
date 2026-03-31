import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class ExerciseDetaisCard extends StatelessWidget {
  const ExerciseDetaisCard({
    super.key,
    required this.width,
    required this.order,
    required this.trainingName,
    required this.targetedMuscle,
    required this.imgUrl,
  });

  final double width;
  final String order;
  final String trainingName;
  final String targetedMuscle;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.secondary,
                          AppColors.primary.withOpacity(0.3),
                        ],
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
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        order,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trainingName,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
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
                      SizedBox(height: 3),
                      Text(
                        targetedMuscle,
                        style: TextStyle(
                          color: AppColors.secondary.withOpacity(0.7),
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
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
                    ],
                  ),
                ],
              ),

              SizedBox(width: 10),
              Column(
                children: [
                  SizedBox(height: 20),
                  Image.asset(
                    imgUrl,
                    width: 80,
                    height: 80,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ],
              ),
            ],
          ),
        ),
        //for the dark overlay
        Positioned.fill(
          child: Container(
            // width: width,
            // height: 60,
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),
        //for the red neon effect
        Container(
          margin: EdgeInsets.symmetric(horizontal: width * 0.08),
          height: 1.7,
          width: width * 0.8,
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
              BoxShadow(
                color: AppColors.glowRed,
                blurRadius: 10,
                offset: Offset(8, -1),
                spreadRadius: 0.5,
              ),
              // BoxShadow(
              //   color: Colors.red,
              //   blurRadius: 5,
              //   offset: Offset(2, -1),
              //   spreadRadius: 3,
              // ),
            ],
          ),
        ),
        Positioned(
          bottom: 1,
          right: width / 8.8,
          left: width / 12,
          child: Container(
            // margin: EdgeInsets.symmetric(
            //   horizontal: width * 2,
            // ),
            height: 1.7,
            width: width,
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
                  blurRadius: 10,
                  offset: Offset(2, -1),
                  spreadRadius: 0.5,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
