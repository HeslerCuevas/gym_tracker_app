import 'package:gym_tracker_app/databases/drift/exercises_tables.dart';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
part 'app_database.g.dart';

@DriftDatabase(tables: [
  Exercises,
  Equipment,
  MuscleTargets,
  WorkoutTemplates,
  WorkoutTemplateExercises,
  ExerciseSecondaryMuscles,
  Categories,
  BodyParts,
  WeightUnits,
  SetTypes,
  ExerciseSets,
  WorkoutSessions,
  SessionExercises,
  ExerciseImages,
])

class AppDatabase extends _$AppDatabase {
  AppDatabase(): super (_openConnection());

  @override
  int get schemaVersion => 1;

  //Migration strategy
  @override
    MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedLookupData();
    },
    onUpgrade: (m, from, to) async {
      // future migrations go here
    },
  );

  //Seed initial lookup data for categories, body parts, weight units, and set types
  Future<void> _seedLookupData() async {
  await batch((batch) {
    batch.insertAll(
      setTypes,
      [
        SetTypesCompanion.insert(name: 'Normal'),
        SetTypesCompanion.insert(name: 'Warm-up'),
        SetTypesCompanion.insert(name: 'Drop Set'),
        SetTypesCompanion.insert(name: 'Failure'),
        SetTypesCompanion.insert(name: 'Myorep'),
      ],
      mode: InsertMode.insertOrIgnore,
    );

    batch.insertAll(
      weightUnits,
      [
        WeightUnitsCompanion.insert(symbol: 'kg', label: 'Kilograms'),
        WeightUnitsCompanion.insert(symbol: 'lbs', label: 'Pounds'),
      ],
      mode: InsertMode.insertOrIgnore,
    );

    batch.insertAll(
      categories,
      [
        CategoriesCompanion.insert(name: 'Strength'),
        CategoriesCompanion.insert(name: 'Cardio'),
        CategoriesCompanion.insert(name: 'Flexibility'),
        CategoriesCompanion.insert(name: 'Balance'),
        CategoriesCompanion.insert(name: 'Plyometrics'),
        CategoriesCompanion.insert(name: 'Power'),
        CategoriesCompanion.insert(name: 'Hypertrophy'),
      ],
      mode: InsertMode.insertOrIgnore,
    );

    batch.insertAll(
      bodyParts,
      [
        BodyPartsCompanion.insert(name: 'Chest'),
        BodyPartsCompanion.insert(name: 'Back'),
        BodyPartsCompanion.insert(name: 'Legs'),
        BodyPartsCompanion.insert(name: 'Arms'),
        BodyPartsCompanion.insert(name: 'Shoulders'),
        BodyPartsCompanion.insert(name: 'Core'),
        BodyPartsCompanion.insert(name: 'Full Body'),
        BodyPartsCompanion.insert(name: 'Glutes'),
        BodyPartsCompanion.insert(name: 'Calves'),
        BodyPartsCompanion.insert(name: 'Neck'),
      ],
      mode: InsertMode.insertOrIgnore,
    );
  });
}
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {

  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(p.join(dbFolder.path, 'gym_tracker_database.sqlite'));

  //Check for old version of Android
  if(Platform.isAndroid) {
    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
  }

  // Make sqlite3 pick a more suitable location for temporary files
  final cachebase = (await getTemporaryDirectory()).path;

  // We can't access /tmp on Android, which sqlite3 would try by default
  sqlite3.tempDirectory = cachebase;

  return NativeDatabase.createInBackground(file);
  });
}