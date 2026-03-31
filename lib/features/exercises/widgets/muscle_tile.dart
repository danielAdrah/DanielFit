// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class MuscleTile extends StatelessWidget {
  const MuscleTile({
    super.key,
    required this.width,
    required this.height,
    required this.exeNumber,
    required this.muscleName,
    required this.imgUrl,
    required this.isDisplay,
  });

  final double width;
  final double height;
  final String exeNumber;
  final String muscleName;
  final String imgUrl;
  final bool isDisplay;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: width,
          height: height * 0.13,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
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
                color: Colors.white.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, -3),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  //the image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),

                    child: isDisplay
                        ? Image.asset(
                            imgUrl,
                            width: 100,
                            height: height,
                            color: Colors.white.withOpacity(0.5),
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            imgUrl,
                            width: 100,
                            height: height,
                            fit: BoxFit.cover,
                          ),
                  ),
                  SizedBox(width: width * 0.02),
                  //muscle name and total exercises
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        muscleName,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        exeNumber,
                        style: TextStyle(
                          color: AppColors.textPrimary.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Montserrat",
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 60,
                height: 60,
                child: Image.asset("assets/img/dumbell.png", fit: BoxFit.cover),
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
              color: Colors.black.withOpacity(0.2),
            ),
          ),
        ),
        //for the red neon effect
        Container(
          margin: EdgeInsets.symmetric(horizontal: width * 0.1),
          height: 1.7, //1.5
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
              // BoxShadow(
              //   color: AppColors.glowRed,
              //   blurRadius: 5,
              //   offset: Offset(8, -1),
              //   spreadRadius: 3,
              // ),
              BoxShadow(
                color: Colors.red,
                blurRadius: 10, //5
                offset: Offset(2, -1),
                spreadRadius: 0.5, //3
              ),
            ],
          ),
        ),
      ],
    );
  }
}
