import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/class_model.dart';
import '../controller/auth_controller.dart';

class PermissionController extends GetxController {
  final reasonController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  final isLoading = false.obs;

  ClassModel? selectedClass;
  // Student info from API
  var studentId = ''.obs;
  var staff = ''.obs;
  var studentName = ''.obs;
  var permissionHistory = [].obs;
  var studentEmail = ''.obs;
  var permissions = [].obs;
  var email = ''.obs;
  var availableClasses = <ClassModel>[].obs;
  var selectedStaff = ''.obs;
  var selectedClassName = ''.obs; 

 void setSelectedClass(String className) {

    final selected = availableClasses.firstWhereOrNull(
      (c) => c.name == className && c.markAsCompleted == true,
    );

    if (selected != null) {
      selectedClassName.value = selected.name;
      staff.value = selected.staff;
      print("🔄 Class selected: ${selected.name}, Staff: ${selected.staff}");
    } else {
      // If not found or inactive class, clear selection
      selectedClassName.value = '';
      staff.value = '';
      print("⚠️ No active class found for selected class name: $className");
    }
  }

  final String studentApiUrl =
      'http://188.166.242.109:5000/api/students';
  final String permissionApiUrl =
      'http://188.166.242.109:5000/api/student_permissions';

Future<void> fetchStudentByEmail(String email) async {
    final auth = Get.find<AuthController>();
    final userEmail = auth.userEmail.value.trim();
    
    if (userEmail.isEmpty) {
      Get.snackbar("Error", "Email not found. Please log in again.",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      // Step 1: Get student list
      final response = await http.get(Uri.parse(studentApiUrl));
      if (response.statusCode != 200) {
        Get.snackbar("Error", "Failed to load students",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final decoded = json.decode(response.body);
      final List students = decoded['data'] ?? [];

      final matched = students.firstWhere(
        (s) => s['email']?.toString().toLowerCase() == userEmail.toLowerCase(),
        orElse: () => null,
      );

      if (matched == null) {
        Get.snackbar("Error", "No student matched with email: $userEmail",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      // Extract studentId
      final id = matched['_id'];
      studentId.value =
          (id is Map && id.containsKey('\$oid')) ? id['\$oid'] : id.toString();

      studentName.value =
          matched['eng_name'] ?? matched['kh_name'] ?? 'Unknown';

      print("✅ Student ID: ${studentId.value}");

      // Step 2: Get class list
      final classRes = await http.get(Uri.parse(
          'http://188.166.242.109:5000/api/classes'));

      if (classRes.statusCode != 200) {
        Get.snackbar("Error", "Failed to load classes",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final List classList = json.decode(classRes.body)['data'] ?? [];

      availableClasses.clear();

      for (var classJson in classList) {
        final classModel = ClassModel.fromJson(classJson);
        final isInClass = classModel.students.any(
          (studentRecord) => studentRecord.student.id == studentId.value,
        );
        if (isInClass) {
          availableClasses.add(classModel);
        }
      }

      if (availableClasses.isNotEmpty) {
        print(
            "🎯 Available classes: ${availableClasses.map((e) => e.name).toList()}");
        print("✅ Default staff: ${staff.value}");
      } else {
        print("⚠️ No classes found for student: ${studentId.value}");
        staff.value = '';
      }
    } catch (e) {
      Get.snackbar("Error", "Exception occurred: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

 Future<void> submitPermission() async {
    if (studentId.isEmpty) {
      if (email.value.isEmpty) {
        Get.snackbar("Error", "Email is missing. Please login again.",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      await fetchStudentByEmail(email.value);
    }

    if (studentId.isEmpty) {
      Get.snackbar("Error", "Student not found.",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (staff.value.isEmpty) {
      Get.snackbar("Error", "Staff not assigned to this student.",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (reasonController.text.trim().isEmpty ||
        startDate == null ||
        endDate == null) {
      Get.snackbar("Error", "Please complete all fields",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (endDate!.isBefore(startDate!)) {
      Get.snackbar("Error", "End date cannot be before start date",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      final body = {
        "studentId": studentId.value,
        "reason": reasonController.text.trim(),
        "hold_date": [
          startDate!.toUtc().toIso8601String(),
          endDate!.toUtc().toIso8601String(),
        ],
        "permissent_status": "pending",
        "sent_to": staff.value,
      };

      final response = await http.post(
        Uri.parse(permissionApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      print("Staff ID: ${staff.value}");
      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Permission submitted successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
        clearForm();
      } else {
        print("Error response: ${response.body}");
        Get.snackbar("Failed", "Failed to submit permission",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> fetchStudentPermissions() async {
    final auth = Get.find<AuthController>();
    final int permissionCount = permissions.length;
    final int rejectedCount =
        permissions.where((p) => p['permissent_status'] == 'rejected').length;

    email.value = auth.userEmail.value.trim();

    if (email.value.isEmpty) {
      Get.snackbar("Error", "Email not found",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      final studentRes = await http.get(Uri.parse(studentApiUrl));
      if (studentRes.statusCode == 200) {
        final studentList = json.decode(studentRes.body)['data'] ?? [];

        final matched = studentList.firstWhere(
          (s) =>
              s['email']?.toString().toLowerCase() == email.value.toLowerCase(),
          orElse: () => null,
        );

        if (matched == null) {
          Get.snackbar("Not Found", "No student matches this email",
              backgroundColor: Colors.red, colorText: Colors.white);
          isLoading.value = false;
          return;
        }

        studentId.value = matched['_id'];

        final permissionRes = await http.get(Uri.parse(permissionApiUrl));
        if (permissionRes.statusCode == 200) {
          final all = json.decode(permissionRes.body)['data'] ?? [];
          final filtered =
              all.where((p) => p['studentId'] == studentId.value).toList();

          permissions.assignAll(filtered);
        } else {
          Get.snackbar("Error", "Failed to load permissions",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    reasonController.clear();
    startDate = null;
    endDate = null;
    update();
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }
}


