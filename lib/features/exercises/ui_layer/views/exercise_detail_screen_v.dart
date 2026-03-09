import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/exercises/data_layer/models/exercise_detail.dart'; 

class ExerciseDetailScreenV extends StatefulWidget {
  final ExerciseDetail loadedExercise;
  const ExerciseDetailScreenV({super.key, required this.loadedExercise});

  @override
  State<ExerciseDetailScreenV> createState() => _ExerciseDetailScreenV();
}

class _ExerciseDetailScreenV extends State<ExerciseDetailScreenV> {
  @override
    @override
  Widget build(BuildContext context) {
    return DefaultTabController(
  length: 4, // number of tabs
  child: Scaffold(
    appBar: AppBar(
      bottom: TabBar(
        tabs: [
          Tab(text: 'About'),
          Tab(text: 'History'),
          Tab(text: 'Charts'),
          Tab(text: 'Records'),
        ],
      ),
    ),
    body: TabBarView(
      children: [
        AboutTab(),
        HistoryTab(),
        ChartsTab(),
        RecordsTab(),
      ],
    ),
  ),
)
  }
}
