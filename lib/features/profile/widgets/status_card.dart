// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.width,
    required this.height,
    required this.label,
    required this.value,
  });

  final double width;
  final double height;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          width: width * 0.4,
          height: height * 0.06,
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
              Column(
                children: [
                  SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 1),
                ],
              ),
              Text(
                value,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          child: Container(
            width: width * 0.4,
            height: height * 0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),

        //for the red neon effect
        Positioned(
          bottom: height * 0.022,
          left: width * 0.02,
          child: Container(
            // alignment: Alignment.bottomLeft,
            // margin: EdgeInsets.symmetric(horizontal: width * 0.2),
            height: 1.5,
            width: width * 0.1,
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
                  color: Colors.red,
                  blurRadius: 5,
                  offset: Offset(2, -1),
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
