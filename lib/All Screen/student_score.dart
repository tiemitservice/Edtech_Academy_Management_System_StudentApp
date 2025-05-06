import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentScoreScreen extends StatelessWidget {
  final Map<String, dynamic> studentData;

  const StudentScoreScreen({required this.studentData, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String displayName = Get.locale?.languageCode == 'en'
        ? studentData['eng_name'] ?? 'N/A'
        : studentData['kh_name'] ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: Text('My Scores'.tr),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        elevation: 0, // Flat look for modern feel
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.blue[100]!],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Name
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue[100],
                          child: Icon(
                            Icons.person,
                            color: Colors.blue[700],
                            size: 30,
                          ),
                          radius: 25,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            displayName,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Score Section
                    _buildInfoRow(
                      icon: Icons.score,
                      label: 'Score'.tr,
                      value:
                          studentData['score']?.toString() ?? 'Not available',
                    ),
                    const Divider(height: 24),

                    // Attendance Section
                    _buildInfoRow(
                      icon: Icons.check_circle_outline,
                      label: 'Attendance'.tr,
                      value: studentData['attendance']?.toString() ??
                          studentData['attendence']?.toString() ??
                          'Not available',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.blue[700],
          size: 28,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
