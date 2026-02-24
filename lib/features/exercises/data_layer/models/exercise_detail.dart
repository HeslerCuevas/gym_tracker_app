class ExerciseDetail {
  final int id;
  final String name;
  final String instructions;
  final String category;
  final String equipment;
  final String bodyPart;
  final String primaryMuscleGroup;
  final List<String> secondaryMuscleGroups;
  final List<String> imageUrls;

  ExerciseDetail({
    required this.id,
    required this.name,
    required this.instructions,
    required this.category,
    required this.bodyPart,
    required this.equipment,
    required this.primaryMuscleGroup,
    required this.secondaryMuscleGroups,
    required this.imageUrls
  });
}