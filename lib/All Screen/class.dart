import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/class_controller.dart';
import '../controller/permission_controller.dart';
import '../model/class_model.dart';


class ClassScreen extends StatefulWidget {
  final String email;
  const ClassScreen({super.key, required this.email});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  static const Color primaryBlue = Color.fromRGBO(20, 105, 199, 1.0);
  final ClassController controller = Get.put(ClassController());

  @override
  void initState() {
    super.initState();
     print('Fetching classes for email: ${widget.email}');
    controller.fetchClassesByEmail(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('My Classes', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryBlue,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: primaryBlue));
        }

        if (controller.classes.isEmpty) {
          return const Center(child: Text('No classes found.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.classes.length,
          itemBuilder: (context, index) {
            final classData = controller.classes[index];
            return ClassCard(classData: classData);
          },
        );
      }),
    );
  }
}

class ClassCard extends StatefulWidget {
  final ClassModel classData;

  const ClassCard({super.key, required this.classData});

  @override
  State<ClassCard> createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color.fromRGBO(20, 105, 199, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Text(
          //   "Staff: 'N/A'}",
          //   style: const TextStyle(
          //     fontSize: 18,
          //     fontWeight: FontWeight.bold,
          //     color: primaryBlue,
          //   ),
          // ),
          // Class header
          ListTile(
            leading: const Icon(Icons.class_, color: primaryBlue),
            title: Text(
              widget.classData.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Total Student: ${widget.classData.totalStudent}"),
            trailing: IconButton(
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() => isExpanded = !isExpanded);
              },
            ),
            onTap: () {
              Get.find<PermissionController>().selectedClass = widget.classData;
              print("Selected class: ${widget.classData.name}");
            },
          ),

          // Expanded student list
          if (isExpanded)
            Column(
              children: widget.classData.students.map((studentRecord) {
                final student = studentRecord.student;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(student.image),
                    backgroundColor: Colors.grey.shade300,
                  ),
                  title: Text(student.khName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Eng: ${student.engName}"),
                      Text("Gender: ${student.gender}"),
                      Text("Phonenumber: ${student.phoneNumber}"),
                      if (studentRecord.totalScore != null)
                        Text("Total Score: ${studentRecord.totalScore!}"),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
