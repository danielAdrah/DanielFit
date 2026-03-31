// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/widgets/gradient_divider.dart';

class CurrentChallengeCard extends StatelessWidget {
  const CurrentChallengeCard({
    super.key,
    required this.width,
    required this.height,
    required this.challangeName,
    required this.challangeValue,
  });

  final double width;
  final double height;
  final String challangeName;
  final String challangeValue;

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      delay: Duration(milliseconds: 800),
      child: Stack(
        children: [
          Container(
            width: width,
            height: height * 0.18,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.metalLight.withOpacity(0.4),
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
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(0, -3),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Current Challange",
                      style: TextStyle(
                        color: AppColors.textPrimary.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                        fontFamily: "Arvo",
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(width: 3),
                    Image.asset("assets/img/dart.png", width: 26, height: 26),
                  ],
                ),
                SizedBox(height: height * 0.01),
                GradientDivider(width: width * 0.7),
                SizedBox(height: height * 0.01),

                Text(
                  challangeName,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Montserrat",
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Progress: ",
                      style: TextStyle(
                        color: AppColors.textSecondary.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                        fontFamily: "Montserrat",
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 3),
                    Text(
                      "$challangeValue/15 ",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Montserrat",
                        fontSize: 16,
                      ),
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),

                color: Colors.black.withOpacity(0.35),
              ),
            ),
          ),
          //for the red neon effect
          Container(
            margin: EdgeInsets.symmetric(horizontal: width * 0.3),
            height: 1.5,
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
        ],
      ),
    );
  }
}
