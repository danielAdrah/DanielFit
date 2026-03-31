// ignore_for_file: unused_local_variable, deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:danielfit/features/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          color: Colors.white.withOpacity(0.05),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //first child: just for spacing
              SizedBox(width: width * 0.11),
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
                  Container(
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
              //third child: the gear icon
              FadeInRight(
                delay: Duration(milliseconds: 600),
                child: InkWell(
                  onTap: () {
                    Get.to(() => ProfileView());
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.metalDark,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.metalLight,
                        // width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.settings,
                        color: AppColors.metalLight,
                        size: 25,
                      ),
                    ),
                  ),
                ),
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
