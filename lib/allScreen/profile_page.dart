import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/student_controller.dart';
import '../service/address_service.dart';
import 'package:edtechschool/utils/app_colors.dart';
import '../model/student.dart';

class ProfilePage extends StatelessWidget {
  final String email;
  final StudentController controller;
  final AddressService addressService = AddressService();

  ProfilePage({super.key, required this.email})
      : controller =
            Get.put(StudentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          "My Profile".tr,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.8,
          ),
        ),
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue));
        }
        if (controller.student.value == null) {
          return Center(child: Text("noStudentData".tr));
        }

        final student = controller.student.value!;

        return FutureBuilder(
          future: addressService.loadAddressData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child:
                      CircularProgressIndicator(color: AppColors.primaryBlue));
            }
            if (snapshot.hasError) {
              return Center(child: Text("errorLoadingAddress".tr));
            }

            final currentAddress = _buildAddressString(
                addressService,
                student.village,
                student.commune,
                student.district,
                student.province);
            final familyAddress = _buildAddressString(
                addressService,
                student.familyVillage,
                student.familyCommune,
                student.familyDistrict,
                student.familyProvince);
            final birthAddress = _buildAddressString(
                addressService,
                student.stBirthVillage,
                student.stBirthCommune,
                student.stBirthDistrict,
                student.stBirthProvince);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProfileHeader(student),
                  const SizedBox(height: 20),
                  _buildPaymentStatusCard(student),
                  const SizedBox(height: 20),
                  _buildDetailsCard(
                      student, currentAddress, familyAddress, birthAddress),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildProfileHeader(Student student) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryBlue, width: 3),
            ),
            child: CircleAvatar(
              radius: 65,
              backgroundColor: AppColors.lightFillColor,
              backgroundImage:
                  student.image != null && student.image!.isNotEmpty
                      ? NetworkImage(student.image!) as ImageProvider
                      : null,
              child: student.image == null || student.image!.isEmpty
                  ? const Icon(Icons.person,
                      size: 70, color: AppColors.mediumText)
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            student.khName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            student.engName,
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.mediumText,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.phone_android,
            label: 'phone'.tr,
            value: student.phoneNumber,
          ),
          _buildInfoRow(
            icon: Icons.mail_outline,
            label: 'email'.tr,
            value: student.email ?? 'notProvided'.tr,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStatusCard(Student student) {
    final nextPaymentDate = student.nextPaymentDate;
    Color paymentStatusColor = AppColors.pendingOrange;
    IconData paymentStatusIcon = Icons.warning_amber_rounded;
    String nextPaymentText = 'noUpcomingPayment'.tr;

    if (nextPaymentDate != null && nextPaymentDate.isNotEmpty) {
      final paymentDate = DateTime.tryParse(nextPaymentDate);
      if (paymentDate != null) {
        final now = DateTime.now();
        final difference = paymentDate.difference(now).inDays;

        if (difference > 7) {
          paymentStatusColor = AppColors.successGreen;
          paymentStatusIcon = Icons.check_circle_outline;
          nextPaymentText = '${'nextPaymentDue'.tr}: $nextPaymentDate';
        } else if (difference >= 0 && difference <= 7) {
          paymentStatusColor = AppColors.pendingOrange;
          paymentStatusIcon = Icons.warning_amber_rounded;
          nextPaymentText = '${'nextPaymentDue'.tr}: $nextPaymentDate';
        } else {
          paymentStatusColor = AppColors.declineRed;
          paymentStatusIcon = Icons.error_outline;
          nextPaymentText = '${'paymentOverdue'.tr}: $nextPaymentDate';
        }
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: paymentStatusColor),
      ),
      child: Row(
        children: [
          Icon(paymentStatusIcon, size: 30, color: paymentStatusColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'paymentStatus'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  nextPaymentText,
                  style: TextStyle(
                    fontSize: 14,
                    color: paymentStatusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(Student student, String currentAddress,
      String familyAddress, String birthAddress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("profileTitle".tr),
          _buildInfoRow(
            icon: Icons.person_outline,
            label: "gender".tr,
            value: student.gender,
          ),
          _buildInfoRow(
            icon: Icons.cake_outlined,
            label: "dateOfBirth".tr,
            value: student.dateOfBirth?.split('T')[0] ?? 'N/A',
          ),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            label: "address".tr,
            value: currentAddress,
          ),
          const Divider(height: 32, color: AppColors.borderGrey),
          _buildSectionTitle("birthDetails".tr),
          _buildInfoRow(
            icon: Icons.location_city_outlined,
            label: "birthplace".tr,
            value: birthAddress,
          ),
          const Divider(height: 32, color: AppColors.borderGrey),
          _buildSectionTitle("familyDetails".tr),
          _buildInfoRow(
            icon: Icons.man_outlined,
            label: "fatherName".tr,
            value: student.fatherName ?? 'N/A',
          ),
          _buildInfoRow(
            icon: Icons.woman_outlined,
            label: "motherName".tr,
            value: student.motherName ?? 'N/A',
          ),
          _buildInfoRow(
            icon: Icons.family_restroom_outlined,
            label: "familyAddress".tr,
            value: familyAddress,
          ),
          
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.mediumText, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.mediumText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkText,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildAddressString(AddressService addressService, String? villageCode,
      String? communeCode, String? districtCode, String? provinceCode) {
    final parts = <String>[];
    final isKhmer = Get.locale?.languageCode == 'km';

    if (villageCode != null && villageCode.isNotEmpty) {
      final villageName = addressService.getVillageName(villageCode);
      parts.add(isKhmer
          ? '${'villageLabel'.tr}$villageName'
          : '$villageName${'villageLabel'.tr}');
    }
    if (communeCode != null && communeCode.isNotEmpty) {
      final communeName = addressService.getCommuneName(communeCode);
      parts.add(isKhmer
          ? '${'communeLabel'.tr}$communeName'
          : '$communeName${'communeLabel'.tr}');
    }
    if (districtCode != null && districtCode.isNotEmpty) {
      final districtName = addressService.getDistrictName(districtCode);
      parts.add(isKhmer
          ? '${'districtLabel'.tr}$districtName'
          : '$districtName${'districtLabel'.tr}');
    }
    if (provinceCode != null && provinceCode.isNotEmpty) {
      final provinceName = addressService.getProvinceName(provinceCode);
      parts.add(isKhmer
          ? '${'provinceLabel'.tr}$provinceName'
          : '$provinceName${'provinceLabel'.tr}');
    }

    if (parts.isEmpty) {
      return 'notProvided'.tr;
    }
    return parts.join(', ');
  }
}
