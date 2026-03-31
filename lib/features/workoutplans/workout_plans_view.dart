// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/gearless_app_bar.dart';
import 'add_workout_plan.dart';
import 'plan_detail.dart';

class WorkoutPlans extends StatefulWidget {
  const WorkoutPlans({super.key});

  @override
  State<WorkoutPlans> createState() => _WorkoutPlansState();
}

class _WorkoutPlansState extends State<WorkoutPlans> {
  final String exeNumber = "4";
  List data = [
    {
      "name": " Split",
      "days": "5",
      "number": "first plan",
      "combo": ["back/bie", "chest/tri", "legs/shoulders"],
    },
    {
      "name": " Split2",
      "days": "5",
      "number": "first plan",
      "combo": ["back/bie", "chest/tri", "legs/shoulders", "abs", "cardio"],
    },
    {
      "name": " Split",
      "days": "5",
      "number": "first plan",
      "combo": ["back/bie", "chest/tri", "legs/shoulders", "abs"],
    },
  ];

  // Calculate dynamic height based on number of combo items
  double _calculateCardHeight(int comboCount, double height) {
    // Base height components (fixed)
    const double basePadding = 20.0; // vertical padding (10 top + 10 bottom)
    const double titleRowHeight = 22.0; // approximate height for title row
    const double daysTagHeight = 36.0; // approximate height for days tag
    const double spacingAfterDays = 8.0; // height * 0.01 at typical screen
    const double comboItemHeight =
        33.0; // text (13) + two SizedBox(5) = ~33px per item

    // Calculate total height
    double totalHeight =
        basePadding + titleRowHeight + daysTagHeight + spacingAfterDays;
    totalHeight += (comboCount * comboItemHeight);

    return totalHeight;
  }

  // Get icon for muscle combination based on keywords
  String _getMuscleIcon(String combo) {
    final String lowerCombo = combo.toLowerCase();

    // Map of keywords to icons
    const keywordIcons = {
      'back': "assets/img/backlabel.png",
      'bie': "assets/img/muscle.png",
      'chest': "assets/img/chestlabel.png",
      'tri': "assets/img/muscle.png",
      'legs': "assets/img/legslabel.png",
      'shoulders': "assets/img/shoulderlabel.png",
      'abs': "assets/img/abslabel.png",
    };

    // Check for each keyword in the combo string
    for (final entry in keywordIcons.entries) {
      if (lowerCombo.contains(entry.key)) {
        return entry.value;
      }
    }

    // Default icon if no keyword matches
    return "assets/img/muscle.png";
  }

  // Get color for muscle group
  // Color _getMuscleColor(String combo) {
  //   final String lowerCombo = combo.toLowerCase();

  //   if (lowerCombo.contains('back') || lowerCombo.contains('bie')) {
  //     return AppColors.primary;
  //   } else if (lowerCombo.contains('chest') || lowerCombo.contains('tri')) {
  //     return AppColors.glowRed;
  //   } else if (lowerCombo.contains('legs')) {
  //     return Colors.orange;
  //   } else if (lowerCombo.contains('shoulders')) {
  //     return Colors.purple;
  //   } else if (lowerCombo.contains('abs')) {
  //     return Colors.teal;
  //   } else if (lowerCombo.contains('cardio')) {
  //     return Colors.red;
  //   }

  //   return AppColors.textPrimary;
  // }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return AppBackground(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FadeInRight(
            delay: Duration(milliseconds: 700),
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              onPressed: () {
                Get.to(() => AddWorkoutPlan());
              },
              child: Stack(
                children: [
                  Container(
                    // width: 100,
                    // height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
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
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 6,
                          offset: Offset(0, -3),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      // width: 100,
                      // height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          body: Center(
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  stretch: true,
                  expandedHeight: width * 0.25,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: GearlessAppBar(width: width),
                  ),
                ),
                SliverToBoxAdapter(child: titleSection()),
                SliverPadding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(childCount: data.length, (
                      context,
                      index,
                    ) {
                      return FadeInLeft(
                        delay: Duration(milliseconds: 600),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            Get.to(
                              () => PlanDetail(planTitle: data[index]['name']),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: width,
                                  height: _calculateCardHeight(
                                    data[index]['combo'].length,
                                    height,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: AppColors.metalLight.withOpacity(
                                        0.8,
                                      ),
                                      width: 2,
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
                                        color: Colors.white.withOpacity(0.1),
                                        blurRadius: 6,
                                        offset: Offset(0, -3),
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            data[index]['name'],
                                            style: TextStyle(
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Montserrat",
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(width: 3),
                                          Text(
                                            "(${data[index]['number']})",
                                            style: TextStyle(
                                              color: AppColors.textSecondary,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Montserrat",
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: height * 0.01),
                                      DaysTag(
                                        width: width,
                                        height: height,
                                        days: "${data[index]['days']} Days",
                                      ),

                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: data[index]['combo'].length,
                                        itemBuilder: (context, i) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  // Icon(
                                                  //   _getMuscleIcon(
                                                  //     data[index]['combo'][i],
                                                  //   ),
                                                  //   color: _getMuscleColor(
                                                  //     data[index]['combo'][i],
                                                  //   ),
                                                  //   size: 18,
                                                  // ),
                                                  Image.asset(
                                                    _getMuscleIcon(
                                                      data[index]['combo'][i],
                                                    ),
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    data[index]['combo'][i],
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.textPrimary,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "Montserrat",
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                //container acted as a bar for the pull ups , only displayed with the exe3 image
                                data[index]['combo'].length >= 5
                                    ? Positioned(
                                        right: width * 0.07,
                                        top: height * 0.055,
                                        child: Container(
                                          width: width * 0.4,
                                          height: 3,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.6,
                                                ),
                                                blurRadius: 10,
                                                offset: Offset(0, 5),
                                                spreadRadius: 0,
                                              ),
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.3,
                                                ),
                                                blurRadius: 15,
                                                offset: Offset(0, 8),
                                                spreadRadius: -3,
                                              ),
                                              BoxShadow(
                                                color: Colors.white.withOpacity(
                                                  0.1,
                                                ),
                                                blurRadius: 6,
                                                offset: Offset(0, -3),
                                                spreadRadius: 0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                                //person bg overlay
                                Positioned(
                                  right: 5,
                                  top:
                                      _calculateCardHeight(
                                            data[index]['combo'].length,
                                            height,
                                          ) /
                                          2 -
                                      (height * 0.22) / 2,
                                  child: data[index]['combo'].length >= 5
                                      ? SizedBox(
                                          height: height * 0.3,
                                          width: width * 0.5,
                                          child: Image.asset(
                                            "assets/img/exe3.png",
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : SizedBox(
                                          height: height * 0.25,
                                          width: width * 0.7,
                                          child: Image.asset(
                                            "assets/img/exe1.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),

                                //for the dark overlay
                                Positioned.fill(
                                  child: Container(
                                    // width: width,
                                    // height: 60,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ),
                                ),
                                //for the red neon effect
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: width * 0.08,
                                  ),
                                  height: 1.7,
                                  width: width * 0.9,
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
                                        color: AppColors.glowRed,
                                        blurRadius: 10,
                                        offset: Offset(8, -1),
                                        spreadRadius: 0.5,
                                      ),
                                      // BoxShadow(
                                      //   color: Colors.red,
                                      //   blurRadius: 5,
                                      //   offset: Offset(2, -1),
                                      //   spreadRadius: 3,
                                      // ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 1,
                                  right: width / 12,
                                  left: width / 12,
                                  child: Container(
                                    // margin: EdgeInsets.symmetric(
                                    //   horizontal: width * 0.09,
                                    // ),
                                    height: 1.7,
                                    width: width * 0.5,
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
                                        // BoxShadow(
                                        //   color: AppColors.glowRed,
                                        //   blurRadius: 5,
                                        //   offset: Offset(8, -1),
                                        //   spreadRadius: 3,
                                        // ),
                                        BoxShadow(
                                          color: Colors.red,
                                          blurRadius: 10,
                                          offset: Offset(2, -1),
                                          spreadRadius: 0.5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),

            // SingleChildScrollView(
            //   child: Column(
            //     children: [
            //       GearlessAppBar(width: width),
            //       SizedBox(height: height * 0.05),

            //       SizedBox(height: height * 0.03),

            //       SizedBox(
            //         width: width,
            //         height: height,
            //         child: ListView.separated(
            //           shrinkWrap: true,
            //           physics: NeverScrollableScrollPhysics(),
            //           itemCount: data.length,
            //           separatorBuilder: (context, index) {
            //             return SizedBox(height: height * 0.023);
            //           },
            //           itemBuilder: (context, index) {

            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ),
        ),
      ),
    );
  }

  FadeInLeft titleSection() {
    return FadeInLeft(
      delay: Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          children: [
            Image.asset("assets/img/list.png", width: 25, height: 25),
            const SizedBox(width: 5),
            Text(
              "Workout Plans",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontFamily: "Arvo",
                fontSize: 22,
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
          ],
        ),
      ),
    );
  }
}

class DaysTag extends StatelessWidget {
  const DaysTag({
    super.key,
    required this.width,
    required this.height,
    required this.days,
  });

  final double width;
  final double height;
  final String days;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.2,
      height: height * 0.04,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          days,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: "Montserrat",
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
