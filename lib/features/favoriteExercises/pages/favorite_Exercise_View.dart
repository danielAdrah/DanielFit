// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:danielfit/core/widgets/app_background.dart';
import 'package:danielfit/core/widgets/gearless_app_bar.dart';
import 'package:danielfit/core/widgets/gradient_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme.dart';
import '../../exercises/data/exercise_data.dart';
import '../widgets/favorite_exercise_card.dart';

class FavoriteExerciseView extends StatefulWidget {
  const FavoriteExerciseView({super.key});

  @override
  State<FavoriteExerciseView> createState() => _FavoriteExerciseViewState();
}

class _FavoriteExerciseViewState extends State<FavoriteExerciseView> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (_) => ExerciseBloc()..add(const GetFavoriteExercisesEvent()),
      child: AppBackground(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  stretch: true,
                  expandedHeight: width * 0.27,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: GearlessAppBar(width: width),
                  ),
                ),
                // Favorites Section
                SliverToBoxAdapter(
                  child: FadeInDown(
                    duration: Duration(milliseconds: 800),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              FadeInLeft(
                                delay: Duration(milliseconds: 500),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.04,
                                    vertical: height * 0.005,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.glowRed.withOpacity(0.2),
                                        AppColors.primary.withOpacity(0.1),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: AppColors.glowRed.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.glowRed.withOpacity(
                                          0.2,
                                        ),
                                        blurRadius: 15,
                                        spreadRadius: -3,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Pulse(
                                        infinite: true,
                                        duration: Duration(seconds: 2),
                                        child: Image.asset(
                                          "assets/img/fav.png",
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Favorite Exercises ",
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Montserrat",
                                          fontSize: 16,
                                          letterSpacing: 1.2,
                                          shadows: [
                                            BoxShadow(
                                              color: AppColors.glowRed
                                                  .withOpacity(0.6),
                                              blurRadius: 20,
                                              offset: Offset(0, 8),
                                              spreadRadius: -3,
                                            ),
                                            BoxShadow(
                                              color: Colors.black,
                                              blurRadius: 10,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.025),
                        GradientDivider(width: width * 0.9),
                        SizedBox(height: height * 0.025),
                      ],
                    ),
                  ),
                ),
                // Favorite exercises list
                SliverToBoxAdapter(
                  child: BlocBuilder<ExerciseBloc, ExerciseState>(
                    builder: (context, state) {
                      if (state is ExerciseLoading) {
                        return SizedBox(
                          width: width,
                          height: height * 0.25,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          ),
                        );
                      }

                      if (state is ExerciseLoaded) {
                        final favoriteExercises = state.exercises;

                        if (favoriteExercises.isEmpty) {
                          return SizedBox(
                            width: width,
                            height: height * 0.25,
                            child: Center(
                              child: ZoomIn(
                                child: Container(
                                  padding: EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Pulse(
                                        infinite: true,
                                        duration: Duration(seconds: 2),
                                        child: Icon(
                                          Icons.favorite_border,
                                          size: 56,
                                          color: AppColors.glowRed.withOpacity(
                                            0.6,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'No favorite exercises yet',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Start adding exercises you love!',
                                        style: TextStyle(
                                          color: AppColors.textSecondary
                                              .withOpacity(0.7),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        return SizedBox(
                          width: width,
                          height: height * 0.25,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemCount: favoriteExercises.length,
                            itemBuilder: (context, index) {
                              final exercise = favoriteExercises[index];
                              return FadeInLeft(
                                delay: Duration(milliseconds: index * 150),
                                child: FavoritExerciseCard(
                                  imgUrl:
                                      exercise.imagePath ??
                                      "assets/img/favexe.png",
                                  exerciseName: exercise.name,
                                  height: height,
                                  width: width,
                                ),
                              );
                            },
                          ),
                        );
                      }

                      if (state is ExerciseError) {
                        return SizedBox(
                          width: width,
                          height: height * 0.25,
                          child: Center(
                            child: Text(
                              'Error loading favorites',
                              style: TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          ),
                        );
                      }

                      return SizedBox(
                        width: width,
                        height: height * 0.25,
                        child: Center(
                          child: Text(
                            'No data available',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.025),
                      GradientDivider(width: width * 0.9),
                      SizedBox(height: height * 0.025),
                      FadeInDown(
                        duration: Duration(milliseconds: 800),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FadeInLeft(
                                delay: Duration(milliseconds: 500),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                    vertical: height * 0.002,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF4A4A4A).withOpacity(0.3),
                                        Colors.grey.withOpacity(0.1),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.4),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 15,
                                        spreadRadius: -3,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Tada(
                                        infinite: true,
                                        duration: Duration(seconds: 2),
                                        child: Text(
                                          "😡",
                                          style: TextStyle(
                                            fontSize: 20,
                                            shadows: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.5,
                                                ),
                                                blurRadius: 10,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Hated Exercises ",
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Montserrat",
                                          fontSize: 15,
                                          letterSpacing: 1.2,
                                          shadows: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                0.5,
                                              ),
                                              blurRadius: 20,
                                              offset: Offset(0, 8),
                                              spreadRadius: -3,
                                            ),
                                            BoxShadow(
                                              color: Colors.black,
                                              blurRadius: 10,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Hated exercises list - using separate BLoC instance
                SliverToBoxAdapter(
                  child: BlocProvider(
                    create: (_) =>
                        ExerciseBloc()..add(const GetHatedExercisesEvent()),
                    child: BlocBuilder<ExerciseBloc, ExerciseState>(
                      builder: (context, state) {
                        if (state is ExerciseLoading) {
                          return SizedBox(
                            width: width,
                            height: height * 0.25,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                          );
                        }

                        if (state is ExerciseLoaded) {
                          final hatedExercises = state.exercises;

                          if (hatedExercises.isEmpty) {
                            return SizedBox(
                              width: width,
                              height: height * 0.28,
                              child: Center(
                                child: ZoomIn(
                                  child: Container(
                                    padding: EdgeInsets.all(30),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.transparent,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        RubberBand(
                                          child: Icon(
                                            Icons.sentiment_very_dissatisfied,
                                            size: 56,
                                            color: Colors.grey.withOpacity(0.6),
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          'No hated exercises yet',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          'Keep your workouts hate-free!',
                                          style: TextStyle(
                                            color: AppColors.textSecondary
                                                .withOpacity(0.7),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: width,
                              height: height * 0.25,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemCount: hatedExercises.length,
                                itemBuilder: (context, index) {
                                  final exercise = hatedExercises[index];
                                  return FadeInRight(
                                    delay: Duration(milliseconds: index * 150),
                                    child: FavoritExerciseCard(
                                      imgUrl:
                                          exercise.imagePath ??
                                          "assets/img/chestworkout.png",
                                      exerciseName: exercise.name,
                                      height: height,
                                      width: width,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }

                        if (state is ExerciseError) {
                          return SizedBox(
                            width: width,
                            height: height * 0.25,
                            child: Center(
                              child: Text(
                                'Error loading hated exercises',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }

                        return SizedBox(
                          width: width,
                          height: height * 0.25,
                          child: Center(
                            child: Text(
                              'No data available',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
