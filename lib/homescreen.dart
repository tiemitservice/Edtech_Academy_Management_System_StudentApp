import 'package:edtechschool/All%20Screen/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'All Screen/attendent.dart';
import 'All Screen/permission.dart';
import 'All Screen/student_score.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final String studentKhName = args?['kh_name'] ?? ' ';
    final String studentEngName = args?['eng_name'] ?? ' ';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: ListTile(
                  leading: const Icon(Icons.language),
                  title: Text('change_lang'.tr),
                  onTap: () {
                    var locale = Get.locale == const Locale('en')
                        ? const Locale('km')
                        : const Locale('en');
                    Get.updateLocale(locale);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: Colors.blue[50],
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Title Section
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    '${'welcome'.tr} ${Get.locale?.languageCode == 'en' ? studentEngName : studentKhName}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),

                // Card 1: Attendance
                GestureDetector(
                  onTap: () {
                    Get.to(() => AttendentScreen(), arguments: args);
                  },
                  child: Card(
                    color: Colors.blue,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.white, size: 40),
                          const SizedBox(width: 16),
                          Text(
                            'Attendance'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Card 2: Student Score
                GestureDetector(
                  onTap: () {
                    Get.to(() => StudentScoreScreen(studentData: args ?? {}));
                  },
                  child: Card(
                    color: Colors.blue,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.score,
                              color: Colors.white, size: 40),
                          const SizedBox(width: 16),
                          Text(
                            'Student Score'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Card 3: Permission
                GestureDetector(
                  onTap: () {
                    Get.to(() => Permission(), arguments: args);
                  },
                  child: Card(
                    color: Colors.blue,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.assignment,
                              color: Colors.white, size: 40),
                          const SizedBox(width: 16),
                          Text(
                            'Permission'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

               GestureDetector(
                  onTap: () {
                    Get.to(() => ProfilePage(studentData: args ?? {}));
                  },
                  child: Card(
                    color: Colors.blue,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.person,
                              color: Colors.white,
                              size: 40), // Changed to person icon
                          const SizedBox(width: 16),
                          Text(
                            'My Profile'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
