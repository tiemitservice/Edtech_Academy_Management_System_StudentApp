import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final String studentId;

  ProfilePage({required this.studentId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final response = await http.get(
      Uri.parse(
          'http://localhost:3000/api/student/${widget.studentId}/profile'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        profileData = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Profile')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : profileData == null
              ? Center(child: Text('No profile data available'))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Picture
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: profileData!['profilePicture'] != null
                            ? NetworkImage(profileData!['profilePicture'])
                            : null,
                        child: profileData!['profilePicture'] == null
                            ? Icon(Icons.person, size: 50)
                            : null,
                      ),
                      SizedBox(height: 20),
                      // Name
                      Text(
                        profileData!['name'] ?? 'N/A',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      // Gender
                      Text('Gender: ${profileData!['gender'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18)),
                      // Phone Number
                      Text('Phone: ${profileData!['phoneNumber'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18)),
                      // Email
                      Text('Email: ${profileData!['email'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18)),
                      // Address
                      Text('Address: ${profileData!['address'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18)),
                      // Mother's Name
                      Text('Mother: ${profileData!['motherName'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18)),
                      // Father's Name
                      Text('Father: ${profileData!['fatherName'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
    );
  }
}
