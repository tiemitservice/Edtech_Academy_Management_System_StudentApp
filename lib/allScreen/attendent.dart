import 'package:flutter/material.dart';

class AttendentScreen extends StatelessWidget {
  final List<Map<String, String>> students = [
    {'name': 'Kakvey', 'status': 'Present'},
    {'name': 'Nyla', 'status': 'Missing'},
    {'name': 'Daren', 'status': 'Present'},
    {'name': 'Vanara', 'status': 'Missing'},
    {'name': 'Siey', 'status': 'Present'},
    {'name': 'Mey', 'status': 'Missing'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.blue[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Student Attendance',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            // Student List
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: Icon(
                        student['status'] == 'Present'
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: student['status'] == 'Present'
                            ? Colors.green
                            : Colors.red,
                      ),
                      title: Text(
                        student['name']!,
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        student['status']!,
                        style: TextStyle(
                          color: student['status'] == 'Present'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}