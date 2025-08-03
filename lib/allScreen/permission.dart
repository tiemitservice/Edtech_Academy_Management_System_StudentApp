import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/permission_controller.dart';

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
  late String email;
  @override
  void initState() {
    super.initState();
    email = Get.arguments['email'];
    permissionController.fetchStudentByEmail(email);
    permissionController.reasonController.text = '';
    permissionController.fetchStudentPermissions();
  }

  String formatWithWeekday(DateTime date) {
    return DateFormat('EEEE, dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        title: Text('addPermissionTitle'.tr,
            style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Get.offAllNamed('/home_page', arguments: {'email': widget.email}),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  // Filter for active classes first
                  final activeClasses = permissionController.availableClasses
                      .where((classModel) => classModel.markAsCompleted == true)
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'selectClassLabel'.tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      // Check if there are active classes before building the dropdown
                      if (activeClasses.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Center(
                            child: Text(
                              'noActiveClasses'.tr, // New translation key
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ),
                        )
                      else
                        DropdownButtonFormField<String>(
                          value: permissionController
                                  .selectedClassName.value.isEmpty
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
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2),
                            ),
                          ),
                          validator: (value) =>
                              value == null ? 'selectClassValidator'.tr : null,
                        ),
                      const SizedBox(height: 20),
                    ],
                  );
                }),
                const SizedBox(height: 10),
                Text(
                  'chooseDateLabel'.tr,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade100,
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
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                              if (startDate != null && endDate != null)
                                Text(
                                  '${'dateTo'.tr}\n${formatWithWeekday(endDate!)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Icon(Icons.date_range, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  'reasonLabelWithEmoji'.tr,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: permissionController.reasonController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'reasonHint'.tr,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'reasonValidator'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (permissionController.startDate == null ||
                            permissionController.endDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('invalidDateRangeError'.tr),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (permissionController.endDate!
                            .isBefore(permissionController.startDate!)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('endDateError'.tr),
                              backgroundColor: Colors.red,
                            ),
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
                    child: Text(
                      'submitButton'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(20, 105, 199, 1.0),
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
