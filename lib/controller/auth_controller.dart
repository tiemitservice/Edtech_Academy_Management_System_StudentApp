import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  var isLoading = false.obs; 
  var userEmail = ''.obs; 
  var userName = ''.obs; 
  var authToken = ''.obs; 
  RxString studentId = ''.obs;
  var localStudentId = ''.obs; 
  Future<bool> login(String email, String password) async {
    isLoading.value = true;

    final url = Uri.parse(
        'https://edtech-academy-management-system-server.onrender.com/api/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      isLoading.value = false;

      // Debug logs for troubleshooting
      print('Login Status Code: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Login Success: $data');
        studentId.value = data['_id'] ?? '';
        // Store user data
        userEmail.value = email;
        // Use eng_name from JSON (e.g., "Sok Sophea")
        userName.value = data['eng_name'] ?? '';
        // Store token if provided by API
        if (data['token'] != null) {
          authToken.value = data['token'];
        }

        return true;
      } else {
        // Handle API errors
        final data = jsonDecode(response.body);
        final errorMessage = data['error'] ?? 'Invalid email or password';
        print('Login Failed: $data');
        Get.snackbar(
          'Login Failed',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      print('Login Exception: $e');
      Get.snackbar(
        'Error',
        'Failed to connect to the server. Please check your network.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  /// Logs out the user and clears stored data
  void logout() {
    userEmail.value = '';
    userName.value = '';
    authToken.value = '';
    // Additional cleanup can be added here (e.g., clear cached data)
  }

  /// Provides headers for authenticated API calls
  Map<String, String> get authHeaders => {
        'Content-Type': 'application/json',
        if (authToken.value.isNotEmpty)
          'Authorization': 'Bearer ${authToken.value}',
      };

  get student => null;

  get loggedInStudentId => null;

  @override
  void onClose() {
    // Clean up any resources if needed
    super.onClose();
  }
}
