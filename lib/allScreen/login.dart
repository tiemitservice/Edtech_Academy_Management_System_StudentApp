import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/auth_controller.dart';
import 'homescreen.dart';
import 'package:edtechschool/utils/app_colors.dart';

class LoginScreen extends StatelessWidget {
  final box = GetStorage();
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 60),
            Center(
              child: SvgPicture.asset(
                'assets/logoEn.svg',
                width: 150,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "welcome".tr,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 50),

            // Email/Phone Field
            _buildTextField(
              controller: emailController,
              label: 'email'.tr,
              hint: 'Enter your email or phone number'.tr,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),

            // Password Field
            Obx(() => _buildPasswordField(
                  controller: passwordController,
                  label: 'password'.tr,
                  hint: 'Enter your password'.tr,
                  isPasswordVisible: authController.isPasswordVisible.value,
                  onToggleVisibility: () =>
                      authController.togglePasswordVisibility(),
                  onSubmitted: (_) => _handleLogin(context),
                )),
            const SizedBox(height: 30),

            // Login Button
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: authController.isLoading.value
                        ? null
                        : () => _handleLogin(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: AppColors.cardBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: authController.isLoading.value
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text('submit'.tr,
                            style: GoogleFonts.suwannaphum(
                              // Use GoogleFonts for the button text
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.done,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: const TextStyle(color: AppColors.darkText),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.mediumText),
            prefixIcon: Icon(icon, color: AppColors.primaryBlue, size: 20),
            filled: true,
            fillColor: AppColors.lightBackground,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: AppColors.primaryBlue, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.borderGrey),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isPasswordVisible,
    required VoidCallback onToggleVisibility,
    required Function(String) onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: !isPasswordVisible,
          textInputAction: TextInputAction.done,
          onSubmitted: onSubmitted,
          style: const TextStyle(color: AppColors.darkText),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.mediumText),
            prefixIcon: const Icon(Icons.lock_outlined,
                color: AppColors.primaryBlue, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.primaryBlue,
              ),
              onPressed: onToggleVisibility,
            ),
            filled: true,
            fillColor: AppColors.lightBackground,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: AppColors.primaryBlue, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.borderGrey),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  void _handleLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error'.tr,
        'Please enter both email and password'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.declineRed.withOpacity(0.8),
        colorText: AppColors.cardBackground,
      );
      return;
    }

    final success = await authController.login(email, password);

    if (success) {
      Get.off(() => HomeScreen(email: authController.userEmail.value));
    } else {
      emailController.clear();
      passwordController.clear();
      Get.snackbar(
        'Error'.tr,
        'Invalid email or password'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.declineRed.withOpacity(0.8),
        colorText: AppColors.cardBackground,
      );
    }
  }
}
