import 'dart:ffi';
import 'package:drift/drift.dart';

// ─────────────────────────────────────────────
// LOOKUP / REFERENCE TABLES
// ─────────────────────────────────────────────

// Equipment used for exercises - e.g. "Barbell", "Dumbbell", "Kettlebell", "Machine", "Bodyweight", "Resistance Band"
class Equipment extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
    DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Muscle targets (primary and secondary) - e.g. "Chest", "Back", "Legs", "Arms", "Shoulders", "Core"  
class MuscleTargets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
    DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Table for secondary muscles
class ExerciseSecondaryMuscles extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get exerciseId => integer().references(Exercises, #id)();
  IntColumn get muscleTargetId => integer().references(MuscleTargets, #id)();
}

/// e.g. "Strength", "Cardio", "Flexibility"
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// e.g. "Chest", "Back", "Legs", "Arms", "Shoulders", "Core"
class BodyParts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// e.g. "kg", "lbs", "bodyweight", "band"
class WeightUnits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get symbol => text().withLength(min: 1, max: 50)();
  TextColumn get label => text().withLength(min: 1, max: 50)();
    DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// e.g. "Normal", "Warm-up", "Drop Set", "Failure", "Myorep"
class SetTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
    DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ─────────────────────────────────────────────
// CORE EXERCISE TABLE
// ─────────────────────────────────────────────

class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get externalId => text().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 200)();

  // FK references
  IntColumn get categoryId =>
      integer().references(Categories, #id)();
  IntColumn get bodyPartId =>
      integer().references(BodyParts, #id)();
  IntColumn get defaultWeightUnitId =>
      integer().references(WeightUnits, #id)();
  IntColumn get equipmentId =>
      integer().references(Equipment, #id)();
  IntColumn get primaryMuscleTargetId =>
      integer().references(MuscleTargets, #id)();

  // About / instructions
  TextColumn get instructions => text().nullable().withLength(max: 3000)();

  /// Local path or asset path to a GIF animation
  TextColumn get gifPath => text().nullable()();

  /// Remote URL (for cloud sync later)
  TextColumn get gifUrl => text().nullable()();

  BoolColumn get isCustom =>
      boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
    BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  TextColumn get serverId => text().nullable()();
}

// ─────────────────────────────────────────────
// WORKOUT TEMPLATES
// ─────────────────────────────────────────────

class WorkoutTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable().withLength(max: 3000)();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
    BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  TextColumn get serverId => text().nullable()();
}

/// Which exercises belong to a template (ordered list)
class WorkoutTemplateExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get templateId =>
      integer().references(WorkoutTemplates, #id)();
  IntColumn get exerciseId =>
      integer().references(Exercises, #id)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

// ─────────────────────────────────────────────
// WORKOUT SESSIONS  (a completed workout)
// ─────────────────────────────────────────────

class WorkoutSessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// null = ad-hoc session with no template
  IntColumn get templateId =>
      integer().nullable().references(WorkoutTemplates, #id)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get serverId => text().nullable()();
}

// ─────────────────────────────────────────────
// SESSION EXERCISES  (one exercise entry per session)
// ─────────────────────────────────────────────

class SessionExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId =>
      integer().references(WorkoutSessions, #id)();
  IntColumn get exerciseId =>
      integer().references(Exercises, #id)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// Override weight unit for this session entry
  IntColumn get weightUnitId =>
      integer().nullable().references(WeightUnits, #id)();

  TextColumn get notes => text().nullable()();
  TextColumn get serverId => text().nullable()();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// ─────────────────────────────────────────────
// SETS  (individual sets within a session exercise)
// ─────────────────────────────────────────────

class ExerciseSets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionExerciseId =>
      integer().references(SessionExercises, #id)();
  IntColumn get setTypeId =>
      integer().references(SetTypes, #id)();
  IntColumn get setNumber => integer()();

  /// Weight used (in the unit stored on the parent sessionExercise/exercise)
  RealColumn get weight => real().nullable()();
  IntColumn get reps => integer().nullable()();

  /// Duration in seconds (for time-based sets)
  IntColumn get durationSeconds => integer().nullable()();

  /// Was this set completed?
  BoolColumn get isCompleted =>
      boolean().withDefault(const Constant(false))();
  
  TextColumn get serverId => text().nullable()();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
