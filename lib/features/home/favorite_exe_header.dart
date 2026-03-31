import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../core/theme.dart';

class FavoriteExercisesHeader extends StatelessWidget {
  const FavoriteExercisesHeader({super.key, required this.onTap});
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FadeInLeft(
            delay: Duration(milliseconds: 600),
            child: Row(
              children: [
                Text(
                  "Favorite Exercises",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    fontFamily: "Montserrat",
                  ),
                ),
                SizedBox(width: 2),
                Image.asset("assets/img/fav.png", width: 25, height: 25),
              ],
            ),
          ),
          FadeInRight(
            delay: Duration(milliseconds: 600),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: onTap,
              child: Row(
                children: [
                  Text(
                    "View All",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textSecondary,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
