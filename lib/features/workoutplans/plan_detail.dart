// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/gearless_app_bar.dart';
import 'day_details.dart';
import 'widgets/training_day_tile.dart';

class PlanDetail extends StatefulWidget {
  const PlanDetail({super.key, required this.planTitle});
  final String planTitle;
  @override
  State<PlanDetail> createState() => _PlanDetailState();
}

class _PlanDetailState extends State<PlanDetail> {
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
              SliverToBoxAdapter(child: planTitleSection()),

              SliverPadding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(childCount: 5, (
                    context,
                    index,
                  ) {
                    return FadeInLeft(
                      delay: Duration(milliseconds: 600),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Get.to(() => DayDetails(dayTitle: "Back/Bieceps"));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: TrainigDaysTille(
                            muscles: "Chest/Tricpes",
                            days: "5",
                            width: width,
                            height: height,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FadeInLeft planTitleSection() {
    return FadeInLeft(
      delay: Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          children: [
            Text(
              widget.planTitle,
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
