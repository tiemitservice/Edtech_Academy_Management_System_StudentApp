import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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
      duration: const Duration(seconds: 3),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkAuthAndNavigate();
      }
    });

    _controller.forward();
  }

  // This is where the token is read from storage
  Future<void> _checkAuthAndNavigate() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'authToken');

    if (!mounted) return;

    if (token != null) {
      // If token exists, go to home
      Get.offNamed('/home_page');
    } else {
      // If no token, go to login
      Get.offNamed('/');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              SvgPicture.asset(
                'assets/logoEn.svg', // Make sure this asset exists
                height: 158,
              ),
              const SizedBox(height: 130),
              const Text(
                'FOR PARENTS',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Color.fromRGBO(20, 105, 199, 1.0),
                ),
              ),
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [
                    const Text('from',
                        style: TextStyle(
                            color: Color.fromARGB(255, 108, 108, 108))),
                    SvgPicture.asset(
                      'assets/tiem_logo.svg', // Make sure this asset exists
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
