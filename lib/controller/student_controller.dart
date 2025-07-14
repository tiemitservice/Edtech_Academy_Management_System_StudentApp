import 'package:get/get.dart';
import '../model/Student.dart'; 
import '../service/student_service.dart'; 

class StudentController extends GetxController {
  final String email;
  var student = Rxn<Student>();
  var isLoading = true.obs;
  StudentController(this.email);

  @override
  void onInit() {
    super.onInit();
    fetchStudentDataByEmail(email);
  }

  void fetchStudentDataByEmail(String email) async {
    try {
      isLoading(true);
      Student data = await StudentService.fetchStudentByEmail(email);
      student.value = data;
    } catch (e) {
      print("Error fetching student by email: $e");
    } finally {
      isLoading(false);
    }
  }
}

