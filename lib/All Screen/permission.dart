import 'package:flutter/material.dart';

class Permission extends StatefulWidget {
  @override
  _PermissionState createState() => _PermissionState();
}

class _PermissionState extends State<Permission> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Permission Request'),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.blue[50],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  TextFormField(
                    controller: reasonController,
                    decoration: InputDecoration(
                      labelText: 'Reason',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the reason';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Date Selection Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side: Date text and range
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Start Date Text
                            Text(
                              startDate == null
                                  ? 'Start Date: Not Selected'
                                  : 'Start Date: ${startDate!.toLocal()}'
                                      .split(' ')[0],
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),

                            // End Date Text
                            Text(
                              endDate == null
                                  ? 'End Date: Not Selected'
                                  : 'End Date: ${endDate!.toLocal()}'
                                      .split(' ')[0],
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 20),

                            // Date Range Display
                            _buildDateRangeDisplay(),
                          ],
                        ),
                      ),

                      // Right side: Buttons
                      Column(
                        children: [
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    startDate = pickedDate;
                                  });
                                }
                              },
                              child: Text(
                                'Select Start',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: startDate ?? DateTime.now(),
                                  firstDate: startDate ?? DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    endDate = pickedDate;
                                  });
                                }
                              },
                              child: Text(
                                'Select End',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Submit Button
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),



//////////////////////// SUBMIT BUTTON //////////////////////////////
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (startDate == null || endDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Please select both start and end dates')),
                              );
                            } else if (endDate!.isBefore(startDate!)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'End date must be after start date')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Permission Submitted')),
                              );
                            }
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget to display date range and days
  Widget _buildDateRangeDisplay() {
    if (startDate == null || endDate == null) {
      return Text(
        'Date Range: Please select both dates',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      );
    }

    final difference = endDate!.difference(startDate!).inDays + 1;
    if (difference <= 0) {
      return Text(
        'Date Range: End date must be after start date',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      );
    }

    final startDateStr = '${startDate!.toLocal()}'.split(' ')[0];
    final endDateStr = '${endDate!.toLocal()}'.split(' ')[0];
    final daysText = difference == 1 ? '$difference day' : '$difference days';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        SizedBox(height: 4),
        Text(
          'From: $startDateStr',
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue[800],
          ),
        ),
        Text(
          'To: $endDateStr',
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue[800],
          ),
        ),
        Text(
          'Total: $daysText',
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue[800],
          ),
        ),
      ],
    );
  }
}
