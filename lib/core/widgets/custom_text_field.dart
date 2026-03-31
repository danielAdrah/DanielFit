// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.width,
    required this.controller,
    required this.height,
  });

  final double width;
  final double height;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.metalLight.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage('assets/img/bg3.jpg'),
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
        ),

        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),
        Positioned(
          child: TextField(
            style: TextStyle(color: AppColors.textPrimary),
            cursorColor: AppColors.textPrimary,
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 15, bottom: 3),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
