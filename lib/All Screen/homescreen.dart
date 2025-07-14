import 'package:edtechschool/All%20Screen/class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controller/auth_controller.dart';
import '../controller/student_controller.dart';
import '../controller/permission_controller.dart';

class HomeScreen extends StatefulWidget {
  final String email;

  const HomeScreen({super.key, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.find<AuthController>();
  final StudentController studentController =
      Get.put(StudentController(GetStorage().read('userEmail') ?? ''));
  final String todayClass = 'View Classes';
  String studentName = '';
  bool isLoading = true;
  final permissionController = Get.find<PermissionController>();

  @override
  void initState() {
    super.initState();
    //Get.put(PermissionController());
    if (authController.userName.value.isNotEmpty) {
      studentName = authController.userName.value;
      isLoading = false;
    } else {
      fetchStudentName();
    }
    permissionController.fetchStudentPermissions();
  }

  Future<void> fetchStudentName() async {
    // Your existing fetchStudentName logic...
    // This part seems fine, so no changes are made here.
    final authController = Get.find<AuthController>();
    try {
      final response = await http.get(
        Uri.parse(
            'https://edtech-academy-management-system-server.onrender.com/api/students'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          setState(() {
            studentName = data[0]['eng_name'] ?? 'Student';
            isLoading = false;
          });
          authController.userName.value = data[0]['eng_name'] ?? '';
        } else {
          setState(() {
            studentName = 'Unknown';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          studentName = 'Error';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        studentName = 'Error';
        isLoading = false;
      });
      print('Error fetching student name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery to get screen size for responsive design
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 105, 199, 1.0),
      drawer: buildDrawer(context), // Extracted drawer for cleanliness
      bottomNavigationBar: buildBottomNavBar(context),
      body: SafeArea(
        child: Column(
          children: [
            // Header section
            buildAppBar(context),
            SizedBox(height: screenHeight * 0.02),
            // Greeting text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome !',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Obx(() {
                        final student = studentController.student.value;
                        return Text(
                          (student?.engName?.isNotEmpty ?? false)
                              ? student!.engName!
                              : 'Student',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }),
                    ],
                  ),
                  Obx(() {
                    final student = studentController.student.value;
                    return CircleAvatar(
                      radius: 30,
                      backgroundImage: (student?.image?.isNotEmpty ?? false)
                          ? NetworkImage(student!.image!)
                          : const AssetImage('assets/profile.jpg')
                              as ImageProvider,
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            // Content section
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.02),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  // Makes the content scrollable on smaller screens
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      const Text(
                        "Today's Class",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      // View Classes Button
                      buildTodayClassButton(),
                      SizedBox(height: screenHeight * 0.025),

                      buildPermissionInfoCard(),
                      SizedBox(height: screenHeight * 0.03),
                      // Action Buttons
                      buildActionButtons(screenWidth),
                      SizedBox(height: screenHeight * 0.03),
                      // Add Permission Button
                      buildAddPermissionButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Extracted Widgets for better readability and maintenance

  Widget buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 28),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          const Spacer(),
          SvgPicture.asset(
            'assets/bigLogoEn.svg',
            width: 200,
            height: 45,
          ),
          const Spacer(),
          SizedBox(width: 48), // To balance the menu icon
        ],
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(20, 105, 199, 1.0),
            ),
            child: Obx(() {
              if (studentController.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.white));
              }
              final student = studentController.student.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/profile',
                          arguments: {'email': widget.email});
                    },
                    child: CircleAvatar(
                      radius: 32,
                      backgroundImage: student != null &&
                              student.image != null &&
                              student.image!.isNotEmpty
                          ? NetworkImage(student.image!)
                          : const AssetImage('assets/profile.jpg')
                              as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    student?.engName ?? 'Unknown',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              );
            }),
          ),
          ListTile(
            leading: const Icon(Icons.home,
                color: Color.fromRGBO(20, 105, 199, 1.0)),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.library_books_outlined,
                color: Color.fromRGBO(20, 105, 199, 1.0)),
            title: const Text('Permission'),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed('/permission_status', arguments: {
                'email': widget.email,
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_border_outlined,
                color: Color.fromRGBO(20, 105, 199, 1.0)),
            title: const Text('Class History'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline,
                color: Color.fromRGBO(20, 105, 199, 1.0)),
            title: const Text('Student Feedback'),
            onTap: () {
            Get.toNamed('/feedback',
                    arguments: authController.userEmail.value);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              GetStorage().remove('userEmail');
              Get.offAllNamed('/');
            },
          ),
        ],
      ),
    );
  }

  Widget buildTodayClassButton() {
    return GestureDetector(
      onTap: () => Get.to(() => ClassScreen(email: widget.email)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(20, 105, 199, 1.0),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              todayClass,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPermissionInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        // onTap: () => Get.to(() => const PresencePage()),
        child: Column(
          children: [
            Obx(() => buildInfoRow(
                  icon: Icons.library_books_outlined,
                  label: "Total Permission",
                  value: "${permissionController.permissions.length}",
                  color: const Color.fromRGBO(20, 105, 199, 1.0),
                )),
            const SizedBox(height: 16),
            Obx(() => buildInfoRow(
                  icon: Icons.cancel_outlined,
                  label: "Absence",
                  value:
                      '${permissionController.permissions.where((p) => p['permissent_status'] == 'rejected').length}',
                  color: Colors.red,
                )),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(
      {required IconData icon,
      required String label,
      required String value,
      required Color color}) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 15,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildActionButtons(double screenWidth) {
    return Row(
      children: [
        Expanded(
          child: buildActionButton(
            icon: Icons.history,
            text1: 'View History',
            text2: 'Permission',
            onTap: () => Get.toNamed('/history_permission'),
          ),
        ),
        SizedBox(width: screenWidth * 0.04), // Responsive spacing
        Expanded(
          child: buildActionButton(
              icon: Icons.class_outlined,
              text1: 'Student',
              text2: 'Feed Back',
             onTap: () {
                Get.toNamed('/feedback',
                    arguments: authController.userEmail.value);
              }),
        ),
      ],
    );
  }

  Widget buildActionButton(
      {required IconData icon,
      required String text1,
      required String text2,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: const Color.fromARGB(255, 84, 84, 84)),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text1,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Color.fromARGB(255, 84, 84, 84)),
                      overflow: TextOverflow.ellipsis),
                  Text(text2,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Color.fromARGB(255, 84, 84, 84)),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 5),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Color.fromARGB(255, 84, 84, 84)),
          ],
        ),
      ),
    );
  }

  Widget buildAddPermissionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Get.toNamed('/permission', arguments: {
            'email': authController.userEmail.value,
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF44D37A),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          "Add Permission",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildBottomNavBar(BuildContext context) {
    return Obx(() {
      final student = studentController.student.value;
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromRGBO(20, 105, 199, 1.0),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        showUnselectedLabels: true,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              Get.toNamed('/permission_status',
                  arguments: {'email': widget.email});
              break;
            case 2:
              Get.toNamed('/profile', arguments: {'email': widget.email});
              break;
          }
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            label: "Permission",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 14,
              backgroundImage: (student?.image?.isNotEmpty ?? false)
                  ? NetworkImage(student!.image!)
                  : const AssetImage('assets/profile.jpg') as ImageProvider,
            ),
            label: "Profile",
          ),
        ],
      );
    });
  }
}
