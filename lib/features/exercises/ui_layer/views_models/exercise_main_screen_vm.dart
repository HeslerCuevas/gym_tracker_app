import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/exercises/data_layer/exercises_repository.dart';
import 'package:gym_tracker_app/features/exercises/data_layer/models/exercise_list_item.dart';
import 'package:shared_preferences/shared_preferences.dart';  

enum SyncStatus { idle, syncing, completed, failed }

class ExerciseMainScreenVm extends ChangeNotifier {
  final ExerciseRepository _repository;
  ExerciseMainScreenVm(this._repository);

  // private
  List<ExerciseListItem> _exercises = [];
  bool _isLoading = false;
  String? _errorMessage;
  SyncStatus _syncStatus = SyncStatus.idle;
  List<String> _equipmentOptions = [];
  List<String> _categoryOptions = [];
  List<String> _muscleOptions = [];
  String? _selectedEquipment;
  String? _selectedCategory;
  String? _selectedMuscle;

  // public getters
  List<ExerciseListItem> get exercises => _exercises;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  SyncStatus get syncStatus => _syncStatus;
  List<String> get equipmentOptions => _equipmentOptions;
  List<String> get categoryOptions => _categoryOptions;
  List<String> get muscleOptions => _muscleOptions;
  String? get selectedEquipment => _selectedEquipment;
  String? get selectedCategory => _selectedCategory;
  String? get selectedMuscle => _selectedMuscle;

  void _cleanError() {
    _errorMessage = null;
  }

  Future<void> loadFilterOptions() async {
    try {
      _cleanError();
      _equipmentOptions = await _repository.getEquipmentOptions();
      _categoryOptions = await _repository.getCategoryOptions();
      _muscleOptions = await _repository.getMuscleOptions();
      notifyListeners();
    }
    on Exception catch(e) {
      _errorMessage = 'Filter Loading Failed. Error:${e.toString()}';
      debugPrint('Error while loading filters options. Error: $e');
    }
  }

  Future<void> setEquipmentFilter(String? equipment) async {
    _selectedEquipment = equipment;
    await loadExercises();
  }

  Future<void> setCategoryFilter(String? category) async {
    _selectedCategory = category;
    await loadExercises();
  }

  Future<void> setMuscleFilter(String? muscle) async {
    _selectedMuscle = muscle;
    await loadExercises();
  }


  Future<void> syncIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadySynced = prefs.getBool('hasCompletedInitialSync') ?? false;
  
    if (alreadySynced) {
      _syncStatus = SyncStatus.completed;
      notifyListeners();
      return;
    }

    _syncStatus = SyncStatus.syncing;
    notifyListeners();

    try {
      await _repository.syncExercisesFromWger();
      await prefs.setBool('hasCompletedInitialSync', true);
      _syncStatus = SyncStatus.completed;
    } catch (e) {
      _errorMessage = 'Sync failed: ${e.toString()}';
      debugPrint('Error while syncing. Error: $e');
      _syncStatus = SyncStatus.failed;
    }

    notifyListeners();
}

  Future<void> loadExercises() async {
    if(_isLoading) {
      return;
    }

      try {
          _isLoading = true;
          _cleanError();
          notifyListeners();
          _exercises = await _repository.getExercises(
              equipment: _selectedEquipment,
              category: _selectedCategory,
              muscle: _selectedMuscle,
          );
      }
      on Exception catch(e) {
        _errorMessage = 'Failed to load exercises. Error: ${e.toString()}';
        debugPrint('Failed to load exercises. Error: $e');
      }
      finally {
          _isLoading = false;
          notifyListeners();
      }
  }

  Future<void> deactivateExercise(int id) async {
    try {
      _cleanError();
      await _repository.deactivateExercise(id);
      await loadExercises();
    }
    on Exception catch(e) {
      _errorMessage = 'Could not deactivate the exercises. Error: ${e.toString()}';
      debugPrint('Could not deactivate the exercises. Error: $e');
      notifyListeners();
    }
  }
}
