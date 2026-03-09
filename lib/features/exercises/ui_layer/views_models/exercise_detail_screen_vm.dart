import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/exercises/data_layer/exercises_repository.dart';
import 'package:gym_tracker_app/features/exercises/data_layer/models/exercise_detail.dart'; 

class ExerciseDetailScreenVm extends ChangeNotifier {
  final ExerciseRepository _repository;
  ExerciseDetailScreenVm(this._repository);

  // private
  ExerciseDetail? _exercise;
  bool _isLoading = false;
  String? _errorMessage;

  // public getters
  ExerciseDetail? get exercise => _exercise;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadExercise(int id) async {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        _exercise = await _repository.getExerciseDetail(id);
      } on Exception catch (e) {
        _errorMessage = 'Failed to load exercise. Error: ${e.toString()}';
        debugPrint('Failed to load exercise detail. Error: $e');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
  }
}


