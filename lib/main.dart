import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/models/hive_registry.dart';
import 'core/models/exercise_model.dart';
import 'core/models/workout_day_model.dart';
import 'core/models/workout_plan_model.dart';
import 'core/models/challenge_model.dart';
import 'core/models/user_profile_model.dart';
import 'core/models/exercise_log_model.dart';
import 'core/models/muscle_group_model.dart';
import 'core/models/body_part_model.dart';
import 'core/widgets/loading_page.dart';
import 'features/exercises/data/bloc/exercise_bloc.dart';
import 'features/workoutplans/data/bloc/workout_plan_bloc.dart';
import 'features/challanges/data/bloc/challenge_bloc.dart';
import 'features/profile/data/bloc/profile_bloc.dart';

void main() async {
  await Hive.initFlutter();
  // Register all Hive adapters
  await initializeHiveAdapters();
  // Open all Hive boxes with proper types
  await Hive.openBox<ExerciseModel>(HiveBoxes.exercises);
  await Hive.openBox<WorkoutPlanModel>(HiveBoxes.workoutPlans);
  await Hive.openBox<WorkoutDayModel>(HiveBoxes.workoutDays);
  await Hive.openBox<ChallengeModel>(HiveBoxes.challenges);
  await Hive.openBox<UserProfileModel>(HiveBoxes.userProfile);
  await Hive.openBox<ExerciseLogModel>(HiveBoxes.exerciseLogs);
  await Hive.openBox<MuscleGroupModel>(HiveBoxes.muscleGroups);
  await Hive.openBox<BodyPartModel>(HiveBoxes.bodyParts);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ExerciseBloc()),
        BlocProvider(create: (context) => WorkoutPlanBloc()),
        BlocProvider(create: (context) => ChallengeBloc()),
        BlocProvider(create: (context) => ProfileBloc()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LoadingPage(),
      ),
    );
  }
}
