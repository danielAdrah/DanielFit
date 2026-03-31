import 'package:flutter/material.dart';

import '../theme.dart';

class ImageSection extends StatelessWidget {
  const ImageSection({
    super.key,
    required this.width,
    required this.height,
    required this.onTap,
    required this.img,
  });

  final double width;
  final double height;
  final void Function() onTap;
  final String img;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          //main content
          Container(
            width: width * 0.8,
            height: height * 0.2,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.metalLight, width: 1.5),
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
            child: Center(child: Image.asset(img)),
          ),
          //dark overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
            ),
          ),
          //add icon
          Positioned(
            bottom: -4,
            right: -10,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color.fromARGB(255, 231, 7, 22),
                    const Color.fromARGB(255, 180, 11, 11),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
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
                    color: AppColors.glowRed.withOpacity(0.6),
                    blurRadius: 6,
                    offset: Offset(0, -3),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
