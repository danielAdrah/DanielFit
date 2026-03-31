// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../../../core/theme.dart';

class FavoritExerciseCard extends StatefulWidget {
  const FavoritExerciseCard({
    super.key,
    required this.height,
    required this.imgUrl,
    required this.exerciseName,
    required this.width,
  });

  final double height;
  final double width;
  final String imgUrl;
  final String exerciseName;

  @override
  State<FavoritExerciseCard> createState() => _FavoritExerciseCardState();
}

class _FavoritExerciseCardState extends State<FavoritExerciseCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

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
    _glowAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  ImageProvider _getImageProvider(String url) {
    // Check if it's a file path (not an asset path)
    // Asset paths typically start with 'assets/' or don't have '/' at the start
    // File paths from image picker usually start with '/' or contain '/storage/'
    if (url.startsWith('/') ||
        url.contains('/storage/') ||
        url.contains('/data/')) {
      return FileImage(File(url));
    }
    // Default to asset image
    return AssetImage(url);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: FadeInRight(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              // Outer glow effect container
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Container(
                      margin: EdgeInsets.only(right: 5, left: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            //   color: AppColors.glowRed.withOpacity(
                            //     0.6 * _glowAnimation.value,
                            //   ),
                            blurRadius: 5 * _glowAnimation.value,
                            spreadRadius: 2 * _glowAnimation.value,
                          ),
                          BoxShadow(
                            color: AppColors.primary.withOpacity(
                              0.4 * _glowAnimation.value,
                            ),
                            blurRadius: 30 * _glowAnimation.value,
                            spreadRadius: -5,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Concrete/stony border container with neon effect
              Container(
                margin: EdgeInsets.only(right: 5, left: 10),
                padding: EdgeInsets.only(
                  left: 3,
                  right: 3,
                  top: 3,
                  bottom: widget.height * 0.04,
                ),
                width: widget.width * 0.4,
                height: widget.height * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      _isPressed
                          ? AppColors.glowRed
                          : AppColors.glowRed.withOpacity(0.3),
                      AppColors.glowRed,
                      _isPressed
                          ? AppColors.glowRed.withOpacity(0.8)
                          : AppColors.glowRed.withOpacity(0.2),
                      AppColors.glowRed.withOpacity(0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.metalDark.withOpacity(
                        _isPressed ? 0.8 : 0.4,
                      ),
                      blurRadius: _isPressed ? 25 : 15,
                      spreadRadius: _isPressed ? 3 : 1,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                // Concrete/stony texture effect
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF2A2A2A),
                        Color(0xFF1A1A1A),
                        Color(0xFF2A2A2A),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    image: DecorationImage(
                      image: _getImageProvider(widget.imgUrl),
                      fit: BoxFit.cover,

                      // colorFilter: ColorFilter.mode(
                      //   Colors.black.withOpacity(0.2),
                      //   BlendMode.darken,
                      // ),
                    ),
                    border: Border.all(
                      color: _isPressed
                          ? AppColors.glowRed.withOpacity(0.8)
                          : AppColors.glowRed.withOpacity(0.3),
                      width: _isPressed ? 2.5 : 1.5,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Shimmer effect overlay
                      if (_isPressed)
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
                    ],
                  ),
                ),
              ),
              // The exercise name with enhanced styling
              Positioned(
                bottom: 2,
                child: AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 300),
                  style: TextStyle(
                    color: _isPressed
                        ? Colors.white
                        : Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                    fontSize: _isPressed ? 15 : 14,
                    letterSpacing: _isPressed ? 0.5 : 0,
                    shadows: [
                      BoxShadow(
                        color: AppColors.glowRed.withOpacity(
                          _isPressed ? 0.8 : 0.5,
                        ),
                        blurRadius: _isPressed ? 20 : 15,
                        offset: Offset(0, _isPressed ? 8 : 8),
                        spreadRadius: _isPressed ? 2 : -3,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.8),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.exerciseName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              // Icon overlay on press
              Positioned(
                top: 8,
                right: 8,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: _isPressed ? 1.0 : 0.0,
                  child: AnimatedScale(
                    scale: _isPressed ? 1.0 : 0.5,
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
                      child: Icon(
                        Icons.fitness_center,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
