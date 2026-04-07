// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:danielfit/core/widgets/app_background.dart';
import 'package:danielfit/core/widgets/gearless_app_bar.dart';
import 'package:danielfit/core/widgets/gradient_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../core/theme.dart';
import '../../../core/models/challenge_model.dart';
import '../../../core/widgets/helper.dart';
import '../data/bloc/challenge_bloc.dart';
import '../data/bloc/challenge_event.dart';
import '../data/bloc/challenge_state.dart';
import 'add_challange.dart';
import '../widgets/challange_card.dart';

class ChallangesView extends StatefulWidget {
  const ChallangesView({super.key});

  @override
  State<ChallangesView> createState() => _ChallangesViewState();
}

class _ChallangesViewState extends State<ChallangesView> {
  @override
  void initState() {
    super.initState();
    // Load all challenges on init
    context.read<ChallengeBloc>().add(LoadAllChallengesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => ChallengeBloc()..add(LoadAllChallengesEvent()),
      child: AppBackground(
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
            body: BlocBuilder<ChallengeBloc, ChallengeState>(
              builder: (context, state) {
                // Handle loading state
                if (state is ChallengeLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  );
                }

                // Handle error state
                if (state is ChallengeError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.withOpacity(0.7),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Error loading challenges',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          state.message,
                          style: TextStyle(
                            color: AppColors.textSecondary.withOpacity(0.7),
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                // Get challenges from state
                List<ChallengeModel> activeChallenges = [];
                List<ChallengeModel> completedChallenges = [];

                if (state is ChallengeLoaded) {
                  activeChallenges = state.challenges
                      .where((c) => !c.isCompleted)
                      .toList();
                  completedChallenges = state.challenges
                      .where((c) => c.isCompleted)
                      .toList();
                }

                return CustomScrollView(
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
                        child: ChallangeTitleHeader(
                          title: "Active Challanges 🔥",
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsetsGeometry.symmetric(vertical: 20),
                      sliver: activeChallenges.isEmpty
                          ? SliverToBoxAdapter(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: ZoomIn(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.emoji_events_outlined,
                                          size: 80,
                                          color: AppColors.textSecondary
                                              .withOpacity(0.3),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'No active challenges',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Tap the + button to create your first challenge!',
                                          style: TextStyle(
                                            color: AppColors.textSecondary
                                                .withOpacity(0.6),
                                            fontSize: 14,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                childCount: activeChallenges.length,
                                (context, index) {
                                  final challenge = activeChallenges[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 25),
                                    child: FadeInLeft(
                                      delay: Duration(
                                        milliseconds: index * 100,
                                      ),
                                      child: Dismissible(
                                        key: Key(challenge.id),
                                        direction: DismissDirection.endToStart,
                                        background: Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.7),
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.red.withOpacity(
                                                  0.4,
                                                ),
                                                blurRadius: 8,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          alignment: Alignment.centerRight,
                                          padding: EdgeInsets.only(right: 30),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons.delete_outline,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'Delete Challenge',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        confirmDismiss: (direction) async {
                                          // Show confirmation dialog
                                          return await showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    Colors.grey.shade900,
                                                title: Text(
                                                  'Delete Challenge',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "Montserrat",
                                                  ),
                                                ),
                                                content: Text(
                                                  'Are you sure you want to delete "${challenge.challengeName}"? This action cannot be undone.',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "Montserrat",
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(false),
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            "Montserrat",
                                                      ),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(true),
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                          foregroundColor:
                                                              Colors.white,
                                                        ),
                                                    child: Text('Delete'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        onDismissed: (direction) {
                                          // Delete the challenge
                                          context.read<ChallengeBloc>().add(
                                            DeleteChallengeEvent(challenge.id),
                                          );

                                          // Show success message
                                          Helper().showSnackBar(
                                            "Success",
                                            'Challenge deleted successfully!',
                                            Colors.green,
                                            Icons.done_all,
                                          );
                                        },
                                        child: ChallangeCard(
                                          key: ValueKey(
                                            '${challenge.id}_${challenge.currentValue}',
                                          ),
                                          challenge: challenge,
                                          onUpdateProgress: (newValue) {
                                            context.read<ChallengeBloc>().add(
                                              UpdateChallengeProgressEvent(
                                                challenge.id,
                                                newValue,
                                              ),
                                            );
                                          },
                                          onComplete: () {
                                            context.read<ChallengeBloc>().add(
                                              ToggleChallengeCompletionEvent(
                                                challenge.id,
                                                true,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
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
                      sliver: completedChallenges.isEmpty
                          ? SliverToBoxAdapter(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: ZoomIn(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline,
                                          size: 80,
                                          color: AppColors.textSecondary
                                              .withOpacity(0.3),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'No completed challenges yet',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Keep pushing to complete your challenges!',
                                          style: TextStyle(
                                            color: AppColors.textSecondary
                                                .withOpacity(0.6),
                                            fontSize: 14,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                childCount: completedChallenges.length,
                                (context, index) {
                                  final challenge = completedChallenges[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 25),
                                    child: FadeInLeft(
                                      delay: Duration(
                                        milliseconds: index * 100,
                                      ),
                                      child: Dismissible(
                                        key: Key(challenge.id),
                                        direction: DismissDirection.endToStart,
                                        background: Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.7),
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.red.withOpacity(
                                                  0.4,
                                                ),
                                                blurRadius: 8,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          alignment: Alignment.centerRight,
                                          padding: EdgeInsets.only(right: 30),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons.delete_outline,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'Delete Challenge',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        confirmDismiss: (direction) async {
                                          // Show confirmation dialog
                                          return await showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    Colors.grey.shade900,
                                                titleTextStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Montserrat",
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                contentTextStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily: "Montserrat",
                                                ),
                                                title: Text(
                                                  'Delete Challenge',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "Montserrat",
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content: Text(
                                                  'Are you sure you want to delete "${challenge.challengeName}"? This action cannot be undone.',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(false),
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(true),
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                          foregroundColor:
                                                              Colors.white,
                                                        ),
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        onDismissed: (direction) {
                                          // Delete the challenge
                                          context.read<ChallengeBloc>().add(
                                            DeleteChallengeEvent(challenge.id),
                                          );

                                          // Show success message
                                          Helper().showSnackBar(
                                            "Success",
                                            'Challenge deleted successfully!',
                                            Colors.green,
                                            Icons.done_all,
                                          );
                                        },
                                        child: ChallangeCard(
                                          key: ValueKey(
                                            '${challenge.id}_${challenge.currentValue}',
                                          ),
                                          challenge: challenge,
                                          onUpdateProgress: (newValue) {},
                                          onComplete: () {},
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
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
