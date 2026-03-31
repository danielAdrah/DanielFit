// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class GradientDivider extends StatelessWidget {
  const GradientDivider({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      delay: Duration(milliseconds: 700),
      child: Container(
        height: 2,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // AppColors.cardBorder.withOpacity(0.4),
              AppColors.metalLight.withOpacity(0.4),
              AppColors.metalLight.withOpacity(0.2),
              AppColors.metalLight.withOpacity(0.4),
            ],
          ),
        ),
      ),
    );
  }
}
