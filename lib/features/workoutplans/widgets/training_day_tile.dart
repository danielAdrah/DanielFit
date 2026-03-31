import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../workout_plans_view.dart';

class TrainigDaysTille extends StatelessWidget {
  const TrainigDaysTille({
    super.key,
    required this.width,
    required this.height,
    required this.days,
    required this.muscles,
  });

  final double width;
  final double height;
  final String days;
  final String muscles;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: width,
          height: height * 0.1,
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
                color: Colors.red.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, -3),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DaysTag(width: width, height: height, days: days),
              Text(
                muscles,
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
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary,
                ),
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
      ],
    );
  }
}
