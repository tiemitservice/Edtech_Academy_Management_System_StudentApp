// Assuming you have a Student model class defined elsewhere
// based on your previous examples.

class ClassModel {
  final String id;
  final String name;
  final List<StudentRecord> students;
  final String staff;
  final bool markAsCompleted;

  ClassModel({
    required this.id,
    required this.name,
    required this.students,
    required this.staff,
    this.markAsCompleted = false,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['_id'],
      name: json['name'],
      students: (json['students'] as List)
          .map((e) => StudentRecord.fromJson(e))
          .toList(),
      staff: json['staff'] ?? '',
      markAsCompleted: json['mark_as_completed'] ?? false,
    );
  }

  int get totalStudent => students.length;

  @override
  String toString() {
    return 'ClassModel(id: $id, name: $name, staff: $staff, students: ${students.length})';
  }
}

class StudentRecord {
  final Student student;
  final String? comments;
  final int attendanceScore;
  final int classPractice;
  final int homeWork;
  final int assignmentScore;
  final int presentation;
  final int revisionTest;
  final int finalExam;
  final int totalScore;
  final int workBook;

  StudentRecord({
    required this.student,
    this.comments,
    this.attendanceScore = 0,
    this.classPractice = 0,
    this.homeWork = 0,
    this.assignmentScore = 0,
    this.presentation = 0,
    this.revisionTest = 0,
    this.finalExam = 0,
    this.totalScore = 0,
    this.workBook = 0,
  });

  factory StudentRecord.fromJson(Map<String, dynamic> json) {
    return StudentRecord(
      student: Student.fromJson(json['student']),
      comments: json['comments'],
      attendanceScore: json['attendance_score'] ?? 0,
      classPractice: json['class_practice'] ?? 0,
      homeWork: json['home_work'] ?? 0,
      assignmentScore: json['assignment_score'] ?? 0,
      presentation: json['presentation'] ?? 0,
      revisionTest: json['revision_test'] ?? 0,
      finalExam: json['final_exam'] ?? 0,
      totalScore: json['total_score'] ?? 0,
      workBook: json['work_book'] ?? 0,
    );
  }
}

class Student {
  final String id;
  final String khName;
  final String engName;
  final String email;
  final String gender;
  final String image;
  final String phoneNumber;

  Student({
    required this.id,
    required this.khName,
    required this.engName,
    required this.email,
    required this.gender,
    required this.image,
    required this.phoneNumber,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'],
      khName: json['kh_name'] ?? '',
      engName: json['eng_name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      image: json['image'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }
}
