// services/class_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/class_model.dart';

class ClassService {
  static const String apiUrl =
      'https://edtech-academy-management-system-server.onrender.com/api/classes';

 static Future<List<ClassModel>> fetchClassDataByEmail(String email) async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];

      return data
          .where((item) =>
              item['mark_as_completed'] == true && 
              (item['students'] as List).any(
                (student) => student['student']?['email'] == email,
              ))
          .map((item) => ClassModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load class data');
    }
  }
}
