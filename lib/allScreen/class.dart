import 'package:edtechschool/utils/app_colors.dart';
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
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          'myClasses'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.8,
          ),
        ),
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue));
        }

        if (controller.classes.isEmpty) {
          return Center(
            child: Text(
              'noClassesFound'.tr,
              style: const TextStyle(fontSize: 16, color: AppColors.mediumText),
            ),
          );
        }

        final activeClasses = controller.classes
            .where((c) => c.markAsCompleted == false)
            .toList();
        final allMyClasses =
            controller.classes.where((c) => c.markAsCompleted == true).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (activeClasses.isNotEmpty)
                _buildClassSection(
                    'activeClasses'.tr, activeClasses, AppColors.successGreen),
              const SizedBox(height: 24),
              if (allMyClasses.isNotEmpty)
                _buildClassSection('all_my_classes'.tr, allMyClasses,
                    AppColors.mediumText),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildClassSection(
      String title, List<ClassModel> classes, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        ...classes.map((c) => ClassCard(classData: c)),
      ],
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
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppColors.borderGrey), // Added border for definition
      ),
      child: InkWell(
        onTap: () {
          setState(() => isExpanded = !isExpanded);
          permissionController.selectedClass = widget.classData;
        },
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child:
                        const Icon(Icons.school, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.classData.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.darkText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${'totalStudent'.tr}: ${widget.classData.totalStudent}",
                          style: const TextStyle(
                            color: AppColors.mediumText,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primaryBlue,
                    size: 30,
                  ),
                ],
              ),
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
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Text(
                      'noMatchingStudent'.tr,
                      style: const TextStyle(color: AppColors.declineRed),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    children: matchedStudents.map((studentRecord) {
                      final student = studentRecord.student;
                      return Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.lightFillColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderGrey),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppColors.primaryBlue, width: 2),
                                  ),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(student.image),
                                    radius: 35,
                                    backgroundColor: AppColors.cardBackground,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        student.engName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: AppColors.darkText,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      _buildStudentDetailRow(
                                          'genderLabel'.tr, student.gender),
                                      _buildStudentDetailRow(
                                          'phoneLabel'.tr, student.phoneNumber),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                                height: 32,
                                thickness: 1,
                                color: AppColors.borderGrey),
                            _buildScoreGrid(studentRecord),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        "$label: $value",
        style: const TextStyle(
          color: AppColors.mediumText,
          fontSize: 14,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildScoreGrid(StudentRecord studentRecord) {
    final scoreTiles = [
      _buildScoreTile(
          icon: Icons.edit_note_rounded,
          label: 'class_practice'.tr,
          value: studentRecord.classPractice,
          iconColor: const Color(0xFF42A5F5)),
      _buildScoreTile(
          icon: Icons.menu_book_rounded,
          label: 'work_book'.tr,
          value: studentRecord.workBook,
          iconColor: const Color(0xFF66BB6A)),
      _buildScoreTile(
          icon: Icons.assignment_turned_in_rounded,
          label: 'home_work'.tr,
          value: studentRecord.homeWork,
          iconColor: const Color(0xFFFFB300)),
      _buildScoreTile(
          icon: Icons.check_box_rounded,
          label: 'revision_test'.tr,
          value: studentRecord.revisionTest,
          iconColor: const Color(0xFFE57373)),
      _buildScoreTile(
          icon: Icons.mic_rounded,
          label: 'presentation'.tr,
          value: studentRecord.presentation,
          iconColor: const Color(0xFF9575CD)),
      _buildScoreTile(
          icon: Icons.grade_rounded,
          label: 'assignment_score'.tr,
          value: studentRecord.assignmentScore,
          iconColor: const Color(0xFF81C784)),
      _buildScoreTile(
          icon: Icons.school_rounded,
          label: 'final_exam'.tr,
          value: studentRecord.finalExam,
          iconColor: const Color(0xFF4DB6AC)),
      _buildScoreTile(
          icon: Icons.poll_rounded,
          label: 'total_score'.tr,
          value: studentRecord.totalScore,
          iconColor: const Color(0xFFD4E157)),
      _buildScoreTile(
          icon: Icons.calendar_today_rounded,
          label: 'attendance_score'.tr,
          value: studentRecord.attendanceScore,
          iconColor: const Color(0xFFF06292)),
    ];

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: scoreTiles.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) => scoreTiles[index],
      ),
    );
  }

  Widget _buildScoreTile({
    required IconData icon,
    required String label,
    required dynamic value,
    required Color iconColor,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.borderGrey), // Replaced shadow with a light border
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: iconColor),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.mediumText,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value?.toString() ?? 'N/A',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }
}
