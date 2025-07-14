import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controller/student_controller.dart';
import '../service/address_service.dart';
class ProfilePage extends StatelessWidget {
  final String email;
  final StudentController controller;
  final AddressService addressService = AddressService();

  ProfilePage({super.key, required this.email})
      : controller =
            Get.put(StudentController(GetStorage().read('userEmail') ?? ''));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/bigLogoEn.svg',
          width: 230,
          height: 50,
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.student.value == null) {
          return const Center(child: Text("No student data available"));
        }

        final student = controller.student.value!;

        return FutureBuilder(
          future: addressService.loadAddressData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text("Error loading address data"));
            }

            // Student Address
            final province =
                addressService.getProvinceName(student.province ?? '');
            final district =
                addressService.getDistrictName(student.district ?? '');
            final commune =
                addressService.getCommuneName(student.commune ?? '');
            final village =
                addressService.getVillageName(student.village ?? '');
            final formattedAddress =
                '${village} Village, ${commune} Commune, ${district} District, ${province} Province';

            // --- NEW: Family Address ---
            final familyProvince = addressService
                .getFamilyProvinceName(student.familyProvince ?? '');
            final familyDistrict = addressService
                .getFamilyDistrictName(student.familyDistrict ?? '');
            final familyCommune = addressService
                .getFamilyCommuneName(student.familyCommune ?? '');
            final familyVillage = addressService
                .getFamilyVillageName(student.familyVillage ?? '');
            final formattedFamilyAddress =
                '${familyVillage} Village, ${familyCommune} Commune, ${familyDistrict} District, ${familyProvince} Province';

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade200,
                          child: ClipOval(
                            child: student.image != null &&
                                    student.image!.isNotEmpty
                                ? Image.network(
                                    student.image!,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const CircularProgressIndicator();
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.grey,
                                      );
                                    },
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          student.khName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          student.engName,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(Icons.person, "Gender", student.gender),
                        _buildInfoRow(
                            Icons.phone, "Phone", student.phoneNumber),
                        _buildInfoRow(Icons.home, "Address", formattedAddress),
                        _buildInfoRow(Icons.email, "Email",
                            student.email ?? 'Not provided'),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        _buildInfoRow(Icons.man, "Father's Name",
                            student.fatherName ?? 'N/A'),
                        _buildInfoRow(Icons.woman, "Mother's Name",
                            student.motherName ?? 'N/A'),
                        // --- UPDATED: Display Formatted Family Address ---
                        _buildInfoRow(Icons.location_city, "Family Address",
                            formattedFamilyAddress),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
