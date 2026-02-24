import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker_app/features/exercises/ui_layer/views_models/exercise_main_screen_vm.dart';

class ExerciseMainScreen extends StatefulWidget {
  const ExerciseMainScreen({super.key});

    @override
  State<ExerciseMainScreen> createState() => _ExerciseMainScreenState();
}


class _ExerciseMainScreenState extends State<ExerciseMainScreen> {
     @override
          void initState() {
          super.initState();
      Future.microtask(() async {
        final vm = context.read<ExerciseMainScreenVm>();
      await vm.syncIfNeeded();
      await vm.loadFilterOptions();
      await vm.loadExercises();
    }
  );
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Text(
          'Exercise Main Screen',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}

//APP BAR SECTION
class ExercisesScreenAppBar extends StatefulWidget {
  const ExercisesScreenAppBar({super.key});

  @override
  State<ExercisesScreenAppBar> createState() => _ExercisesScreenAppBarState();
}

class _ExercisesScreenAppBarState extends State<ExercisesScreenAppBar> {

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Exercises'
          ),
          actions: <Widget>[
            
          ],
        ),
      )
    }  
}