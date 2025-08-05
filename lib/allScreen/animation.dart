import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import 'package:edtechschool/utils/app_colors.dart';

class SplashAnimation extends StatefulWidget {
  const SplashAnimation({super.key});

  @override
  State<SplashAnimation> createState() => _SplashAnimationState();
}

class _SplashAnimationState extends State<SplashAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Reduced duration for faster UX
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Use a slight delay before navigating to give a sense of completion
        Future.delayed(const Duration(milliseconds: 500), () {
          final authController = Get.find<AuthController>();
          if (authController.authToken.isNotEmpty) {
            Get.offNamed('/home_page');
          } else {
            Get.offNamed('/');
          }
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              SvgPicture.asset(
                'assets/logoEn.svg',
                height: 158,
              ),
              const SizedBox(height: 130),
              Text(
                'FOR PARENTS'.tr, // Use translation key for consistency
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryBlue,
                ),
              ),
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [
                    Text('from'.tr, // Use translation key
                        style: const TextStyle(color: AppColors.mediumText)),
                    SvgPicture.asset(
                      'assets/tiem_logo.svg',
                      height: 27,
                      width: 70,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
