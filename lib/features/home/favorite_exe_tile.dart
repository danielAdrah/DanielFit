import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../core/theme.dart';

class FavoriteExeTile extends StatelessWidget {
  const FavoriteExeTile({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: ZoomIn(
        delay: Duration(milliseconds: 700),
        child: Row(
          children: [
            Container(
              height: 7,
              width: 7,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 5),
            Text(
              title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                fontFamily: "Montserrat",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
