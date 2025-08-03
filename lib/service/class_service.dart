// services/class_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/class_model.dart';

class ClassService {
  static const String apiUrl =
      'http://188.166.242.109:5000/api/classes';

  static Future<List<ClassModel>> fetchClassDataByEmail(String email) async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];

      // No filter on mark_as_completed, just filter by student email
      return data
          .where((item) => (item['students'] as List).any(
                (student) => student['student']?['email'] == email,
              ))
          .map((item) => ClassModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load class data');
    }
  }
}
