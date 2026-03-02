import 'package:gym_tracker_app/databases/drift/app_database.dart';
import 'package:drift/drift.dart';
import 'package:gym_tracker_app/features/exercises/data_layer/models/exercise_list_item.dart';
import 'package:gym_tracker_app/features/exercises/data_layer/models/exercise_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExerciseRepository {
  final AppDatabase _db;

  ExerciseRepository(this._db);

  String _stripHtml(String html) {
  return html.replaceAll(RegExp(r'<[^>]*>'), '').trim();
}


    Future<int> findOrCreateCategory(String name) async {

    // Check if category already exists (SEARCH)
    final existing = await (_db.select(_db.categories)
    ..where((c) => c.name.equals(name)))
    .getSingleOrNull();
    if (existing != null) {
      return existing.id;
    }

    // INSERT new category and return ID
    final newId = await _db.into(_db.categories).insertReturning(
      CategoriesCompanion.insert(name: name),
    );
    return newId.id;
  }

  Future<int> findOrCreateBodyPart(String name) async {

    // Check if body part already exists (SEARCH)
    final existing = await (_db.select(_db.bodyParts)
    ..where((c) => c.name.equals(name)))
    .getSingleOrNull();
    if (existing != null) {
      return existing.id;
    }

    // INSERT new body part and return ID
    final newId = await _db.into(_db.bodyParts).insertReturning(
     BodyPartsCompanion.insert(name: name),
    );
    return newId.id;
  }

  Future<int> findOrCreateEquipment(String name) async {

    // Check if equipment already exists (SEARCH)
    final existing = await (_db.select(_db.equipment)
    ..where((c) => c.name.equals(name)))
    .getSingleOrNull();
    if (existing != null) {
      return existing.id;
    }

    // INSERT new equipment and return ID
    final newId = await _db.into(_db.equipment).insertReturning(
      EquipmentCompanion.insert(name: name),
    );
    return newId.id;
  }

  Future<int> findOrCreateMuscleTarget(String name) async {

    // Check if muscle target already exists (SEARCH)
    final existing = await (_db.select(_db.muscleTargets)
    ..where((c) => c.name.equals(name)))
    .getSingleOrNull();
    if (existing != null) {
      return existing.id;
    }

    // INSERT new muscle target and return ID
    final newId = await _db.into(_db.muscleTargets).insertReturning(
      MuscleTargetsCompanion.insert(name: name),
    );
    return newId.id;
  }

  Future<void> syncExercisesFromWger() async {
  String? nextUrl = 'https://wger.de/api/v2/exerciseinfo/?format=json&language=2&limit=20';

  while (nextUrl != null) {
    try {
      final response = await http.get(Uri.parse(nextUrl));
      
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch exercises: ${response.statusCode}');
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final exercises = body['results'] as List<dynamic>;
      
      for (var exercise in exercises) {
        await importSingleExercise(exercise);
      }

      nextUrl = body['next'] as String?;
    } catch (e) {
      throw Exception('Error syncing exercises from wger: $e');
    }
  }
}

    Future<void> createCustomExercise(String name, int categoryId, int primaryMuscleTargetId,
      int bodyPartId, int equipmentId, int defaultWeightUnitId, String? instructions) async {
    await _db.into(_db.exercises).insert(
      ExercisesCompanion.insert(
        name: name,
        categoryId: categoryId,
        primaryMuscleTargetId: primaryMuscleTargetId,
        bodyPartId: bodyPartId,
        equipmentId: equipmentId,
        defaultWeightUnitId: defaultWeightUnitId,
        instructions: Value(instructions),
        externalId: Value.absent(),
        serverId: Value.absent(),
        isCustom: const Value(true),
    )
  );
}

  Future<void> importSingleExercise(Map<String, dynamic> data) async{

    final translations1 = data['translations'] as List<dynamic>? ?? [];
  final translation1 = translations1.firstWhere(
    (t) => t['language'] == 2,
    orElse: () => null,
  );

  // If no English translation exists, skip this exercise entirely
  if (translation1 == null) return;

  final name = translation1['name']?.toString() ?? '';

  // 2. Filter: Name length
  if (name.length < 3 || name.length > 28) return;

  // 3. Filter: Suspicious patterns (Casing and 'SS')
  // Note: We check if it's NOT empty to avoid false positives on empty strings
  if (name.isEmpty || 
      name.contains(' SS ') || 
      name.toUpperCase() == name || 
      name.toLowerCase() == name) {
    return;
  }

  // 4. Filter: Styles (If you only want specific image styles)
  final imageList1 = (data['images'] as List<dynamic>?) ?? [];
  
  // Example: Only keep images that are 'Style 1' (Line drawings)
  final styleOneImages = imageList1.where((img) => img['style'].toString() == '1').toList();

  // If no style 1 images exist, skip
  if (styleOneImages.isEmpty) return;


    //Check if exercise already exist (SEARCH by externalId)
    final existing = await (_db.select(_db.exercises)
    ..where((e) => e.externalId.equals(data['id'].toString())))
    .getSingleOrNull();
    if (existing != null) {
      return;
    }

    //Category in WGER are Body Parts in our App, so we need to find or create the corresponding body part
    final bodyPartId = await findOrCreateBodyPart(data['category']['name']);

    //CATEGORIES AS WE KNOW THEM IN THE APP ARE NOT PROVIDED BY WGER, SO WE WILL JUST ASSIGN ALL EXERCISES TO A DEFAULT "NOT SPECIFIED" CATEGORY FOR NOW
    final categoryId = await findOrCreateCategory('Not Specified');

    // primary muscle target is the first item in the muscles list, if empty use "Not Specified"
    final muscles = (data['muscles'] as List<dynamic>?) ?? [];
    final primaryMuscleName = muscles.isEmpty 
        ? 'Not Specified' 
        : muscles[0]['name'] as String;
    final primaryMuscleTargetId = await findOrCreateMuscleTarget(primaryMuscleName);

    // equipment is the first item in the equipment list, if empty use "Not Specified"
    final equipmentList = data['equipment'] as List<dynamic>;
    final equipmentName = equipmentList.isEmpty 
        ? 'Not Specified' 
        : equipmentList[0]['name'] as String;
    final equipmentId = await findOrCreateEquipment(equipmentName); 

    //Find item in data where translation language is Id 2 and use that for name and instructions
    final translation = (data['translations'] as List<dynamic>).firstWhere(
      (t) => t['language'] == 2,
    orElse: () => null,
  );
    if (translation == null) {
      throw Exception("No translation found for language ID 2");
    }


    //Getting kg unit ID for default weight unit
    final kgUnit = await (_db.select(_db.weightUnits)
    ..where((w) => w.symbol.equals('kg')))
    .getSingleOrNull();
    if (kgUnit == null) {
      throw Exception("No kg weight unit found");
    }
    final defaultWeightUnitId = kgUnit.id;

    //Create new exercise
    final insertedExercise = await _db.into(_db.exercises).insertReturning(
      ExercisesCompanion.insert(
        name: translation['name'],
        categoryId: categoryId,
        primaryMuscleTargetId: primaryMuscleTargetId,
        bodyPartId: bodyPartId,
        equipmentId: equipmentId,
        defaultWeightUnitId: defaultWeightUnitId,
        instructions: Value(_stripHtml(translation['description'] as String? ?? '')),
        externalId: Value(data['id'].toString()),
        serverId: const Value.absent(),
        isCustom: const Value(false),
      ),
    );

    //Add exercise images
    final imageList = (data['images'] as List<dynamic>?) ?? [];
    if (imageList.isEmpty) {
      // If no images provided, insert a default "no image" placeholder
      await _db.into(_db.exerciseImages).insert(
        ExerciseImagesCompanion.insert(
          exerciseId: insertedExercise.id,
          imageUrl: '',
          isMain: const Value(true),
        ),
      );
    } else {
    for (var image in imageList) {
      await _db.into(_db.exerciseImages).insert(
        ExerciseImagesCompanion.insert(
         exerciseId: insertedExercise.id,
         imageUrl: image['image'] as String,
          isMain: Value(image['is_main'] as bool? ?? false),
       ),
      );
    }
  }

    //Add secondary muscle targets
    final secondaryMuscles = (data['muscles_secondary'] as List<dynamic>?) ?? [];
    for (var muscle in secondaryMuscles) {
      final secondaryMuscleTargetId = await findOrCreateMuscleTarget(muscle['name'] as String);
      await _db.into(_db.exerciseSecondaryMuscles).insert(
    ExerciseSecondaryMusclesCompanion.insert(
      exerciseId: insertedExercise.id,
      muscleTargetId: secondaryMuscleTargetId,
    ),
  );
}

  }

  Future<void> deactivateExercise(int id) async {
      await (_db.update(_db.exercises)
    ..where((e) => e.id.equals(id))).
    write(ExercisesCompanion(
      isActive: const Value(false),
      updatedAt: Value(DateTime.now())));
  }

  Future<void> updateExercise(int id, String? name, int? categoryId, int? primaryMuscleTargetId, int? bodyPartId, int? equipmentId, int? defaultWeightUnitId, String? instructions) async {
      await (_db.update(_db.exercises)
    ..where((e) => e.id.equals(id))).
    write(ExercisesCompanion(
       updatedAt: Value(DateTime.now()),
       name: name != null ? Value(name) : const Value.absent(),
       categoryId: categoryId != null ? Value(categoryId) : const Value.absent(),
       primaryMuscleTargetId: primaryMuscleTargetId != null ? Value(primaryMuscleTargetId) : const Value.absent(),
       bodyPartId: bodyPartId != null ? Value(bodyPartId) : const Value.absent(),
       equipmentId: equipmentId != null ? Value(equipmentId) : const Value.absent(),
       defaultWeightUnitId: defaultWeightUnitId != null ? Value(defaultWeightUnitId) : const Value.absent(),
       instructions: instructions != null ? Value(instructions) : const Value.absent(),
    ));
  }

  Future<List<ExerciseListItem>> getExercises({
  String? equipment,
  String? category,
  String? muscle,
  }) async {
    final query = _db.select(_db.exercises).join([
      leftOuterJoin(_db.bodyParts, _db.bodyParts.id.equalsExp(_db.exercises.bodyPartId)),
      leftOuterJoin(_db.exerciseImages, _db.exerciseImages.exerciseId.equalsExp(_db.exercises.id) & _db.exerciseImages.isMain.equals(true)),
      leftOuterJoin(_db.equipment, _db.equipment.id.equalsExp(_db.exercises.equipmentId)),
      leftOuterJoin(_db.categories, _db.categories.id.equalsExp(_db.exercises.categoryId)),
      leftOuterJoin(_db.muscleTargets, _db.muscleTargets.id.equalsExp(_db.exercises.primaryMuscleTargetId)),
    ])
    ..where(_db.exercises.isActive.equals(true));
    
    //Filter conditions if provided:
      if (equipment != null && equipment.isNotEmpty) {
    query.where(_db.equipment.name.equals(equipment));
    }
    if (category != null && category.isNotEmpty) {
    query.where(_db.categories.name.equals(category));
    }
    if (muscle != null && muscle.isNotEmpty) {
    query.where(_db.muscleTargets.name.equals(muscle));
    }
    return await query.map((row) {
      final exercise = row.readTable(_db.exercises);
      final bodyPart = row.readTableOrNull(_db.bodyParts);
      final image = row.readTableOrNull(_db.exerciseImages);

      return ExerciseListItem(
        id: exercise.id,
        name: exercise.name,
        bodyPartName: bodyPart?.name ?? 'Not Specified',
        imageUrl: image?.imageUrl ?? '',
      );
    }).get();
  }

  Future<List<String>> getExerciseImages(int id) async {
  final imagesQuery = _db.select(_db.exerciseImages)
    ..where((img) => img.exerciseId.equals(id));

  final images = await imagesQuery.get();
  return images.map((img) => img.imageUrl).toList();
}

  Future<List<String>> getExerciseSecondaryMuscles(int id) async {
        // Fetch secondary muscle targets
    final secondaryMusclesQuery = _db.select(_db.exerciseSecondaryMuscles).join([
      leftOuterJoin(_db.muscleTargets, _db.muscleTargets.id.equalsExp(_db.exerciseSecondaryMuscles.muscleTargetId)),
    ])
    ..where(_db.exerciseSecondaryMuscles.exerciseId.equals(id));

    final secondaryRows = await secondaryMusclesQuery.get();
    return secondaryRows.map((row) => row.readTable(_db.muscleTargets).name).toList();
  }

  Future<ExerciseDetail?> getExerciseDetail(int id) async {
    final query = _db.select(_db.exercises).join([
      leftOuterJoin(_db.bodyParts, _db.bodyParts.id.equalsExp(_db.exercises.bodyPartId)),
      leftOuterJoin(_db.categories, _db.categories.id.equalsExp(_db.exercises.categoryId)),
      leftOuterJoin(_db.equipment, _db.equipment.id.equalsExp(_db.exercises.equipmentId)),
      leftOuterJoin(_db.muscleTargets, _db.muscleTargets.id.equalsExp(_db.exercises.primaryMuscleTargetId)),
    ])
    ..where(_db.exercises.id.equals(id));

    final row = await query.getSingleOrNull();
    if (row == null) {
      return null;
    }

    final exercise = row.readTable(_db.exercises);
    final bodyPart = row.readTableOrNull(_db.bodyParts);
    final category = row.readTableOrNull(_db.categories);
    final equipment = row.readTableOrNull(_db.equipment);
    final primaryMuscleTarget = row.readTableOrNull(_db.muscleTargets);

    //Fetch secondary muscles
    final secondaryMuscleTargets = await getExerciseSecondaryMuscles(id);

    // Fetch images
    final imageList = await getExerciseImages(id);

      return ExerciseDetail(
    id: exercise.id,
    name: exercise.name,
    instructions: exercise.instructions ?? '',
    category: category?.name ?? 'Not Specified',
    bodyPart: bodyPart?.name ?? 'Not Specified',
    equipment: equipment?.name ?? 'Not Specified',
    primaryMuscleGroup: primaryMuscleTarget?.name ?? 'Not Specified',
    secondaryMuscleGroups: secondaryMuscleTargets,
    imageUrls: imageList,
  );
  }

  Future<List<String>> getEquipmentOptions() async {
    try {
      final equipmentOptionsQuery = await _db.select(_db.equipment).get();
      return equipmentOptionsQuery.map((item) => item.name).toList();
    }
    catch(e){
      throw Exception('Could not get Equipment Options. Error: ${e.toString()}');
    }
  }
  Future<List<String>> getCategoryOptions() async {
    try {
      final categoryOptionsQuery = await _db.select(_db.categories).get();
      return categoryOptionsQuery.map((item) => item.name).toList();
    }
    catch(e){
      throw Exception('Could not get Category Options. Error: ${e.toString()}');
    }
  }
  Future<List<String>> getMuscleOptions() async {
    try {
      final muscleOptionsQuery = await _db.select(_db.muscleTargets).get();
      return muscleOptionsQuery.map((item) => item.name).toList();
    }
    catch(e){
      throw Exception('Could not get Muscle Options. Error: ${e.toString()}');
    }
  }

  Future<void> clearAllExercises() async {
  await _db.delete(_db.exerciseSecondaryMuscles).go();
  await _db.delete(_db.exerciseImages).go();
  await _db.delete(_db.exercises).go();
}
}