// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';

class GearlessAppBar extends StatelessWidget {
  const GearlessAppBar({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10),
          color: Colors.white.withOpacity(0.05),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(width: width * 0.11),
              //first child: back button
              FadeInLeft(
                delay: Duration(milliseconds: 600),
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
              ),
              //second child: the logo and the quote
              Column(
                children: [
                  FadeInDown(
                    // duration: Duration(milliseconds: 800),
                    delay: Duration(milliseconds: 500),
                    child: SizedBox(
                      width: width * 0.75,
                      child: Image.asset("assets/img/log.png"),
                    ),
                  ),
                  SizedBox(height: 3),
                  FadeIn(
                    delay: Duration(milliseconds: 600),
                    child: Container(
                      height: 1.5,
                      width: width * 0.4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.metalLight.withOpacity(0.6),
                            AppColors.metalDark.withOpacity(0.5),
                            AppColors.metalLight.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ZoomIn(
                    delay: Duration(milliseconds: 550),
                    child: Text(
                      "Train Hard. Stay Consistent",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontFamily: "Poppins",
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 1.5,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.cardBorder.withOpacity(0.4),
                AppColors.cardBorder,
                AppColors.cardBorder.withOpacity(0.4),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.glowRed,
                blurRadius: 10,
                offset: Offset(5, 5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
