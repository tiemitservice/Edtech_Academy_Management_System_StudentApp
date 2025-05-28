import 'package:edtechschool/All%20Screen/attendent.dart';
import 'package:edtechschool/All%20Screen/student_score.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'lang_service.dart'; 
import 'package:get_storage/get_storage.dart';
import 'homescreen.dart'; 
import 'ALL Screen/login.dart'; 
import 'ALL Screen/permission.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: LangService(), 
      locale: Locale('en'), 
      fallbackLocale: Locale('en'), 
      initialRoute: '/',
      getPages: [
        GetPage(name: '/a', page: () => LoginPage()),
        GetPage(name: '/home_page', page: () => HomeScreen()),
        GetPage(name: '/', page: () => Permission()),
        GetPage(name: '/student_score', page: () => StudentScoreScreen(
                studentData: Get.arguments as Map<String, dynamic>)),//student_score
        GetPage(name: '/attendent', page: () => AttendentScreen()), 
      ],
    );
  }
}
