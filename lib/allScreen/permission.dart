// lib/allScreen/permission.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/permission_controller.dart';
import 'package:edtechschool/utils/app_colors.dart';

class Permission extends StatefulWidget {
  final String email;
  const Permission({Key? key, required this.email}) : super(key: key);

  @override
  _PermissionState createState() => _PermissionState();
}

class _PermissionState extends State<Permission> {
  final _formKey = GlobalKey<FormState>();
  final permissionController = Get.find<PermissionController>();

  late final Worker _listener;

  @override
  void initState() {
    super.initState();

    _listener =
        ever(permissionController.editingPermissionId, (String? permissionId) {
      if (mounted) {
        setState(() {
          // This rebuilds the UI to reflect the editing state change.
        });
      }
    });

    if (permissionController.editingPermissionId.value == null) {
      permissionController.clearForm();
      if (mounted) {
        setState(() {});
      }
    }

    permissionController.fetchStudentByEmail(widget.email);
  }

  @override
  void dispose() {
    _listener.dispose(); // This is the crucial fix. It cancels the listener.
    super.dispose();
  }

  String formatWithWeekday(DateTime date) {
    return DateFormat('EEEE, dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = permissionController.editingPermissionId.value != null;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        centerTitle: true,
        title: Text(
          isEditing ? 'editButton'.tr : 'addPermissionTitle'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.8,
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white),
            onPressed: () {
              permissionController.clearForm();
              Get.back();
            }),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildClassSelectionSection(isEditing),
                const SizedBox(height: 20),
                _buildDateSelectionSection(),
                const SizedBox(height: 25),
                _buildReasonSection(),
                const SizedBox(height: 30),
                _buildSubmitButton(isEditing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClassSelectionSection(bool isEditing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'selectClassLabel'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final activeClasses = permissionController.availableClasses
              .where((classModel) => classModel.markAsCompleted)
              .toList();
          if (activeClasses.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightFillColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderGrey),
              ),
              child: Center(
                child: Text(
                  'noActiveClasses'.tr,
                  style: const TextStyle(color: AppColors.mediumText),
                ),
              ),
            );
          } else {
            return DropdownButtonFormField<String>(
              value: permissionController.selectedClassName.value.isEmpty
                  ? null
                  : permissionController.selectedClassName.value,
              hint: Text('selectClassHint'.tr),
              items: activeClasses.map((classModel) {
                return DropdownMenuItem<String>(
                  value: classModel.name,
                  child: Text(classModel.name),
                );
              }).toList(),
              // The fix is here:
              // We enable the onChanged callback for editing.
              onChanged: (value) {
                if (value != null) {
                  permissionController.setSelectedClass(value);
                }
              },
              decoration: _buildInputDecoration(
                hintText: 'selectClassHint'.tr,
              ),
              validator: (value) =>
                  value == null ? 'selectClassValidator'.tr : null,
            );
          }
        }),
      ],
    );
  }

  Widget _buildDateSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'chooseDateLabel'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            final DateTime today = DateTime.now();
            final DateTimeRange? picked = await showDateRangePicker(
              context: context,
              firstDate: today,
              lastDate: DateTime(2100),
              initialDateRange: permissionController.startDate != null &&
                      permissionController.endDate != null
                  ? DateTimeRange(
                      start: permissionController.startDate!,
                      end: permissionController.endDate!)
                  : null,
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppColors.primaryBlue,
                      onPrimary: Colors.white,
                      surface: AppColors.cardBackground,
                      onSurface: AppColors.darkText,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              setState(() {
                permissionController.startDate = picked.start;
                permissionController.endDate = picked.end;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.lightFillColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        permissionController.startDate == null ||
                                permissionController.endDate == null
                            ? 'chooseDateHint'.tr
                            : formatWithWeekday(
                                permissionController.startDate!),
                        style: TextStyle(
                          fontSize: 16,
                          color: (permissionController.startDate == null ||
                                  permissionController.endDate == null)
                              ? AppColors.mediumText
                              : AppColors.darkText,
                        ),
                      ),
                      if (permissionController.startDate != null &&
                          permissionController.endDate != null &&
                          permissionController.startDate !=
                              permissionController.endDate)
                        Text(
                          '${'dateTo'.tr}\n${formatWithWeekday(permissionController.endDate!)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.darkText,
                          ),
                        ),
                    ],
                  ),
                ),
                const Icon(Icons.calendar_today_rounded,
                    color: AppColors.primaryBlue),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReasonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'reasonLabelWithEmoji'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: permissionController.reasonController,
          maxLines: 4,
          style: const TextStyle(color: AppColors.darkText),
          decoration: _buildInputDecoration(
            hintText: 'reasonHint'.tr,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'reasonValidator'.tr;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton(bool isEditing) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.cardBackground,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (permissionController.startDate == null ||
                permissionController.endDate == null) {
              Get.snackbar(
                'Error'.tr,
                'invalidDateRangeError'.tr,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.declineRed.withOpacity(0.8),
                colorText: AppColors.cardBackground,
              );
            } else if (permissionController.endDate!
                .isBefore(permissionController.startDate!)) {
              Get.snackbar(
                'Error'.tr,
                'endDateError'.tr,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.declineRed.withOpacity(0.8),
                colorText: AppColors.cardBackground,
              );
            } else {
              if (isEditing) {
                await permissionController.updatePermission(
                    permissionController.editingPermissionId.value!);
              } else {
                await permissionController.submitPermission();
              }
              permissionController.clearForm();
            }
          }
        },
        child: Text(isEditing ? 'updateButton'.tr : 'submitButton'.tr),
      ),
    );
  }

  InputDecoration _buildInputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.mediumText),
      filled: true,
      fillColor: AppColors.lightFillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderGrey),
      ),
    );
  }
}
