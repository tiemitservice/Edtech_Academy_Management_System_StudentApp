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

  DateTime? startDate;
  DateTime? endDate;

  final permissionController = Get.find<PermissionController>();

  @override
  void initState() {
    super.initState();
    final String argEmail = Get.arguments['email'] ?? widget.email;
    permissionController.fetchStudentByEmail(argEmail);
    permissionController.reasonController.text = '';
    permissionController.fetchStudentPermissions();
  }

  String formatWithWeekday(DateTime date) {
    return DateFormat('EEEE, dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'addPermissionTitle'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.8,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () =>
              Get.offAllNamed('/home_page', arguments: widget.email),
        ),
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
                _buildClassSelectionSection(),
                const SizedBox(height: 20),
                _buildDateSelectionSection(),
                const SizedBox(height: 25),
                _buildReasonSection(),
                const SizedBox(height: 30),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClassSelectionSection() {
    return Obx(() {
      final activeClasses = permissionController.availableClasses
          .where((classModel) => classModel.markAsCompleted)
          .toList();

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
          if (activeClasses.isEmpty)
            Container(
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
            )
          else
            DropdownButtonFormField<String>(
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
            ),
        ],
      );
    });
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
              initialDateRange: startDate != null && endDate != null
                  ? DateTimeRange(start: startDate!, end: endDate!)
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
                startDate = picked.start;
                endDate = picked.end;
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
                        startDate == null || endDate == null
                            ? 'chooseDateHint'.tr
                            : formatWithWeekday(startDate!),
                        style: TextStyle(
                          fontSize: 16,
                          color: (startDate == null || endDate == null)
                              ? AppColors.mediumText
                              : AppColors.darkText,
                        ),
                      ),
                      if (startDate != null && endDate != null)
                        Text(
                          '${'dateTo'.tr}\n${formatWithWeekday(endDate!)}',
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

  Widget _buildSubmitButton() {
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
              await permissionController.submitPermission();
              permissionController.reasonController.clear();
              permissionController.startDate = null;
              permissionController.endDate = null;
              setState(() {});
            }
          }
        },
        child: Text('submitButton'.tr),
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
