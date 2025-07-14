import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/permission_controller.dart';

final permissionController = Get.find<PermissionController>();

class Permission extends StatefulWidget {
  final String email;
  const Permission({Key? key, required this.email}) : super(key: key);

  @override
  _PermissionState createState() => _PermissionState();
}

//
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
    //permissionController.fetchPermissionsByEmail(authController.userEmail.value);
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
        title: Text('Add Permission', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Get.offAllNamed('/home_page', arguments: widget.email),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: '📅 Choose Date ',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
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
                        // Update the controller as well
                        permissionController.startDate = picked.start;
                        permissionController.endDate = picked.end;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue), // Blue outline
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
                                    ? 'Choose date'
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
                                  'to\n${formatWithWeekday(endDate!)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Icon(Icons.date_range,
                            color: Colors.blue), // Icon on the right
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25),

                // Reason Field
                RichText(
                  text: TextSpan(
                    text: '📝Reason ',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: permissionController.reasonController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Ex: Sick leave, Personal reasons',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    // No icon for reason field
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.blue), // Blue outline
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Colors.blue, width: 2), // Blue outline
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.blue), // Blue outline
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the reason';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.blue, // Blue outline
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (permissionController.startDate == null ||
                            permissionController.endDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please select a valid date range'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (permissionController.endDate!
                            .isBefore(permissionController.startDate!)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('End date must be after start date'),
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
                      'Submit',
                      style: TextStyle(
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
