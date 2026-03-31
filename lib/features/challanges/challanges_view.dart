import 'package:animate_do/animate_do.dart';
import 'package:danielfit/core/widgets/app_background.dart';
import 'package:danielfit/core/widgets/gearless_app_bar.dart';
import 'package:danielfit/core/widgets/gradient_divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme.dart';
import 'add_challange.dart';
import 'widgets/challange_card.dart';

class ChallangesView extends StatefulWidget {
  const ChallangesView({super.key});

  @override
  State<ChallangesView> createState() => _ChallangesViewState();
}

class _ChallangesViewState extends State<ChallangesView> {
  final String progressValue = "11";
  final String targetValue = "15";
  final String challangeTitle = "Pull Up Challange";
  final String challangeDescription = "Do 15 Pull ups";
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
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
                Get.to(() => AddChallange());
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
              SliverToBoxAdapter(
                child: FadeInLeft(
                  delay: Duration(milliseconds: 500),
                  child: ChallangeTitleHeader(title: "Active Challanges 🔥"),
                ),
              ),
              SliverPadding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(childCount: 3, (
                    context,
                    index,
                  ) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: ChallangeCard(
                        width: width,
                        challangeTitle: challangeTitle,
                        challangeDescription: challangeDescription,
                        progressValue: progressValue,
                        targetValue: targetValue,
                        type: "reps",
                        isDone: false,
                        increase: () {},
                        decrease: () {},
                      ),
                    );
                  }),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    GradientDivider(width: width * 0.9),
                    SizedBox(height: height * 0.03),
                    FadeInLeft(
                      delay: Duration(milliseconds: 500),
                      child: ChallangeTitleHeader(title: "Completed 🤟✅"),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(childCount: 3, (
                    context,
                    index,
                  ) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: ChallangeCard(
                        width: width,
                        challangeTitle: challangeTitle,
                        challangeDescription: challangeDescription,
                        progressValue: progressValue,
                        targetValue: targetValue,
                        type: "reps",
                        isDone: true,
                        complete: () {
                          print("done");
                        },
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
}

class ChallangeTitleHeader extends StatelessWidget {
  const ChallangeTitleHeader({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          const SizedBox(width: 5),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontFamily: "Arvo",
              fontSize: 19,
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
    );
  }
}
