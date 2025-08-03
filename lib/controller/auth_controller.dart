import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var userEmail = ''.obs;
  var userName = ''.obs;
  var authToken = ''.obs;
  var studentId = ''.obs;

  final _storage = const FlutterSecureStorage();

  // Keys for secure storage
  static const _authTokenKey = 'authToken';
  static const _studentIdKey = 'studentId';
  static const _userNameKey = 'userName';
  static const _userEmailKey = 'userEmail';

  @override
  void onInit() {
    super.onInit();
    _tryAutoLogin(); // Check for a saved session when the controller is initialized
  }

  /// Tries to load user data from secure storage to auto-login the user.
  Future<void> _tryAutoLogin() async {
    final token = await _storage.read(key: _authTokenKey);
    if (token == null) {
      return; // No saved token, do nothing.
    }

    // If a token exists, load all user data from secure storage.
    authToken.value = token;
    studentId.value = await _storage.read(key: _studentIdKey) ?? '';
    userName.value = await _storage.read(key: _userNameKey) ?? '';
    userEmail.value = await _storage.read(key: _userEmailKey) ?? '';

    print('Secure auto-login successful for user: ${userName.value}');
  }

  /// Handles user login, saves session data, and returns true on success.
  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    final url = Uri.parse('http://188.166.242.109:5000/api/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        if (token != null) {
          // Update controller's state
          authToken.value = token;
          studentId.value = data['_id'] ?? '';
          userName.value = data['eng_name'] ?? '';
          userEmail.value = email;

          // Save data to secure storage
          await _storage.write(key: _authTokenKey, value: token);
          await _storage.write(key: _studentIdKey, value: studentId.value);
          await _storage.write(key: _userNameKey, value: userName.value);
          await _storage.write(key: _userEmailKey, value: userEmail.value);

          print('Login Success and token saved securely!');
          return true;
        }
      }

      // Handle failed login attempts
      final data = jsonDecode(response.body);
      final errorMessage = data['error'] ?? 'Invalid email or password';
      Get.snackbar(
        'Login Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
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

  /// Logs out the user, clears all data, and navigates to the login screen.
  Future<void> logout() async {
    // Clear state variables
    authToken.value = '';
    userEmail.value = '';
    userName.value = '';
    studentId.value = '';

    // Clear all data from device storage
    await _storage.deleteAll();

    print('User logged out and session data cleared.');

    // **REFINEMENT:** Navigate user back to the login screen after logout.
    Get.offAllNamed('/');
  }

  /// Provides headers for authenticated API calls.
  Map<String, String> get authHeaders => {
        'Content-Type': 'application/json',
        if (authToken.value.isNotEmpty)
          'Authorization': 'Bearer ${authToken.value}',
      };

  /// A simple getter for the logged-in student's ID.
  String get loggedInStudentId => studentId.value;
}
