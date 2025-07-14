// controller/class_controller.dart
import 'package:get/get.dart';
import '../model/class_model.dart';
import '../service/class_service.dart';
import 'auth_controller.dart';

class ClassController extends GetxController {
  var classes = <ClassModel>[].obs;
  var isLoading = false.obs;

  get classList => null;

 Future<void> fetchClassesByEmail(String email) async {
    if (email.isEmpty) {
      // Try getting email from AuthController if it's not passed properly
      final fallbackEmail = Get.find<AuthController>().userEmail.value;
      if (fallbackEmail.isEmpty) {
        print('❌ Email is empty! Cannot fetch classes.');
        return;
      }
      email = fallbackEmail;
    }

    isLoading.value = true;
    try {
      final data = await ClassService.fetchClassDataByEmail(email);
      classes.assignAll(data);
      print(' Fetched ${classes.length} classes for email: $email');
    } catch (e) {
      print(' Error fetching classes: $e');
    } finally {
      isLoading.value = false;
    }
  }

}
