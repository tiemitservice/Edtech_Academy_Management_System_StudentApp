import 'package:edtechschool/allScreen/class.dart';
import 'package:edtechschool/utils/app_colors.dart'; // <-- MODIFIED: Import AppColors
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

import '../controller/auth_controller.dart';
import '../controller/language_controller.dart';
import '../controller/student_controller.dart';
import '../controller/permission_controller.dart';

class HomeScreen extends StatefulWidget {
  final String email;

  const HomeScreen({super.key, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ... (controllers and other logic remain the same)
  final AuthController authController = Get.find<AuthController>();
  final StudentController studentController =
      Get.put(StudentController(GetStorage().read('userEmail') ?? ''));
  String studentName = '';
  bool isLoading = true;
  final permissionController = Get.find<PermissionController>();
  final LanguageController languageController = Get.find<LanguageController>();

  @override
  void initState() {
    super.initState();
    if (authController.userName.value.isNotEmpty) {
      studentName = authController.userName.value;
      isLoading = false;
    } else {
      fetchStudentName();
    }
    permissionController.fetchStudentPermissions();
  }

  Future<void> _refreshData() async {
    await fetchStudentName();
    await permissionController.fetchStudentPermissions();
  }

  Future<void> fetchStudentName() async {
    // This function's logic remains the same
    final authController = Get.find<AuthController>();
    try {
      final response = await http.get(
        Uri.parse('http://188.166.242.109:5000/api/students'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          if (mounted) {
            setState(() {
              studentName = data[0]['eng_name'] ?? 'Student';
              isLoading = false;
            });
          }
          authController.userName.value = data[0]['eng_name'] ?? '';
        } else {
          if (mounted) {
            setState(() {
              studentName = 'Unknown';
              isLoading = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            studentName = 'Error';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          studentName = 'Error';
          isLoading = false;
        });
      }
      print('Error fetching student name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.lightBackground, // <-- MODIFIED
      drawer: buildDrawer(context),
      bottomNavigationBar: buildBottomNavBar(context),
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: AppColors.cardBackground, // <-- MODIFIED
          color: AppColors.primaryBlue, // <-- MODIFIED
          onRefresh: _refreshData,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.primaryBlue, // <-- MODIFIED
                pinned: true,
                floating: true,
                automaticallyImplyLeading: false,
                title: buildAppBar(context),
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  background: buildHeader(screenWidth),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "todaysClass".tr,
                        style: GoogleFonts.suwannaphum(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.darkText, // <-- MODIFIED
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      buildTodayClassButton(),
                      SizedBox(height: screenHeight * 0.03),
                      buildPermissionInfoCard(),
                      SizedBox(height: screenHeight * 0.03),
                      buildAddPermissionButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: buildFeedbackButton(context),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu,
                color: AppColors.cardBackground, size: 28), // <-- MODIFIED
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        SvgPicture.asset(
          'assets/bigLogoEn.svg',
          width: 180,
          height: 40,
        ),
        const SizedBox(width: 48), // To balance the menu icon
        Obx(() {
          final student = studentController.student.value;
          return CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.cardBackground, // <-- MODIFIED
            backgroundImage: (student?.image?.isNotEmpty ?? false)
                ? NetworkImage(student!.image!)
                : const AssetImage('assets/profile.jpg') as ImageProvider,
          );
        }),
      ],
    );
  }

  Widget buildHeader(double screenWidth) {
    return Container(
      color: AppColors
          .primaryBlue, // <-- MODIFIED: Ensure header background is consistent
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05)
          .copyWith(top: 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'welcome'.tr,
                  style: GoogleFonts.suwannaphum(
                    color: AppColors.cardBackground
                        .withOpacity(0.8), // <-- MODIFIED
                    fontSize: 16,
                  ),
                ),
                Obx(() {
                  final student = studentController.student.value;
                  return Text(
                    (student?.engName.isNotEmpty ?? false)
                        ? student!.engName
                        : 'student'.tr,
                    style: GoogleFonts.suwannaphum(
                      color: AppColors.cardBackground, // <-- MODIFIED
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  );
                }),
              ],
            ),
          ),
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
              color: AppColors.primaryBlue, // <-- MODIFIED
            ),
            child: Obx(() {
              if (studentController.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.cardBackground)); // <-- MODIFIED
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
                  Flexible(
                    child: Text(
                      student?.engName ?? 'Unknown',
                      style: GoogleFonts.suwannaphum(
                          color: AppColors.cardBackground,
                          fontSize: 24), // <-- MODIFIED
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            }),
          ),
          ListTile(
            leading: const Icon(Icons.home,
                color: AppColors.primaryBlue), // <-- MODIFIED
            title: Text('home'.tr,
                style: GoogleFonts.suwannaphum(
                    color: AppColors.darkText)), // <-- MODIFIED
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.library_books_outlined,
                color: AppColors.primaryBlue), // <-- MODIFIED
            title: Text('Permission'.tr,
                style: GoogleFonts.suwannaphum(
                    color: AppColors.darkText)), // <-- MODIFIED
            onTap: () {
              Navigator.pop(context);
              Get.toNamed('/permission_status', arguments: {
                'email': widget.email,
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline,
                color: AppColors.primaryBlue), // <-- MODIFIED
            title: Text('feedback'.tr,
                style: GoogleFonts.suwannaphum(
                    color: AppColors.darkText)), // <-- MODIFIED
            onTap: () {
              Get.toNamed('/feedback',
                  arguments: authController.userEmail.value);
            },
          ),
          buildLanguageToggle(),
          const Divider(color: AppColors.borderGrey), // <-- MODIFIED
          ListTile(
            leading: const Icon(Icons.logout,
                color: AppColors.declineRed), // <-- MODIFIED
            title: Text('logout'.tr,
                style: GoogleFonts.suwannaphum(
                    color: AppColors.declineRed)), // <-- MODIFIED
            onTap: () {
              GetStorage().remove('userEmail');
              Get.offAllNamed('/');
            },
          ),
        ],
      ),
    );
  }

  Widget buildLanguageToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'language'.tr,
            style: GoogleFonts.suwannaphum(
              color: AppColors.mediumText, // <-- MODIFIED
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => languageController.toggleLanguage(true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: languageController.isEnglish.value
                            ? AppColors.primaryBlue // <-- MODIFIED
                            : AppColors.lightFillColor, // <-- MODIFIED
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '🇺🇸 English',
                          style: GoogleFonts.suwannaphum(
                            color: languageController.isEnglish.value
                                ? AppColors.cardBackground // <-- MODIFIED
                                : AppColors.darkText, // <-- MODIFIED
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => languageController.toggleLanguage(false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !languageController.isEnglish.value
                            ? AppColors.primaryBlue // <-- MODIFIED
                            : AppColors.lightFillColor, // <-- MODIFIED
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '🇰🇭 ខ្មែរ',
                          style: GoogleFonts.suwannaphum(
                            color: !languageController.isEnglish.value
                                ? AppColors.cardBackground // <-- MODIFIED
                                : AppColors.darkText, // <-- MODIFIED
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTodayClassButton() {
    return Card(
      elevation: 4,
      color: AppColors
          .primaryBlue, // <-- MODIFIED: Set a solid color for consistency
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => Get.to(() => ClassScreen(email: widget.email)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'viewClasses'.tr,
                style: GoogleFonts.suwannaphum(
                  color: AppColors.cardBackground, // <-- MODIFIED
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 22,
                color: AppColors.cardBackground, // <-- MODIFIED
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPermissionInfoCard() {
    return Obx(() {
      final absenceCount = permissionController.permissions
          .where((p) => p['permissent_status'] == 'rejected')
          .length;

      return Card(
        elevation: 2,
        color: AppColors.cardBackground, // <-- MODIFIED
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPermissionStat(
                  "totalPermission".tr,
                  '${permissionController.permissions.length}',
                  Icons.library_books_outlined,
                  AppColors.primaryBlue), // <-- MODIFIED
              SizedBox(
                height: 60,
                child: VerticalDivider(
                  color: AppColors.borderGrey, // <-- MODIFIED
                ),
              ),
              _buildPermissionStat("absence".tr, '$absenceCount',
                  Icons.cancel_outlined, AppColors.declineRed), // <-- MODIFIED
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPermissionStat(
      String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.suwannaphum(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.suwannaphum(
            fontSize: 14,
            color: AppColors.mediumText, // <-- MODIFIED
          ),
        ),
      ],
    );
  }

  Widget buildAddPermissionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Get.toNamed('/permission', arguments: {
            'email': authController.userEmail.value,
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.successGreen, // <-- MODIFIED
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        icon: const Icon(Icons.add,
            color: AppColors.cardBackground), // <-- MODIFIED
        label: Text(
          "addPermission".tr,
          style: GoogleFonts.suwannaphum(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.cardBackground, // <-- MODIFIED
          ),
        ),
      ),
    );
  }

  Widget buildFeedbackButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Get.toNamed('/feedback', arguments: authController.userEmail.value);
      },
      backgroundColor: AppColors.primaryBlue, // <-- MODIFIED
      child: const Icon(Icons.message_rounded,
          color: AppColors.cardBackground), // <-- MODIFIED
      tooltip: 'Feedback',
      elevation: 4.0,
    );
  }

  Widget buildBottomNavBar(BuildContext context) {
    return Obx(() {
      final student = studentController.student.value;
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.cardBackground, // <-- MODIFIED
        selectedItemColor: AppColors.primaryBlue, // <-- MODIFIED
        unselectedItemColor: AppColors.mediumText, // <-- MODIFIED
        showUnselectedLabels: true,
        currentIndex: 0,
        selectedLabelStyle: GoogleFonts.suwannaphum(fontSize: 12),
        unselectedLabelStyle: GoogleFonts.suwannaphum(fontSize: 12),
        onTap: (index) {
          switch (index) {
            case 0:
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
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: "home".tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.library_books_outlined),
            label: "Permission".tr,
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 14,
              backgroundImage: (student?.image?.isNotEmpty ?? false)
                  ? NetworkImage(student!.image!)
                  : const AssetImage('assets/profile.jpg') as ImageProvider,
            ),
            label: "My Profile".tr,
          ),
        ],
      );
    });
  }
}
