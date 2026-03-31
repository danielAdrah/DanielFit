import 'package:flutter/material.dart';

import '../theme.dart';

class MuscleChip extends StatelessWidget {
  const MuscleChip({
    super.key,
    required this.muscleName,
    required this.isSelected,
    required this.onTap,
  });

  final String muscleName;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: MediaQuery.of(context).size.width * 0.28,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.metalLight.withOpacity(0.4),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withOpacity(0.5),
                blurRadius: 12,
                offset: Offset(0, 6),
                spreadRadius: 2,
              ),
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 3),
              spreadRadius: 0,
            ),
            if (isSelected)
              BoxShadow(
                color: Colors.white.withOpacity(0.15),
                blurRadius: 4,
                offset: Offset(0, -2),
                spreadRadius: 0,
              ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main container with background image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage('assets/img/bg3.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  muscleName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontFamily: "Poppins",
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 12,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                      if (isSelected)
                        Shadow(
                          color: AppColors.primary.withOpacity(0.6),
                          offset: Offset(0, 0),
                          blurRadius: 8,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Dark overlay - darker when not selected
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.black.withOpacity(0.2)
                      : Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            // Glow effect overlay when selected
            if (isSelected)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withOpacity(0.15),
                        Colors.transparent,
                        AppColors.secondary.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
