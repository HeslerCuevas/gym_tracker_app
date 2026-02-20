import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/general_classes.dart';

class WorkoutHome extends StatelessWidget {
  const WorkoutHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 19, 21),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          
      //Quick Start Section
      const SizedBox(height: 50),
      Align(alignment: Alignment(-0.9, -1.0), child: GeneralText(text: "Quick Start", color: Colors.white, fontSize: 24, textAlign: TextAlign.right, fontWeight: FontWeight.bold),),

      const SizedBox(height: 20),
      //Start an Empty Workout Section
      Align(alignment: Alignment(0.20, -1.0), child: Button(text: "Start an Empty Workout", onPressed: () {}, fontSize: 18, horizontalPadding: 105, verticalPadding: 7.5, borderRadius: 10,),),
      
      const SizedBox(height: 30),
      //Templates Section
      Row(spacing: 10, children: [
        GeneralText(text: "Templates", color: Colors.white, fontSize: 30, textAlign: TextAlign.left, fontWeight: FontWeight.bold),
        const Spacer(),
        IconButton(onPressed: () {}, icon: const Icon(Icons.add, color: Colors.white)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz, color: Colors.white))
      ],)
      
      //My Templates Section
        ],
      ),
    );
  }
}