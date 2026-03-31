// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import 'small_circular_btn.dart';

class ChallangeCard extends StatefulWidget {
  ChallangeCard({
    super.key,
    required this.width,
    required this.challangeTitle,
    required this.challangeDescription,
    required this.progressValue,
    required this.targetValue,
    required this.type,
    required this.isDone,
    this.increase,
    this.decrease,
    this.complete,
  });
  final bool isDone;
  final String type;
  final double width;
  final String challangeTitle;
  final String challangeDescription;
  final String progressValue;
  final String targetValue;
  void Function()? increase;
  void Function()? decrease;
  void Function()? complete;

  @override
  State<ChallangeCard> createState() => _ChallangeCardState();
}

class _ChallangeCardState extends State<ChallangeCard> {
  final progressedValue = TextEditingController();

  @override
  void initState() {
    progressedValue.text = widget.progressValue;
    super.initState();
  }

  @override
  void dispose() {
    progressedValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        //main container
        Container(
          width: widget.width,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.challangeTitle,
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
                SizedBox(height: 5),
                Text(
                  widget.challangeDescription,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
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
                SizedBox(height: 3),
                if (widget.type == "reps")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${widget.progressValue} / ${widget.targetValue}",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(width: 3),
                          SizedBox(
                            height: 6,
                            width: 200,
                            child: LinearProgressIndicator(
                              backgroundColor: AppColors.cardBorder,
                              color: widget.isDone
                                  ? Colors.green
                                  : AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                              value: 2,
                            ),
                          ),
                        ],
                      ),

                      widget.isDone
                          ? SmallCircluarBtn(
                              colors: [
                                Colors.green,
                                Colors.green.withOpacity(0.3),
                              ],
                              icon: Icons.done_outline_rounded,
                              onTap: () {},
                            )
                          : Row(
                              children: [
                                SmallCircluarBtn(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.secondary,
                                  ],
                                  icon: Icons.add,
                                  onTap: widget.increase,
                                ),
                                SizedBox(width: 5),
                                SmallCircluarBtn(
                                  colors: [
                                    AppColors.metalLight,
                                    AppColors.metalDark,
                                  ],
                                  icon: Icons.remove,
                                  onTap: widget.decrease,
                                ),
                              ],
                            ),
                    ],
                  ),
                if (widget.type == "weight")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          //the progress value which i can change by typing into the text field
                          SizedBox(
                            width: widget.width * 0.1,
                            child: TextField(
                              controller: progressedValue,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                              ),
                              cursorColor: AppColors.textPrimary,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 15),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Text(
                            "/",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: 2),
                          Text(
                            widget.targetValue,
                            style: TextStyle(
                              color: AppColors.textPrimary,

                              fontWeight: FontWeight.w400,
                              fontSize: 15.5,
                            ),
                          ),
                        ],
                      ),
                      SmallCircluarBtn(
                        colors: widget.isDone
                            ? [Colors.green, Colors.green.withOpacity(0.3)]
                            : [AppColors.primary, AppColors.secondary],
                        icon: widget.isDone ? Icons.alarm_on_sharp : Icons.done,
                        onTap: widget.isDone ? () {} : widget.complete,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        //for the dark overlay
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              // width: width,
              // height: 60,
              margin: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.35),
              ),
            ),
          ),
        ),
        //for the red neon effect
        IgnorePointer(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: widget.width * 0.08),
            height: 1.7,
            width: widget.width * 0.8,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.isDone
                    ? [
                        Colors.green.withOpacity(0.2),
                        Colors.green,
                        Colors.green.withOpacity(0.2),
                      ]
                    : [
                        AppColors.glowRed.withOpacity(0.1),
                        AppColors.glowRed,
                        AppColors.glowRed.withOpacity(0.1),
                      ],
              ),

              boxShadow: [
                BoxShadow(
                  color: widget.isDone ? Colors.green : AppColors.glowRed,
                  blurRadius: 10,
                  offset: Offset(8, -1),
                  spreadRadius: 0.5,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 1,
          right: widget.width / 4.8,
          left: widget.width / 8,
          child: IgnorePointer(
            child: Container(
              // margin: EdgeInsets.symmetric(
              //   horizontal: width * 2,
              // ),
              height: 1.7,
              width: widget.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.isDone
                      ? [
                          Colors.green.withOpacity(0.2),
                          Colors.green,
                          Colors.green.withOpacity(0.2),
                        ]
                      : [
                          AppColors.glowRed.withOpacity(0.1),
                          AppColors.glowRed,
                          AppColors.glowRed.withOpacity(0.1),
                        ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.isDone ? Colors.green : AppColors.glowRed,
                    blurRadius: 10,
                    offset: Offset(8, -1),
                    spreadRadius: 0.5,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
