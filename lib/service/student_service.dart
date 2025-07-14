import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/Student.dart';

class StudentService {
  static const String baseUrl =
      'https://edtech-academy-management-system-server.onrender.com/api/students';

  static Future<Student> fetchStudentByEmail(String email) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (jsonData['data'] != null && jsonData['data'] is List) {
        List<dynamic> studentList = jsonData['data'];
       

        final filteredStudents = studentList.where((student) {
          final apiEmail =
              (student['email'] ?? '').toString().trim().toLowerCase();
          final inputEmail = email.trim().toLowerCase();
          return apiEmail == inputEmail;
        }).toList();

        if (filteredStudents.isNotEmpty) {
          final studentData = filteredStudents[0];
          return Student.fromJson(studentData);
        } else {
          throw Exception('Student with email $email not found.');
        }
      } else {
        throw Exception('Invalid data format');
      }
    } else {
      throw Exception('Failed to fetch student');
    }
  }
}
