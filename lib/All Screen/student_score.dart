import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentScoreScreen extends StatefulWidget {
  @override
  _StudentScoreScreenState createState() => _StudentScoreScreenState();
}

class _StudentScoreScreenState extends State<StudentScoreScreen> {
  List<dynamic> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudentScores();
  }

  Future<void> fetchStudentScores() async {
    final url = ''; //API URL=================================================
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          students = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load student scores');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching student scores: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Scores'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.blue[50],
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${student['name']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Class: ${student['class']}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Semester Score: ${student['semester_score']}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Classwork Score: ${student['classwork_score']}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Midterm Score: ${student['midterm_score']}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}