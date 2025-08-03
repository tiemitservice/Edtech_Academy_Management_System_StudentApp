import 'package:edtechschool/allScreen/attendent.dart';
import 'package:edtechschool/controller/auth_controller.dart';
import 'package:edtechschool/controller/class_controller.dart';
import 'package:edtechschool/controller/language_controller.dart'; // Import Language Controller
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'allScreen/History_permission.dart';
import 'allScreen/animation.dart';
import 'allScreen/feedback_page.dart';
import 'allScreen/forgetpass.dart';
import 'allScreen/login.dart';
import 'allScreen/permission.dart';
import 'allScreen/permission_status.dart';
import 'allScreen/profile_page.dart';
import 'controller/permission_controller.dart';
import 'controller/student_controller.dart';
import 'service/lang_service.dart';
import 'package:get_storage/get_storage.dart';
import 'allScreen/homescreen.dart';
import 'allScreen/class.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  Get.put(AuthController());
  Get.put(StudentController(GetStorage().read('userEmail') ?? ''));
  Get.put(PermissionController());
  Get.put(ClassController());
  Get.put(LanguageController()); // Add the language controller**

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Set the default font family for the entire app
        textTheme: GoogleFonts.suwannaphumTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      translations: LangService(),
      // Read the saved language. Default to English ('en') if nothing is saved.
      locale: GetStorage().read('isEnglish') ?? true
          ? const Locale('en')
          : const Locale('km'),
      fallbackLocale: const Locale('en'),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/', page: () => LoginScreen()),
        GetPage(name: '/splash', page: () => const SplashAnimation()),
        GetPage(name: '/attendent', page: () => AttendentScreen()),
        GetPage(name: '/forgetpassword', page: () => ForgetPassword()),
        GetPage(name: '/history_permission', page: () => HistoryPermission()),
        GetPage(
          name: '/permission_status',
          page: () => const Permission_Status(email: '',),
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
