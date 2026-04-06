// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class StatusCard extends StatefulWidget {
  const StatusCard({
    super.key,
    required this.width,
    required this.height,
    required this.label,
    required this.value,
    required this.iconOverlay,
  });

  final double width;
  final double height;
  final String label;
  final String value;
  final String iconOverlay;

  @override
  State<StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends State<StatusCard>
    with SingleTickerProviderStateMixin {
  bool isPressed = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              width: widget.width * 0.4,
              height: widget.height * 0.06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isPressed
                      ? AppColors.glowRed.withOpacity(0.3)
                      : AppColors.metalLight.withOpacity(0.6),
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
                  isPressed
                      ? BoxShadow(
                          color: AppColors.glowRed,
                          blurRadius: 10,
                          offset: Offset(0, -3),
                          spreadRadius: 2,
                        )
                      : BoxShadow(
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
                        widget.label,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                          fontSize: isPressed ? 18 : 16,
                          shadows: [
                            BoxShadow(
                              color: isPressed
                                  ? AppColors.glowRed.withOpacity(0.5)
                                  : Colors.black,
                              blurRadius: isPressed ? 20 : 15,
                              offset: Offset(0, isPressed ? 8 : 8),
                              spreadRadius: isPressed ? 2 : -3,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.8),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 1),
                    ],
                  ),
                  Text(
                    widget.value,
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
                width: widget.width * 0.4,
                height: widget.height * 0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),

            //for the red neon effect
            Positioned(
              bottom: widget.height * 0.014,
              left: widget.width * 0.02,
              child: Container(
                // alignment: Alignment.bottomLeft,
                // margin: EdgeInsets.symmetric(horizontal: width * 0.2),
                height: 1.5,
                width: widget.width * 0.1,
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

            // Shimmer effect overlay
            if (isPressed)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            // Icon overlay on press
            Positioned(
              top: -12,
              right: 8,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: isPressed ? 1.0 : 0.0,
                child: AnimatedScale(
                  scale: isPressed ? 0.9 : 0.5,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.glowRed.withOpacity(0.8),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.glowRed.withOpacity(0.6),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      widget.iconOverlay,
                      width: 20,
                      height: 20,
                    ),
                    // Icon(
                    //   Icons.fitness_center,
                    //   size: 16,
                    //   color: Colors.white,
                    // ),
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
