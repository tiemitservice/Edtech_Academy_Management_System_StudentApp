import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controller/auth_controller.dart';
import 'homescreen.dart';

class LoginScreen extends StatelessWidget {
  final box = GetStorage();
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isPasswordVisible = false.obs;
  final RxBool rememberMe = false.obs;
  

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/logoEn.svg',
                      width: 130,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Sign in",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Email TextField
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email or Phone Number',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: emailController.text.isEmpty
                      ? "Enter your email or phone number"
                      : null,
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(141, 112, 112, 112)),
                  suffixIcon: const Icon(
                    Icons.email,
                    color: const Color.fromARGB(198, 33, 149, 243),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (_) => {},
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 10),
              // Password TextField
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible.value,
                decoration: InputDecoration(
                  hintText: passwordController.text.isEmpty
                      ? "Enter your password"
                      : null,
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(141, 112, 112, 112),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color.fromARGB(198, 33, 149, 243),
                    ),
                    onPressed: () {
                      isPasswordVisible.value = !isPasswordVisible.value;
                    },
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _handleLogin(context),
              ),
              const SizedBox(height: 10),

              // Remember me & Forgot password
              Row(
                children: [
                  Obx(() => Checkbox(
                        value: rememberMe.value,
                        activeColor:
                            Colors.blue, // Change the check color to blue
                        checkColor: Colors.white,
                        onChanged: (value) {
                          rememberMe.value = value ?? false;
                        },
                      )),
                  const Text("Remember Me"),
                  
                ],
              ),
              const SizedBox(height: 20),

              // Sign In Button
              Obx(() => authController.isLoading.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => _handleLogin(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    final success = await authController.login(email, password);

    if (success) {
      box.write('userEmail', email);
      Get.off(() => HomeScreen(email: email));
    } else {
      emailController.clear();
      passwordController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }
}
