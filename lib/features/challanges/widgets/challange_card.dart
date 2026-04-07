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
  bool _isFocused = false;

  @override
  void initState() {
    progressedValue = TextEditingController(
      text: widget.challenge.currentValue.toString(),
    );
    super.initState();
  }

  @override
  void didUpdateWidget(ChallangeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the text controller when the challenge prop changes
    if (oldWidget.challenge.currentValue != widget.challenge.currentValue) {
      progressedValue.text = widget.challenge.currentValue.toString();
    }
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
          key: ValueKey(
            '${widget.challenge.id}_${widget.challenge.currentValue}',
          ),
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
                            "${widget.challenge.currentValue.toInt()} / ${widget.challenge.targetValue.toInt()}",
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
                            child:
                                //  LinearProgressBar(
                                //   maxSteps: 100,
                                //   progressType: ProgressType.linear,
                                //   currentStep: 5,
                                //   progressColor: Colors.blue,
                                //   backgroundColor: Colors.grey.shade300,
                                //   animateProgress: true,
                                //   animationDuration: Duration(milliseconds: 500),
                                //   animationCurve: Curves.easeInOut,
                                // ),
                                LinearProgressIndicator(
                                  backgroundColor: AppColors.cardBorder,
                                  color: isDone
                                      ? Colors.green
                                      : AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                  trackGap: 3,
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
                          // Enhanced weight input with modern design
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            padding: EdgeInsets.symmetric(
                              horizontal: 2,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _isFocused
                                    ? [
                                        AppColors.primary,
                                        AppColors.secondary,
                                        AppColors.primary,
                                      ]
                                    : [
                                        AppColors.metalLight.withOpacity(0.5),
                                        AppColors.metalDark.withOpacity(0.5),
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: _isFocused
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(
                                          0.4,
                                        ),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.fitness_center,
                                    size: 16,
                                    color: _isFocused
                                        ? AppColors.primary
                                        : AppColors.textSecondary.withOpacity(
                                            0.7,
                                          ),
                                  ),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: TextField(
                                      controller: progressedValue,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      onTap: () {
                                        setState(() => _isFocused = true);
                                      },
                                      onEditingComplete: () {
                                        setState(() => _isFocused = false);
                                        _updateProgressFromText();
                                      },
                                      onSubmitted: (_) {
                                        setState(() => _isFocused = false);
                                        _updateProgressFromText();
                                      },
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat',
                                      ),
                                      cursorColor: AppColors.primary,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none,
                                        hintText: '0',
                                        hintStyle: TextStyle(
                                          color: AppColors.textSecondary
                                              .withOpacity(0.3),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          // Enhanced separator and target display
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isDone
                                    ? [
                                        Colors.green.withOpacity(0.2),
                                        Colors.green.withOpacity(0.1),
                                      ]
                                    : [
                                        AppColors.metalLight.withOpacity(0.3),
                                        AppColors.metalDark.withOpacity(0.2),
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isDone
                                    ? Colors.green.withOpacity(0.4)
                                    : AppColors.metalLight.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Target',
                                  style: TextStyle(
                                    color: isDone
                                        ? Colors.green
                                        : AppColors.textSecondary.withOpacity(
                                            0.7,
                                          ),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Montserrat',
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.track_changes,
                                      size: 12,
                                      color: isDone
                                          ? Colors.green
                                          : AppColors.textPrimary,
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      challenge.targetValue.toString(),
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          // Progress percentage indicator
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isDone
                                    ? [
                                        Colors.green,
                                        Colors.green.withOpacity(0.6),
                                      ]
                                    : [AppColors.primary, AppColors.secondary],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isDone
                                      ? Colors.green.withOpacity(0.3)
                                      : AppColors.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Text(
                              '${((challenge.currentValue / challenge.targetValue) * 100).clamp(0, 100).toInt()}%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
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
