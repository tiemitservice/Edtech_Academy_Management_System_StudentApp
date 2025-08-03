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
  final PermissionController permissionController =
      Get.find<PermissionController>();

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
        title:
            Text('myClasses'.tr, style: const TextStyle(color: Colors.white)),
        backgroundColor: primaryBlue,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: primaryBlue));
        }

        if (controller.classes.isEmpty) {
          return Center(child: Text('noClassesFound'.tr));
        }

        final activeClasses = controller.classes
            .where((c) => c.markAsCompleted == false)
            .toList();
        final completedClasses =
            controller.classes.where((c) => c.markAsCompleted == true).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (activeClasses.isNotEmpty) ...[
                Text(
                  'activeClasses'.tr,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 37, 184, 42)),
                ),
                const SizedBox(height: 8),
                ...activeClasses.map((c) => ClassCard(classData: c)),
                const SizedBox(height: 24),
              ],
              if (completedClasses.isNotEmpty) ...[
                const SizedBox(height: 8),
                ...completedClasses.map((c) => ClassCard(classData: c)),
              ],
            ],
          ),
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
  final PermissionController permissionController =
      Get.find<PermissionController>();

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
          ListTile(
            leading: const Icon(Icons.class_, color: primaryBlue),
            title: Text(
              widget.classData.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle:
                Text("${'totalStudent'.tr}: ${widget.classData.totalStudent}"),
            trailing: IconButton(
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() => isExpanded = !isExpanded);
              },
            ),
            onTap: () {
              permissionController.selectedClass = widget.classData;
              print("Selected class: ${widget.classData.name}");
            },
          ),
          if (isExpanded)
            Obx(() {
              final matchedStudents = widget.classData.students
                  .where((studentRecord) =>
                      studentRecord.student.id ==
                      permissionController.studentId.value)
                  .toList();

              if (matchedStudents.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('noMatchingStudent'.tr,
                      style: const TextStyle(color: Colors.red)),
                );
              }

              return Column(
                children: matchedStudents.map((studentRecord) {
                  final student = studentRecord.student;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(student.image),
                              radius: 28,
                              backgroundColor: Colors.white,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${'engNameLabel'.tr}: ${student.engName}",
                                    style: TextStyle(color: Colors.blue[900])),
                                Text("${'genderLabel'.tr}: ${student.gender}",
                                    style: TextStyle(color: Colors.blue[900])),
                                Text(
                                    "${'phoneLabel'.tr}: ${student.phoneNumber}",
                                    style: TextStyle(color: Colors.blue[900])),
                              ],
                            ),
                          ],
                        ),
                        const Divider(height: 20, thickness: 1),
                        Wrap(
                          runSpacing: 8,
                          spacing: 12,
                          children: [
                            buildScoreTile(
                                "🎯 ${'scoreLabel'.tr}", studentRecord.score),
                            buildScoreTile("📅 ${'attendanceLabel'.tr}",
                                studentRecord.attendance),
                            buildScoreTile(
                                "📊 ${'totalAttendanceScoreLabel'.tr}",
                                studentRecord.totalAttendanceScore),
                            buildScoreTile("📝 ${'finalLabel'.tr}",
                                studentRecord.finalScore),
                            buildScoreTile("✍️ ${'midtermLabel'.tr}",
                                studentRecord.midtermScore),
                            buildScoreTile("📚 ${'quizLabel'.tr}",
                                studentRecord.quizScore),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            })
        ],
      ),
    );
  }

  Widget buildScoreTile(String title, dynamic value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "$title: ${value ?? 'N/A'}",
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.blue,
        ),
      ),
    );
  }
}
