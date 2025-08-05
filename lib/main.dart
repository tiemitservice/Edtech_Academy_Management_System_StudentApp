import 'package:edtechschool/allScreen/attendent.dart';
import 'package:edtechschool/controller/auth_controller.dart';
import 'package:edtechschool/controller/class_controller.dart';
import 'package:edtechschool/controller/language_controller.dart';
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
import 'utils/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  Get.put(AuthController());
  Get.put(StudentController());
  Get.put(PermissionController());
  Get.put(ClassController());
  Get.put(LanguageController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isEnglish = GetStorage().read('isEnglish') ?? true;
    final Locale initialLocale =
        isEnglish ? const Locale('en') : const Locale('km');

    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          primary: AppColors.primaryBlue,
          onPrimary: AppColors.onPrimary,
          background: AppColors.lightBackground,
          onBackground: AppColors.darkText,
          error: AppColors.declineRed,
          surface: AppColors.cardBackground,
        ),
        textTheme: GoogleFonts.suwannaphumTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: AppColors.lightBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.onPrimary,
          iconTheme: IconThemeData(color: AppColors.onPrimary),
          centerTitle: true,
          elevation: 0,
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: AppColors.primaryBlue,
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: AppColors.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.suwannaphum(fontWeight: FontWeight.bold),
          ),
        ),
        cardTheme: CardTheme(
          color: AppColors.cardBackground,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.borderGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.primaryBlue, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.borderGrey),
          ),
          labelStyle: GoogleFonts.suwannaphum(color: AppColors.mediumText),
          hintStyle: GoogleFonts.suwannaphum(color: AppColors.mediumText),
        ),
      ),
      debugShowCheckedModeBanner: false,
      translations: LangService(),
      locale: initialLocale,
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
          page: () => const Permission_Status(email: ''),
        ),
        GetPage(
            name: '/home_page',
            page: () => HomeScreen(
                  email: Get.arguments is String ? Get.arguments as String : '',
                )),
        GetPage(
            name: '/profile',
            page: () => ProfilePage(
                  email: Get.arguments is String ? Get.arguments as String : '',
                )),
        GetPage(
            name: '/class',
            page: () => ClassScreen(
                  email: Get.arguments is String ? Get.arguments as String : '',
                )),
        GetPage(
            name: '/permission',
            page: () => Permission(
                  email: Get.arguments is String ? Get.arguments as String : '',
                )),
        GetPage(
          name: '/feedback',
          page: () => FeedbackScreen(
              email: Get.arguments is String ? Get.arguments as String : ''),
        ),
      ],
    );
  }
}
