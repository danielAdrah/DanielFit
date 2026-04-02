// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/models/challenge_model.dart';
import '../../../core/widgets/helper.dart';
import 'small_circular_btn.dart';

class ChallangeCard extends StatefulWidget {
  ChallangeCard({
    super.key,
    required this.challenge,
    this.onUpdateProgress,
    this.onComplete,
  });

  final ChallengeModel challenge;
  final Function(double)? onUpdateProgress;
  final VoidCallback? onComplete;

  @override
  State<ChallangeCard> createState() => _ChallangeCardState();
}

class _ChallangeCardState extends State<ChallangeCard> {
  late TextEditingController progressedValue;

  @override
  void initState() {
    progressedValue = TextEditingController(
      text: widget.challenge.currentValue.toString(),
    );
    super.initState();
  }

  @override
  void dispose() {
    progressedValue.dispose();
    super.dispose();
  }

  void _incrementProgress() {
    final newValue = widget.challenge.currentValue + 1;
    if (widget.onUpdateProgress != null) {
      widget.onUpdateProgress!(newValue);
    }
  }

  void _decrementProgress() {
    if (widget.challenge.currentValue > 0) {
      final newValue = widget.challenge.currentValue - 1;
      if (widget.onUpdateProgress != null) {
        widget.onUpdateProgress!(newValue);
      }
    }
  }

  void _updateProgressFromText() {
    final newValue = double.tryParse(progressedValue.text);
    if (newValue != null && widget.onUpdateProgress != null) {
      widget.onUpdateProgress!(newValue);
    }
  }

  void _handleComplete() {
    // Validate that progress has reached target before marking as complete
    if (widget.challenge.currentValue < widget.challenge.targetValue) {
      // Show error message - challenge cannot be marked complete yet
      Helper().showSnackBar(
        "Warning",
        ' Challenge not complete yet! You need to reach at least ${widget.challenge.targetValue.toStringAsFixed(1)} ${widget.challenge.unit} before marking this challenge as complete.',
        Colors.orange,
        Icons.warning_amber_rounded,
      );

      return;
    }

    // Progress has reached target, mark as complete
    if (widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final challenge = widget.challenge;
    final isDone = challenge.isCompleted;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        //main container
        Container(
          width: MediaQuery.of(context).size.width,
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
                  challenge.challengeName,
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
                  challenge.description,
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
                if (challenge.targetType == "Reps")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${challenge.currentValue.toInt()} / ${challenge.targetValue.toInt()}",
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
                              color: isDone ? Colors.green : AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                              value:
                                  (challenge.currentValue /
                                          challenge.targetValue)
                                      .clamp(0.0, 1.0),
                            ),
                          ),
                        ],
                      ),

                      isDone
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
                                  onTap: _incrementProgress,
                                ),
                                SizedBox(width: 5),
                                SmallCircluarBtn(
                                  colors: [
                                    AppColors.metalLight,
                                    AppColors.metalDark,
                                  ],
                                  icon: Icons.remove,
                                  onTap: _decrementProgress,
                                ),
                              ],
                            ),
                    ],
                  ),
                if (challenge.targetType == "Weight")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          //the progress value which i can change by typing into the text field
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: TextField(
                              controller: progressedValue,
                              onSubmitted: (_) => _updateProgressFromText(),
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
                            challenge.targetValue.toInt().toString(),
                            style: TextStyle(
                              color: AppColors.textPrimary,

                              fontWeight: FontWeight.w400,
                              fontSize: 15.5,
                            ),
                          ),
                        ],
                      ),
                      SmallCircluarBtn(
                        colors: isDone
                            ? [Colors.green, Colors.green.withOpacity(0.3)]
                            : [AppColors.primary, AppColors.secondary],
                        icon: isDone ? Icons.alarm_on_sharp : Icons.done,
                        onTap: isDone ? () {} : _handleComplete,
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
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.08,
            ),
            height: 1.7,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDone
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
                  color: isDone ? Colors.green : AppColors.glowRed,
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
          right: MediaQuery.of(context).size.width / 4.8,
          left: MediaQuery.of(context).size.width / 8,
          child: IgnorePointer(
            child: Container(
              // margin: EdgeInsets.symmetric(
              //   horizontal: width * 2,
              // ),
              height: 1.7,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDone
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
                    color: isDone ? Colors.green : AppColors.glowRed,
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
