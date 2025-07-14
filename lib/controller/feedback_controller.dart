// controllers/feedback_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/class_model.dart';
import '../model/feedback_model.dart';
import '../service/class_service.dart';
import '../service/feedback_service.dart';

class FeedbackController extends GetxController {
  final TextEditingController feedbackTextController = TextEditingController();
  var isLoading = false.obs;
  var student = Rxn<Student>(); // Nullable Student

  Future<void> fetchStudentByEmail(String email) async {
    isLoading.value = true;
    try {
      final classList = await ClassService.fetchClassDataByEmail(email);

      // Find the first student matching this email
      for (var c in classList) {
        for (var s in c.students) {
          if (s.student.email == email) {
            student.value = s.student;
            isLoading.value = false;
            return;
          }
        }
      }

      student.value = null; // Not found
    } catch (e) {
      print("Error fetching student: $e");
      student.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitFeedback({required String studentId}) async {
    final feedbackText = feedbackTextController.text.trim();

    if (feedbackText.isEmpty) {
      Get.snackbar("Missing", "Feedback cannot be empty",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      final feedback = FeedbackModel(
        from: studentId,
        feedback: feedbackText,
      );

      await FeedbackService.sendFeedback(feedback);
      Get.snackbar("Success", "Feedback submitted!",
          backgroundColor: Colors.green, colorText: Colors.white);

      feedbackTextController.clear();
    } catch (e) {
      Get.snackbar("Error", "Failed to send feedback",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    feedbackTextController.dispose();
    super.onClose();
  }
}
