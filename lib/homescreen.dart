import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'All Screen/login.dart';
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
        //title: Text('Ed Tech Acadamy'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton<int>(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              // Language Change Option
              PopupMenuItem(
                value: 1,
                child: ListTile(
                  leading: Icon(Icons.language),
                  title: Text('change_lang'.tr),
                  onTap: () {
                    var locale = Get.locale == Locale('en')
                        ? Locale('km')
                        : Locale('en');
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
        color: Colors.blue[50], // Light blue background
        height: MediaQuery.of(context).size.height, // Ensure full height
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

                // Card 1: Attendent
                GestureDetector(
                  onTap: () {
                    Get.to(() => AttendentScreen());
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
                          Icon(Icons.check_circle,
                              color: Colors.white, size: 40),
                          SizedBox(width: 16),
                          Text(
                            'Attendance'.tr,
                            style: TextStyle(
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
                SizedBox(height: 16),

                // Card 2: Student Score
                GestureDetector(
                  onTap: () {
                    Get.to(() => StudentScoreScreen());
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
                          Icon(Icons.score, color: Colors.white, size: 40),
                          SizedBox(width: 16),
                          Text(
                            'Student Score'.tr,
                            style: TextStyle(
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
                SizedBox(height: 16),

                // Card 3: Permission
                GestureDetector(
                  onTap: () {
                    Get.to(() => Permission());
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
                          Icon(Icons.assignment, color: Colors.white, size: 40),
                          SizedBox(width: 16),
                          Text(
                            'Permission'.tr,
                            style: TextStyle(
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
                SizedBox(height: 16),

                // Card 4: Login
                GestureDetector(
                  onTap: () {
                    Get.to(() => LoginPage());
                  },
                  child: Card(
                    color: Colors.blue,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
