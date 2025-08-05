import 'package:get/get.dart';
import '../model/student.dart';
import '../service/student_service.dart';
import './auth_controller.dart'; // Import AuthController

class StudentController extends GetxController {
  // Now gets the AuthController to listen for changes
  final AuthController authController = Get.find<AuthController>();

  var student = Rxn<Student>();
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Subscribe to changes in the AuthController's userEmail
    // and fetch student data whenever the email is available.
    ever(authController.userEmail, (String newEmail) {
      if (newEmail.isNotEmpty) {
        _fetchStudentData(newEmail);
      }
    });

    // Also check for the email immediately in case of an auto-login
    if (authController.userEmail.value.isNotEmpty) {
      _fetchStudentData(authController.userEmail.value);
    }
  }

  Future<void> _fetchStudentData(String email) async {
    try {
      isLoading(true);
      // Ensure the email is not empty before making the API call
      if (email.isNotEmpty) {
        Student data = await StudentService.fetchStudentByEmail(email);
        student.value = data;
      }
    } catch (e) {
      print("Error fetching student by email: $e");
      student.value = null; // Set student to null on error
    } finally {
      isLoading(false);
    }
  }

  // Public method for manual refreshes
  Future<void> fetchStudentByEmail() async {
    final currentEmail = authController.userEmail.value;
    if (currentEmail.isNotEmpty) {
      await _fetchStudentData(currentEmail);
    }
  }
}
