import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  bool isLoading = false;
  bool _obscurePassword = true;

  Future<bool> loginUser(String email, String phoneNumber) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://edtech-academy-management-system-server.onrender.com/api/students'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Handle different response formats
        List<dynamic> students = [];
        if (data is List) {
          students = data;
        } else if (data['students'] is List) {
          students = data['students'];
        } else if (data['data'] is List) {
          students = data['data'];
        }

        debugPrint('Students data: $students'); // For debugging

        return students.any((student) =>
            student['email']?.toString().toLowerCase() == email.toLowerCase() &&
            student['phoneNumber']?.toString() == phoneNumber);
      } else {
        debugPrint('API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error during login: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Add the logo
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          20), 
                      child: Image.asset(
                        'assets/logo.png',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover, // Adjust as needed
                      ),
                    ),
                  ),
                  SizedBox(height: 20), 
                 
                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'email'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: Icon(Icons.email, color: Colors.blue), 
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email'.tr;
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email'.tr;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Password Field
                  TextFormField(
                    controller: _phoneNumberController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password'.tr;
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters'.tr;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => isLoading = true);

                                try {
                                  final email = _emailController.text.trim();
                                  final phoneNumber =
                                      _phoneNumberController.text.trim();

                                  // 1. First verify login credentials
                                  final loginSuccess =
                                      await loginUser(email, phoneNumber);

                                  if (!loginSuccess) {
                                    Get.snackbar(
                                      'Error'.tr,
                                      'Invalid email or phone number'.tr,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  // 2. If login successful, fetch fresh student data
                                  final response = await http.get(
                                    Uri.parse(
                                        'https://edtech-academy-management-system-server.onrender.com/api/students'),
                                  );

                                  if (response.statusCode != 200) {
                                    throw Exception(
                                        'Failed to fetch student data');
                                  }

                                  final data = jsonDecode(response.body);
                                  List<dynamic> students = [];

                                  // Handle different API response formats
                                  if (data is List) {
                                    students = data;
                                  } else if (data['students'] is List) {
                                    students = data['students'];
                                  } else if (data['data'] is List) {
                                    students = data['data'];
                                  }

                                  // 3. Find the matching student with null safety
                                  final studentData = students.firstWhere(
                                    (student) =>
                                        student['email']
                                                ?.toString()
                                                .toLowerCase() ==
                                            email.toLowerCase() &&
                                        student['phoneNumber']?.toString() ==
                                            phoneNumber,
                                    orElse: () => throw Exception(
                                        'Student not found after successful login'),
                                  );

                                  // 4. Navigate to home page with student data
                                  Get.offAllNamed('/home_page',
                                      arguments: studentData);
                                } on http.ClientException catch (e) {
                                  Get.snackbar(
                                    'Network Error'.tr,
                                    'Please check your internet connection'.tr,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  debugPrint('Network error: $e');
                                } catch (e) {
                                  Get.snackbar(
                                    'Error'.tr,
                                    'An error occurred. Please try again.'.tr,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  debugPrint('Login error: $e');
                                } finally {
                                  if (mounted) {
                                    setState(() => isLoading = false);
                                  }
                                }
                              }
                            },
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'submit'.tr,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
