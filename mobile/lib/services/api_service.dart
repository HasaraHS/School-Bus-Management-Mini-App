import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/school.dart';

class ApiService {
  static final String baseUrl = dotenv.env['API_BASE_URL']!;
  String? _token;

  void setToken(String token) {
    _token = token;
  }

  Map<String, String> get _headers => {
      'Content-Type': 'application/json',
      'Authorization':'Bearer $_token', 
  };

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }

  Future<List<School>> getAllSchools() async {
    final response = await http.get(
      Uri.parse('$baseUrl/schools'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => School.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load schools');
    }
  }

  Future<School> getSchoolDetails(String schoolId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/schools/$schoolId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return School.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load school details');
    }
  }
}