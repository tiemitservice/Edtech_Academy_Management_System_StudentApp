import 'package:edtechschool/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
  final AuthController authController = Get.find<AuthController>();
  late final StudentController studentController;
  final permissionController = Get.find<PermissionController>();
  final LanguageController languageController = Get.find<LanguageController>();

  @override
  void initState() {
    super.initState();
    studentController = Get.put(StudentController());
    studentController.fetchStudentByEmail();
    permissionController.fetchStudentPermissions();
  }

  Future<void> _refreshData() async {
    await studentController.fetchStudentByEmail();
    await permissionController.fetchStudentPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      drawer: _buildDrawer(context),
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: AppColors.cardBackground,
          color: AppColors.primaryBlue,
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 24),
                  _buildSectionTitle("quickActions".tr),
                  const SizedBox(height: 16),
                  _buildQuickActionCards(),
                  const SizedBox(height: 24),
                  _buildSectionTitle("attendancePermissions".tr),
                  const SizedBox(height: 16),
                  _buildPermissionInfoCard(),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryBlue,
      elevation: 0,
      title: Obx(() {
        final isEnglish = languageController.isEnglish.value;
        return SvgPicture.asset(
          isEnglish ? 'assets/bigLogoEn.svg' : 'assets/bigLogoKh.svg',
          width: 180,
          height: 40,
        );
      }),
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: AppColors.onPrimary),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
        _buildFeedbackButton(context),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Obx(() {
      final student = studentController.student.value;
      final isEnglish = languageController.isEnglish.value;

      return InkWell(
        onTap: () {
          if (student != null) {
            Get.toNamed('/profile', arguments: widget.email);
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderGrey),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: AppColors.lightFillColor,
                backgroundImage: student?.image?.isNotEmpty ?? false
                    ? NetworkImage(student!.image!)
                    : const AssetImage('assets/profile.jpg') as ImageProvider,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'welcome'.tr,
                      style: const TextStyle(
                        color: AppColors.mediumText,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      student == null
                          ? 'student'.tr
                          : isEnglish
                              ? student.engName
                              : student.khName,
                      style: const TextStyle(
                        color: AppColors.darkText,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.arrow_forward_ios, color: AppColors.mediumText),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: AppColors.darkText,
      ),
    );
  }

  Widget _buildQuickActionCards() {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            title: 'viewClasses'.tr,
            icon: Icons.class_rounded,
            onTap: () => Get.toNamed('/class', arguments: widget.email),
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            title: 'addPermission'.tr,
            icon: Icons.add_circle_outline_rounded,
            onTap: () => Get.toNamed('/permission',
                arguments: {'email': authController.userEmail.value}),
            color: AppColors.successGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
      {required String title,
      required IconData icon,
      required VoidCallback onTap,
      required Color color}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.cardBackground, size: 36),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.cardBackground,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionInfoCard() {
    return Obx(() {
      final absenceCount = permissionController.permissions
          .where((p) => p['permissent_status'] == 'rejected')
          .length;
      final totalPermissions = permissionController.permissions.length;

      return InkWell(
        onTap: () {
          // Corrected access to student and email
          Get.toNamed('/permission_status', arguments: {'email': widget.email});
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderGrey),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPermissionStat(
                  "totalPermission".tr,
                  '$totalPermissions',
                  Icons.library_books_outlined,
                  AppColors.primaryBlue,
                ),
                const SizedBox(
                  height: 60,
                  child: VerticalDivider(
                    color: AppColors.borderGrey,
                  ),
                ),
                _buildPermissionStat(
                  "absence".tr,
                  '$absenceCount',
                  Icons.cancel_outlined,
                  AppColors.declineRed,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPermissionStat(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(0.15),
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
              color: AppColors.mediumText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // The buildDrawer method containing the logout ListTile
  Drawer _buildDrawer(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final StudentController studentController = Get.find<StudentController>();
    final LanguageController languageController =
        Get.find<LanguageController>();
    final String email = authController.userEmail.value; // Assuming email is available

    return Drawer(
      child: Container(
        color: AppColors.cardBackground,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(studentController),
            _buildDrawerItem(
              icon: Icons.home_outlined,
              title: 'home'.tr,
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.library_books_outlined,
              title: 'Permission'.tr,
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/permission_status', arguments: {'email': email});
              },
            ),
            _buildDrawerItem(
              icon: Icons.feedback_outlined,
              title: 'feedback'.tr,
              onTap: () {
                Get.toNamed('/feedback',
                    arguments: authController.userEmail.value);
              },
            ),
            _buildLanguageToggle(),
            const Divider(color: AppColors.borderGrey, height: 1),
            _buildDrawerItem(
              icon: Icons.logout,
              title: 'logout'.tr,
              iconColor: AppColors.declineRed,
              titleColor: AppColors.declineRed,
              onTap: () {
                // Show the new confirmation dialog
                _showLogoutDialog(context, authController);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(StudentController studentController) {
    return Obx(() {
      final student = studentController.student.value;
      final isEnglish = languageController.isEnglish.value;

      return UserAccountsDrawerHeader(
        accountName: Text(
          student == null
              ? 'student'.tr
              : isEnglish
                  ? student.engName
                  : student.khName,
          style: GoogleFonts.suwannaphum(
            color: AppColors.cardBackground,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        accountEmail: Text(
          student?.email ?? 'notProvided'.tr,
          style: const TextStyle(color: AppColors.lightFillColor, fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
        currentAccountPicture: GestureDetector(
          onTap: () {
            Get.toNamed('/profile', arguments: authController.userEmail.value);
          },
          child: CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.cardBackground,
            backgroundImage: student?.image?.isNotEmpty ?? false
                ? NetworkImage(student!.image!)
                : const AssetImage('assets/profile.jpg') as ImageProvider,
          ),
        ),
        decoration: const BoxDecoration(
          color: AppColors.primaryBlue,
        ),
      );
    });
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = AppColors.primaryBlue,
    Color titleColor = AppColors.darkText,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: GoogleFonts.suwannaphum(
          color: titleColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildLanguageToggle() {
    final LanguageController languageController =
        Get.find<LanguageController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'language'.tr,
            style: GoogleFonts.suwannaphum(
              color: AppColors.mediumText,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Container(
              decoration: BoxDecoration(
                color: AppColors.lightFillColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderGrey),
              ),
              child: Row(
                children: [
                  _buildLanguageButton(
                    'assets/eng.svg', // Assuming you have an SVG flag asset
                    'English',
                    true,
                    languageController.isEnglish.value,
                    languageController,
                  ),
                  _buildLanguageButton(
                    'assets/kh.svg', // Assuming you have an SVG flag asset
                    'ខ្មែរ',
                    false,
                    !languageController.isEnglish.value,
                    languageController,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// The new, refined helper method for the language buttons
  Widget _buildLanguageButton(
    String iconPath,
    String text,
    bool isEnglish,
    bool isSelected,
    LanguageController languageController,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () => languageController.toggleLanguage(isEnglish),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: GoogleFonts.suwannaphum(
                    color: isSelected
                        ? AppColors.cardBackground
                        : AppColors.darkText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// New helper method for the logout confirmation dialog
  void _showLogoutDialog(BuildContext context, AuthController authController) {
    Get.defaultDialog(
      title: 'logout'.tr,
      titleStyle: GoogleFonts.suwannaphum(
        fontWeight: FontWeight.bold,
        color: AppColors.darkText,
      ),
      contentPadding: const EdgeInsets.all(20),
      middleText: 'areYouSureLogout'.tr,
      middleTextStyle: GoogleFonts.suwannaphum(
        color: AppColors.mediumText,
        fontSize: 16,
      ),
      backgroundColor: AppColors.cardBackground,
      radius: 12,
      confirm: ElevatedButton(
        onPressed: () {
          Get.back(); // Close the dialog
          authController.logout();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.declineRed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Text(
          'yes'.tr,
          style: GoogleFonts.suwannaphum(fontWeight: FontWeight.bold),
        ),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.mediumText,
        ),
        child: Text(
          'no'.tr,
          style: GoogleFonts.suwannaphum(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }


  

  Widget _buildFeedbackButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Get.toNamed('/feedback', arguments: authController.userEmail.value);
      },
      icon: const Icon(Icons.message_rounded, color: AppColors.cardBackground),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Obx(() {
      final student = studentController.student.value;
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.cardBackground,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.mediumText,
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
            icon: const Icon(Icons.home_rounded),
            label: "home".tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.library_books_outlined),
            label: "Permission".tr,
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 14,
              backgroundImage: student?.image?.isNotEmpty ?? false
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
