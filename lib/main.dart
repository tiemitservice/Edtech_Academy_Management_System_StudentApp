import 'package:edtechschool/All%20Screen/attendent.dart';
import 'package:edtechschool/controller/auth_controller.dart';
import 'package:edtechschool/controller/class_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'All Screen/History_permission.dart';
import 'All Screen/animation.dart';
import 'All Screen/feedback_page.dart';
import 'All Screen/forgetpass.dart';
import 'All Screen/login.dart';
import 'All Screen/permission.dart';
import 'All Screen/permission_status.dart';
import 'All Screen/profile_page.dart';
import 'controller/permission_controller.dart';
import 'controller/student_controller.dart';
import 'service/lang_service.dart';
import 'package:get_storage/get_storage.dart';
import 'All Screen/homescreen.dart';
import '../All Screen/class.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  Get.put(AuthController());
  Get.put(StudentController(GetStorage().read('userEmail') ?? ''));
  Get.put(PermissionController());
  Get.put(ClassController());
 
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
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/', page: () => LoginScreen()),
        GetPage(name: '/splash', page: () => const SplashAnimation()),
        GetPage(name: '/attendent', page: () => AttendentScreen()),
        GetPage(name: '/forgetpassword', page: () => ForgetPassword()),
        GetPage(name: '/history_permission', page: () => HistoryPermission()),
        GetPage(name: '/permission_status',page: () => const Permission_Status(),
        ),
        //page have connection with email
        GetPage(
            name: '/home_page',
            page: () => HomeScreen(
                  email: '',
                )),
        GetPage(
            name: '/profile',
            page: () => ProfilePage(
                  email: '',
                )),
        GetPage(
            name: '/class',
            page: () => ClassScreen(
                  email: '',
                )),
        GetPage(
            name: '/permission',
            page: () => Permission(
                  email: '',
                )),

        GetPage(
          name: '/feedback',
          page: () {
            final email = Get.arguments as String;
            return FeedbackScreen(email: email);
          },
        ),
      ],
    );
  }
}
