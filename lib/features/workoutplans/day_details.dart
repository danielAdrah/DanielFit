// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/gearless_app_bar.dart';
import 'widgets/exercise_detail_card.dart';

class DayDetails extends StatefulWidget {
  const DayDetails({super.key, required this.dayTitle});
  final String dayTitle;

  @override
  State<DayDetails> createState() => _DayDetailsState();
}

class _DayDetailsState extends State<DayDetails> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return AppBackground(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,

          body: CustomScrollView(
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
              SliverToBoxAdapter(child: dayTitleSection()),
              SliverPadding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(childCount: 10, (
                    context,
                    index,
                  ) {
                    return FadeInLeft(
                      delay: Duration(milliseconds: 600),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: ExerciseDetaisCard(
                          order: "${index + 1}",
                          targetedMuscle: "Chest Exercise",
                          trainingName: "Incline Dumbell Press",
                          imgUrl: "assets/img/chest1.png",
                          width: width,
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
          //       SizedBox(height: height * 0.07),
          //       SizedBox(
          //         width: width,
          //         height: height,
          //         child: ListView.separated(
          //           shrinkWrap: true,
          //           physics: NeverScrollableScrollPhysics(),
          //           itemCount: 2,
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
    );
  }

  FadeInLeft dayTitleSection() {
    return FadeInLeft(
      delay: Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          children: [
            Text(
              widget.dayTitle,
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
