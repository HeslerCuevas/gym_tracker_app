import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/exercises/data_layer/models/exercise_list_item.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ExerciseCard extends StatelessWidget {
  final ExerciseListItem exercise;
  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return InkWell(
  onTap: () {
    // navigation goes here
  },
  child: Column(
  children: [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
        CircleAvatar(
      radius: 30,
      backgroundColor: Colors.white,
      backgroundImage: exercise.imageUrl.isNotEmpty 
          ? CachedNetworkImageProvider(exercise.imageUrl) 
          : null,
      child: exercise.imageUrl.isEmpty 
          ? const Icon(Icons.fitness_center, color: Colors.grey) 
          : null,
      ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
           children: [
          Text(
            exercise.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )
          ),
          const SizedBox(height: 5),
          Text(
            exercise.bodyPartName,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
        ],),
        const Spacer(),
        const Icon(
          color: Colors.grey,
          size: 20,
          Icons.chevron_right
          )
    ],
      ),
    ),
    const Divider(
      color: Color(0xFF222222),
      height: 1,
      indent: 16,
      endIndent: 16,
    ),
  ],
),
);
}
}