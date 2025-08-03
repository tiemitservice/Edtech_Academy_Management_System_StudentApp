// services/feedback_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/feedback_model.dart';

class FeedbackService {
  
  static const String apiUrl =
            'http://188.166.242.109:5000/api/feedbacks'; 
   static Future<void> sendFeedback(FeedbackModel feedback) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(feedback.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to send feedback: ${response.body}');
    }
  }
}
