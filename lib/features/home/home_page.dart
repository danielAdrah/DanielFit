// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/gradient_divider.dart';
import '../../core/widgets/section_tile.dart';
import '../../core/widgets/tab_chip.dart';
import '../challanges/pages/challanges_view.dart';
import '../exercises/pages/exercises_view.dart';
import '../favoriteExercises/pages/favorite_Exercise_View.dart';
import '../workoutplans/pages/workout_plans_view.dart';
import '../profile/data/bloc/profile_bloc.dart';
import '../profile/data/bloc/profile_event.dart';
import '../profile/data/bloc/profile_state.dart';
import 'challenge_card.dart';
import 'favorite_exe_header.dart';
import 'favorite_exe_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> titles = [
    "Exercises",
    "Workout Plans",
    "Favorite Exercises",
    "Challanges",
  ];
  List<String> imgs = [
    "assets/img/excersicestab.png",
    "assets/img/trainingplans.png",
    "assets/img/favoriteworkout.png",
    "assets/img/challangetab.png",
  ];

  final String challangeValue = "11";
  final String challangeName = "Pull-ups : 15 times";

  @override
  void initState() {
    super.initState();
    // Load statistics when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(const LoadProfileStatisticsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return AppBackground(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  CustomAppBar(),
                  SizedBox(height: height * 0.04),
                  //statistaics tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        // Default values for loading or error states
                        int exercisesCount = 0;
                        int favoritesCount = 0;
                        int plansCount = 0;
                        int challengesCount = 0;

                        if (state is ProfileStatisticsLoaded) {
                          exercisesCount = state.totalExercises;
                          favoritesCount = state.totalFavorites;
                          plansCount = state.totalPlans;
                          challengesCount = state.totalChallenges;
                        }

                        return ZoomIn(
                          delay: Duration(milliseconds: 500),
                          child: Row(
                            children: [
                              TabChip(
                                imgUrl: "assets/img/dumbell.png",
                                title: "Exercises",
                                number: exercisesCount.toString(),
                              ),
                              TabChip(
                                imgUrl: "assets/img/list.png",
                                title: "Workouts",
                                number: plansCount.toString(),
                              ),
                              TabChip(
                                imgUrl: "assets/img/fav.png",
                                title: "Favorite",
                                number: favoritesCount.toString(),
                              ),
                              TabChip(
                                imgUrl: "assets/img/dart.png",
                                title: "Challanges",
                                number: challengesCount.toString(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  GradientDivider(width: width * 0.9),
                  SizedBox(height: 20),
                  //main tabs section
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    width: width,
                    height: height * 0.4,
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 items per row
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.2, // Slightly taller than wide
                      ),
                      itemCount: titles.length,
                      itemBuilder: (context, index) {
                        if (index % 2 == 0) {
                          return FadeInLeft(
                            delay: Duration(milliseconds: 600),
                            child: SectionTile(
                              imgUrl: imgs[index],
                              title: titles[index],
                              onTap: () {
                                if (index == 0) {
                                  Get.to(() => ExercisesView());
                                }
                                if (index == 2) {
                                  Get.to(() => FavoriteExerciseView());
                                }
                              },
                            ),
                          );
                        } else {
                          return FadeInRight(
                            delay: Duration(milliseconds: 600),
                            child: SectionTile(
                              imgUrl: imgs[index],
                              title: titles[index],
                              onTap: () {
                                if (index == 1) {
                                  Get.to(() => WorkoutPlans());
                                }
                                if (index == 3) {
                                  Get.to(() => ChallangesView());
                                }
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  GradientDivider(width: width * 0.9),
                  SizedBox(height: height * 0.01),
                  //header title
                  FavoriteExercisesHeader(
                    onTap: () {
                      Get.to(() => FavoriteExerciseView());
                    },
                  ),
                  SizedBox(height: height * 0.01),
                  GradientDivider(width: width * 0.9),
                  SizedBox(height: height * 0.01),
                  FavoriteExeTile(title: "Squat"),
                  FavoriteExeTile(title: "Laterial Raises"),
                  FavoriteExeTile(title: "Dumbell Rows"),
                  SizedBox(height: height * 0.01),
                  GradientDivider(width: width * 0.9),
                  SizedBox(height: height * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CurrentChallengeCard(
                      width: width,
                      height: height,
                      challangeName: challangeName,
                      challangeValue: challangeValue,
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
