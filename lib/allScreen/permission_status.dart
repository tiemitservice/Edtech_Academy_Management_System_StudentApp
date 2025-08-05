import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/permission_controller.dart';
import 'package:edtechschool/utils/app_colors.dart';

class Permission_Status extends StatefulWidget {
  const Permission_Status({Key? key, required String email}) : super(key: key);

  @override
  State<Permission_Status> createState() => _Permission_StatusState();
}

class _Permission_StatusState extends State<Permission_Status> {
  final permissionController = Get.find<PermissionController>();

  @override
  void initState() {
    super.initState();
    permissionController.fetchStudentPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "permissionStatusTitle".tr,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.8,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
      ),
      body: Obx(() {
        if (permissionController.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue));
        }

        if (permissionController.permissions.isEmpty) {
          return Center(
            child: Text(
              "noPermissionRequests".tr,
              style: const TextStyle(fontSize: 16, color: AppColors.mediumText),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          itemCount: permissionController.permissions.length,
          itemBuilder: (context, index) {
            final permission = permissionController.permissions[index];
            final reason = permission['reason'] ?? 'noReason'.tr;
            final statusKey =
                (permission['permissent_status'] ?? 'pending').toLowerCase();

            final holdDates = (permission['hold_date'] as List<dynamic>?)
                    ?.map((d) => d.toString().split("T").first)
                    .join(" → ") ??
                '';

            Color statusColor;
            String statusText;

            switch (statusKey) {
              case 'accepted':
                statusColor = AppColors.successGreen;
                statusText = 'statusAccepted'.tr;
                break;
              case 'rejected':
                statusColor = AppColors.declineRed;
                statusText = 'statusRejected'.tr;
                break;
              default:
                statusColor = AppColors.pendingOrange;
                statusText = 'statusPending'.tr;
            }

            return _buildPermissionCard(
              reason: reason,
              dates: holdDates,
              statusText: statusText,
              statusColor: statusColor,
            );
          },
        );
      }),
    );
  }

  Widget _buildPermissionCard({
    required String reason,
    required String dates,
    required String statusText,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "reasonLabel".tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mediumText,
                ),
              ),
              _buildStatusChip(statusText, statusColor),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            reason,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.darkText,
            ),
          ),
          const Divider(height: 24, color: AppColors.borderGrey),
          Row(
            children: [
              const Icon(Icons.calendar_today,
                  size: 16, color: AppColors.mediumText),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "${'dateLabel'.tr}: $dates",
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.mediumText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
