// lib/controller/permission_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/class_model.dart';
import '../controller/auth_controller.dart';
import '../allScreen/permission.dart';

enum PermissionSortCriteria {
  date,
  status,
  teacher,
}

class PermissionController extends GetxController {
  final reasonController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  final isLoading = false.obs;
  var sortCriteria = PermissionSortCriteria.date.obs;
  var currentFilter = 'All'.obs;

  ClassModel? selectedClass;
  var studentId = ''.obs;
  var staff = ''.obs;
  var studentName = ''.obs;
  var permissionHistory = [].obs;
  var permissions = [].obs;
  var email = ''.obs;
  var availableClasses = <ClassModel>[].obs;
  var selectedStaff = ''.obs;
  var selectedClassName = ''.obs;
  var staffNames = <String, Map<String, String>>{}.obs;

  var editingPermissionId = Rxn<String>();

  void setSelectedClass(String className) {
    final selected = availableClasses.firstWhereOrNull(
      (c) => c.name == className && c.markAsCompleted == true,
    );

    if (selected != null) {
      selectedClassName.value = selected.name;
      staff.value = selected.staff;
      print("🔄 Class selected: ${selected.name}, Staff: ${selected.staff}");
    } else {
      selectedClassName.value = '';
      staff.value = '';
      print("⚠️ No active class found for selected class name: $className");
    }
  }

  final String studentApiUrl = 'http://188.166.242.109:5000/api/students';
  final String permissionApiUrl =
      'http://188.166.242.109:5000/api/student_permissions';

  Future<void> _fetchStaffNames() async {
    try {
      final response =
          await http.get(Uri.parse('http://188.166.242.109:5000/api/staffs'));
      if (response.statusCode == 200) {
        final List staffList = json.decode(response.body)['data'] ?? [];
        staffNames.clear();
        for (var staffData in staffList) {
          final staffId = staffData['_id'];
          staffNames[staffId] = {
            'khName': staffData['kh_name'] ?? 'N/A',
            'engName': staffData['en_name'] ?? 'N/A',
            'gender': staffData['gender'] ?? 'N/A',
          };
        }
      }
    } catch (e) {
      print("Error fetching staff names: $e");
    }
  }

  Future<void> fetchStudentByEmail(String email) async {
    final auth = Get.find<AuthController>();
    final userEmail = auth.userEmail.value.trim();
    if (userEmail.isEmpty) {
      Get.snackbar("Error", "Email not found. Please log in again.",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    try {
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
      final id = matched['_id'];
      studentId.value =
          (id is Map && id.containsKey('\$oid')) ? id['\$oid'] : id.toString();
      studentName.value =
          matched['eng_name'] ?? matched['kh_name'] ?? 'Unknown';
      print("✅ Student ID: ${studentId.value}");
      final classRes =
          await http.get(Uri.parse('http://188.166.242.109:5000/api/classes'));
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
    email.value = auth.userEmail.value.trim();
    if (email.value.isEmpty) {
      Get.snackbar("Error", "Email not found",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    isLoading.value = true;
    try {
      await _fetchStaffNames();

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

          for (var permission in filtered) {
            final staffId = permission['sent_to'];
            if (staffId != null && staffNames.containsKey(staffId)) {
              final isKhmer = Get.locale?.languageCode == 'km';
              final staffData = staffNames[staffId]!;
              final gender = staffData['gender']?.toLowerCase();
              final name = isKhmer ? staffData['khName'] : staffData['engName'];

              String titlePrefix;
              if (isKhmer) {
                titlePrefix =
                    gender == 'male' ? 'teacherMale'.tr : 'teacherFemale'.tr;
              } else {
                titlePrefix =
                    gender == 'male' ? 'teacherMale'.tr : 'teacherFemale'.tr;
              }
              permission['teacherInfo'] = '${'sentTo'.tr} $titlePrefix: $name';
            } else {
              permission['teacherInfo'] = '${'sentTo'.tr}: N/A';
            }
          }
          permissions.assignAll(filtered);
          sortPermissions(sortCriteria.value); // Sort after fetching
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

  void sortPermissions(PermissionSortCriteria criteria) {
    sortCriteria.value = criteria;
    permissions.sort((a, b) {
      switch (criteria) {
        case PermissionSortCriteria.date:
          final dateA = DateTime.tryParse(a['created_at'] ?? '');
          final dateB = DateTime.tryParse(b['created_at'] ?? '');
          if (dateA == null || dateB == null) return 0;
          return dateB.compareTo(dateA); // Newest first
        case PermissionSortCriteria.status:
          final statusA = a['permissent_status'] ?? '';
          final statusB = b['permissent_status'] ?? '';
          return statusA.compareTo(statusB);
        case PermissionSortCriteria.teacher:
          final teacherA = a['teacherInfo'] ?? '';
          final teacherB = b['teacherInfo'] ?? '';
          return teacherA.compareTo(teacherB);
      }
    });
  }

  List<dynamic> get filteredPermissions {
    if (currentFilter.value == 'All') {
      return permissions;
    }
    return permissions.where((p) {
      final status = (p['permissent_status'] ?? 'pending').toLowerCase();
      return status == currentFilter.value.toLowerCase();
    }).toList();
  }

  void setFilter(String filter) {
    currentFilter.value = filter;
  }

  Future<void> deletePermission(String id) async {
    try {
      final response = await http.delete(Uri.parse('$permissionApiUrl/$id'));
      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'deleteSuccess'.tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        permissions.removeWhere((p) => p['_id'] == id);
      } else {
        Get.snackbar(
          'Error',
          'failedToDelete'.tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'failedToDelete'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updatePermission(String id) async {
    if (reasonController.text.trim().isEmpty ||
        startDate == null ||
        endDate == null) {
      Get.snackbar("Error", "Please complete all fields",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      final body = {
        "reason": reasonController.text.trim(),
        "hold_date": [
          startDate!.toUtc().toIso8601String(),
          endDate!.toUtc().toIso8601String(),
        ],
      };

      final response = await http.put(
        Uri.parse('$permissionApiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'updateSuccess'.tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await fetchStudentPermissions();
        clearForm(); // Clear the form state after a successful update
        Get.back();
      } else {
        Get.snackbar(
          'Error',
          'failedToUpdate'.tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'failedToUpdate'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void prepareForEdit(Map<String, dynamic> permission) {
    final holdDates = (permission['hold_date'] as List<dynamic>?)
        ?.map((d) => DateTime.tryParse(d.toString().split("T").first))
        .toList();

    editingPermissionId.value = permission['_id'];
    reasonController.text = permission['reason'] ?? '';
    startDate = holdDates?.isNotEmpty == true ? holdDates!.first : null;
    endDate = holdDates?.length == 2 ? holdDates!.last : null;

    Get.to(() => Permission(email: Get.find<AuthController>().userEmail.value));
  }

  void clearForm() {
    reasonController.clear();
    startDate = null;
    endDate = null;
    editingPermissionId.value = null;
    update();
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }
}
