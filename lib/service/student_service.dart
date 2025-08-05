import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/student.dart';

class StudentService {
  static const String baseUrl = 'http://188.166.242.109:5000/api/students';

  static Future<Student> fetchStudentByEmail(String email) async {
    // Construct the URL to specifically search for a student by email
    final url = Uri.parse('$baseUrl?email=$email');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['data'] != null && jsonData['data'] is List) {
          List<dynamic> studentList = jsonData['data'];

          if (studentList.isNotEmpty) {
            final studentData = studentList[0];
            return Student.fromJson(studentData);
          } else {
            // This is the correct way to handle a "not found" scenario
            throw Exception('Student with email $email not found.');
          }
        } else {
          throw Exception('Invalid data format received from API.');
        }
      } else {
        // Handle API errors more gracefully
        throw Exception(
            'Failed to fetch student. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any network or parsing exceptions
      throw Exception('An error occurred while fetching student data: $e');
    }
  }
}
