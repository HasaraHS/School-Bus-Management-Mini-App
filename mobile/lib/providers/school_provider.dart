import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/school.dart';

class SchoolProvider extends ChangeNotifier {
  List<School> _schools = [];
  School? _selectedSchool;
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  List<School> get schools => _schools;
  School? get selectedSchool => _selectedSchool;
  bool get isLoading => _isLoading;

  Future<void> loadSchools(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      _apiService.setToken(token);
      _schools = await _apiService.getAllSchools();
    } catch (e) {
      print('Error loading schools: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadSchoolDetails(String schoolId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedSchool = await _apiService.getSchoolDetails(schoolId);
    } catch (e) {
      print('Error loading school details: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}