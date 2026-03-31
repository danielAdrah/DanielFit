// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../theme.dart';

class TabChip extends StatelessWidget {
  const TabChip({
    super.key,
    required this.imgUrl,
    required this.title,
    required this.number,
  });

  final String title;
  final String imgUrl;
  final String number;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.4,
      margin: EdgeInsets.symmetric(horizontal: 3),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                //   colors: [
                //     Colors.white.withOpacity(0.08),
                //     Colors.white.withOpacity(0.03),
                //     Colors.black.withOpacity(0.05),
                //   ],
                //   stops: [0.0, 0.5, 1.0],
                // ),
                border: Border.all(
                  color: AppColors.metalLight.withOpacity(0.4),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, -2),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Image.asset(imgUrl, width: 20, height: 20),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: Offset(0, 2),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 3),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.metalLight.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        number,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
