import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/home/ui_layer/views_models/home_vm.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker_app/features/exercises/ui_layer/views_models/exercise_main_screen_vm.dart';
import 'package:gym_tracker_app/features/exercises/ui_layer/views/exercise_create_screen_v.dart';
import 'package:gym_tracker_app/features/exercises/ui_layer/widgets/exercise_card.dart';

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
      await vm.resetAndResync(); // TEMPORARY — remove after testing
      await vm.syncIfNeeded();
      await vm.loadFilterOptions();
      await vm.loadExercises();
    }
  );
  }

  Widget _buildBody(ExerciseMainScreenVm vm) {
  if (vm.syncStatus == SyncStatus.syncing) {
    return const Center(child: CircularProgressIndicator(
      color: Colors.blue
    ));
  }
  if (vm.isLoading) {
    return const Center(child: CircularProgressIndicator(
      color: Colors.blue
    ));
  }
  if (vm.errorMessage != null) {
    return Center(child: Text(vm.errorMessage!, style: const TextStyle(color: Colors.white)));
  }
  if (vm.exercises.isEmpty) {
    return const Center(child: Text('No exercises found', style: TextStyle(color: Colors.grey)));
  }
  debugPrint('Exercises loaded: ${vm.exercises.length}');
  return ListView.builder(
    padding: EdgeInsets.only(top: 10),
      cacheExtent: 500,
      itemCount: vm.exercises.length,
  itemBuilder: (context, index) {
    return ExerciseCard(exercise: vm.exercises[index]);
  },
  );
}

  @override
  Widget build(BuildContext context) {

  final vm = context.watch<ExerciseMainScreenVm>();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(175.0), //Adjust Space Between App Bar Top and Bottom
        child: const ExercisesScreenAppBar(),
      ),
      body: _buildBody(vm),
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
      return AppBar(
        
        flexibleSpace: Column(
          children: [
            Container(height: MediaQuery.of(context).padding.top, color: Colors.black), //Manual Status Bar
            Container(height: 52, color: const Color.fromARGB(255, 34, 39, 42)), //Grey Line
        ],
      ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
            'Exercises',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17.5
            )
          ),
        actions: <Widget>[
            CreateExercisesTextButton(),
          ],
          bottom: PreferredSize(
        preferredSize: const Size.fromHeight(20.0), 
        child: const FilterContainer(),
      ),
        );
    }  
}


class CreateExercisesTextButton extends StatelessWidget {
  const CreateExercisesTextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        'Create',
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.blue,
          fontSize: 17.5
        )
      ),
      onPressed: () => navigateToNextScreen(context, ExerciseCreateScreenV())
    );
  }
}

class FilterContainer extends StatelessWidget {
  const FilterContainer({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(padding: EdgeInsets.all(10), child: SearchExerciseBar(),),
        Padding(padding: EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
         child: Row(
          spacing: 10,
          children: [
            Text(
              'Filter By',
              style: TextStyle(
                color: Colors.grey
            )),
            EquipmentFilterButton(),
            CategoryFilterButton(),
            MusclesFilterButton(),
          ],)
          )
      ],)
    );
  }
}

class SearchExerciseBar extends StatelessWidget {
  const SearchExerciseBar({super.key});

  @override
  Widget build(BuildContext context){
    return TextField(
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.left,
        readOnly: false,
        onChanged: (value) {
        //implement search filtering
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 34, 39, 42),
      
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),

          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          hintText: 'Search exercise',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 25,
          ),
          prefixIcon: const Icon(
            Icons.search, 
            size: 20,
            color: Colors.grey
          ),
        ),
      );
  }
}

class EquipmentFilterButton extends StatelessWidget {
  const EquipmentFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 34, 39, 42),
        fixedSize: Size(102.5, 45),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Text(
        'Equipment'
      ),
      onPressed: () {
        
      },
    );
  }
}

class CategoryFilterButton extends StatelessWidget {
  const CategoryFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 34, 39, 42),
        foregroundColor: Colors.white,
        fixedSize: Size(102.5, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Text(
        'Category'
      ),
      onPressed: () {
        
      },
    );
  }
}

class MusclesFilterButton extends StatelessWidget {
  const MusclesFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 34, 39, 42),
        foregroundColor: Colors.white,
        fixedSize: Size(102.5, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Text(
        'Muscles'
      ),
      onPressed: () {
        
      },
    );
  }
}