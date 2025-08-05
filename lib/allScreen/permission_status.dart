// lib/allScreen/permission_status.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/permission_controller.dart';
import 'package:edtechschool/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

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
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "permissionStatusTitle".tr,
          style: GoogleFonts.suwannaphum(
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
      body: Column(
        children: [
          _buildFilterAndSortBar(),
          Expanded(
            child: Obx(() {
              final permissionsToShow =
                  permissionController.filteredPermissions;

              if (permissionController.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primaryBlue));
              }

              if (permissionsToShow.isEmpty) {
                return Center(
                  child: Text(
                    "noPermissionRequests".tr,
                    style: GoogleFonts.suwannaphum(
                        fontSize: 16, color: AppColors.mediumText),
                  ),
                );
              }

              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                itemCount: permissionsToShow.length,
                itemBuilder: (context, index) {
                  final permission = permissionsToShow[index];
                  final reason = permission['reason'] ?? 'noReason'.tr;
                  final statusKey =
                      (permission['permissent_status'] ?? 'pending')
                          .toLowerCase();
                  final teacherInfo = permission['teacherInfo'] ?? 'N/A';

                  final holdDates = (permission['hold_date'] as List<dynamic>?)
                          ?.map((d) => d.toString().split("T").first)
                          .join(" → ") ??
                      '';

                  Color statusColor;
                  String statusText;

                  switch (statusKey) {
                    case 'accepted':
                    case 'approved':
                      statusColor = AppColors.successGreen;
                      statusText = 'statusAccepted'.tr;
                      break;
                    case 'rejected':
                    case 'denied':
                      statusColor = AppColors.declineRed;
                      statusText = 'statusRejected'.tr;
                      break;
                    default:
                      statusColor = AppColors.pendingOrange;
                      statusText = 'statusPending'.tr;
                  }

                  return _buildPermissionCard(
                    permission: permission,
                    reason: reason,
                    dates: holdDates,
                    statusText: statusText,
                    statusColor: statusColor,
                    teacherInfo: teacherInfo,
                    isPending: statusKey == 'pending',
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterAndSortBar() {
    return Container(
      height: 60,
      color: AppColors.cardBackground,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Obx(() => Row(
              children: [
                _buildFilterCard(
                  label: 'All'.tr,
                  icon: Icons.all_inclusive,
                  isFilter: true,
                  filterStatus: 'All',
                ),
                _buildFilterCard(
                  label: 'statusPending'.tr,
                  icon: Icons.access_time,
                  isFilter: true,
                  filterStatus: 'pending',
                ),
                _buildFilterCard(
                  label: 'statusAccepted'.tr,
                  icon: Icons.check_circle,
                  isFilter: true,
                  filterStatus: 'accepted',
                ),
                _buildFilterCard(
                  label: 'statusRejected'.tr,
                  icon: Icons.cancel,
                  isFilter: true,
                  filterStatus: 'rejected',
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildFilterCard({
    required String label,
    required IconData icon,
    required bool isFilter,
    String? filterStatus,
    PermissionSortCriteria? sortCriteria,
  }) {
    bool isSelected = false;
    if (isFilter) {
      isSelected = permissionController.currentFilter.value.toLowerCase() ==
          filterStatus!.toLowerCase();
    } else {
      isSelected = permissionController.sortCriteria.value == sortCriteria;
    }

    return GestureDetector(
      onTap: () {
        if (isFilter) {
          permissionController.setFilter(filterStatus!);
        } else {
          permissionController.sortPermissions(sortCriteria!);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : AppColors.darkText,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.suwannaphum(
                color: isSelected ? Colors.white : AppColors.darkText,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionCard({
    required Map<String, dynamic> permission,
    required String reason,
    required String dates,
    required String statusText,
    required Color statusColor,
    required String teacherInfo,
    required bool isPending,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [
          BoxShadow(
            color: AppColors.borderGrey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "reasonLabel".tr,
                      style: GoogleFonts.suwannaphum(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.mediumText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reason,
                      style: GoogleFonts.suwannaphum(
                        fontSize: 16,
                        color: AppColors.darkText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _buildStatusChip(statusText, statusColor),
            ],
          ),
          const Divider(height: 32, color: AppColors.borderGrey),
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: "${'dateLabel'.tr}:",
            value: dates,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.person_outline,
            label: teacherInfo,
            value: "",
          ),
          if (isPending)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      permissionController.prepareForEdit(permission);
                    },
                    icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                    label: Text('editButton'.tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: AppColors.cardBackground,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle:
                          GoogleFonts.suwannaphum(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () =>
                        _showDeleteConfirmationDialog(permission['_id']),
                    icon:
                        const Icon(Icons.delete, size: 18, color: Colors.white),
                    label: Text('deleteButton'.tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.declineRed,
                      foregroundColor: AppColors.cardBackground,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle:
                          GoogleFonts.suwannaphum(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.mediumText),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: GoogleFonts.suwannaphum(
                fontSize: 14,
                color: AppColors.mediumText,
              ),
              children: [
                TextSpan(text: label),
                if (value.isNotEmpty)
                  TextSpan(
                    text: " $value",
                    style: GoogleFonts.suwannaphum(
                      color: AppColors.darkText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
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
        style: GoogleFonts.suwannaphum(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String id) {
    Get.defaultDialog(
      title: 'confirmDelete'.tr,
      titleStyle: GoogleFonts.suwannaphum(
          fontWeight: FontWeight.bold, color: AppColors.darkText),
      contentPadding: const EdgeInsets.all(20),
      middleText: 'confirmDeleteMessage'.tr,
      middleTextStyle:
          GoogleFonts.suwannaphum(color: AppColors.mediumText, fontSize: 16),
      backgroundColor: AppColors.cardBackground,
      radius: 12,
      confirm: ElevatedButton(
        onPressed: () {
          permissionController.deletePermission(id);
          Get.back();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.declineRed,
          foregroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Text('deleteButton'.tr,
            style: GoogleFonts.suwannaphum(fontWeight: FontWeight.bold)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.mediumText,
        ),
        child: Text('no'.tr,
            style: GoogleFonts.suwannaphum(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
