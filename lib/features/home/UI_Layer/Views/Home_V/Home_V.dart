import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/exercises/ui_layer/views/exercise_main_screen_v.dart';
import 'package:gym_tracker_app/features/workout/UI_Layer/Views/Workout_Home_V.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const Center(
          child: Text(
            'Home Screen',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        );
      case 1:
        return const Center(
          child: Text(
            'History Screen',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        );
      case 2:
        return const Center(
          child: WorkoutHome(),
        );
      case 3:
        return const Center(
          child: ExerciseMainScreen(),
        );
      case 4:
        return const Center(
          child: Text(
            'Profile Screen',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 13, 81, 237),
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/home_black_logo.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/history_black_logo.png')),
            label: 'History',
          ),
            BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/dumbell_black_logo.png')),
            label: 'Workouts',
          ),
            BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/exercise_black_logo.png')),
            label: 'Exercises',
          ),
           BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/profile_black_logo.png')),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}