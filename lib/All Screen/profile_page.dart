import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> studentData;

  const ProfilePage({required this.studentData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String displayName = Get.locale?.languageCode == 'en'
        ? studentData['eng_name'] ?? 'N/A'
        : studentData['kh_name'] ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'.tr),
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
                      label: 'Gender'.tr,
                      value:
                          studentData['gender']?.toString() ?? 'Not available',
                    ),
                    const Divider(height: 24),

                    // phone Section
                    _buildInfoRow(
                      icon: Icons.check_circle_outline,
                      label: 'phoneNumber'.tr,
                      value: studentData['phoneNumber']?.toString() ??
                         
                          'Not available',
                    ),
                     const Divider(height: 24),

                    // email Section
                    _buildInfoRow(
                      icon: Icons.check_circle_outline,
                      label: 'Email'.tr,
                      value: studentData['email']?.toString() ??
                         
                          'Not available',
                    ),
                     const Divider(height: 24),

                    // address Section
                    _buildInfoRow(
                      icon: Icons.check_circle_outline,
                      label: 'Address'.tr,
                      value: studentData['address']?.toString() ??
                          
                          'Not available',
                    ),
                     const Divider(height: 24),

                    // date_of_birth Section
                    _buildInfoRow(
                      icon: Icons.check_circle_outline,
                      label: 'Date_Of_Birth'.tr,
                      value: studentData['date_of_birth']?.toString() ??
                          
                          'Not available',
                    ),
                     const Divider(height: 24),

                    // father_name Section
                    _buildInfoRow(
                      icon: Icons.check_circle_outline,
                      label: 'Father_name'.tr,
                      value: studentData['father_name']?.toString() ??
                         
                          'Not available',
                    ),
                    const Divider(height: 24),
                    // Mother section
                    _buildInfoRow(
                      icon: Icons.check_circle_outline,
                      label: 'Mother_name'.tr,
                      value: studentData['mother_name']?.toString() ??
                         
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
