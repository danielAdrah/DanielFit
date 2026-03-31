import 'package:flutter/material.dart';

import '../theme.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
  });

  final void Function() onTap;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBorder,
          border: Border.all(color: AppColors.metalLight, width: 1.5),
          borderRadius: BorderRadius.circular(5),
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
        child: Center(
          child: Row(
            children: [
              Icon(icon, size: 16, color: AppColors.textPrimary),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: "Montserrat",
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
