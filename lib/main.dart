import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker_app/databases/drift/app_database.dart';
import 'package:gym_tracker_app/features/exercises/data_layer/exercises_repository.dart';
import 'package:gym_tracker_app/features/exercises/ui_layer/views_models/exercise_main_screen_vm.dart';
import 'package:gym_tracker_app/features/auth/ui_layer/views/login_sign_in_v/login_sign_in_page_v.dart';
import 'package:gym_tracker_app/features/exercises/ui_layer/views_models/exercise_detail_screen_vm.dart';

void main() {
  debugPaintSizeEnabled = false;

  final db = AppDatabase();
  final exerciseRepository = ExerciseRepository(db);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>(create: (_) => db),
        Provider<ExerciseRepository>(create: (_) => exerciseRepository),
        ChangeNotifierProvider<ExerciseMainScreenVm>(
          create: (_) => ExerciseMainScreenVm(exerciseRepository),
        ),
        ChangeNotifierProvider<ExerciseDetailScreenVm>(
          create: (_) => ExerciseDetailScreenVm(exerciseRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 219, 194, 66),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 34, 39, 42),
        ),
      ),
      home: const MainLoginScreen(),
    );
  }
}