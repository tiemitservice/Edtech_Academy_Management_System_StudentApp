
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
  final String comment;
  final String? totalScore;
  final int score;
  final int attendance;
  final int totalAttendanceScore;
  final int finalScore;
  final int midtermScore;
  final int quizScore;

  StudentRecord({
    required this.student,
    required this.comment,
    this.totalScore,
    this.score = 0,
    this.attendance = 0,
    this.totalAttendanceScore = 0,
    this.finalScore = 0,
    this.midtermScore = 0,
    this.quizScore = 0,
  });

  factory StudentRecord.fromJson(Map<String, dynamic> json) {
    return StudentRecord(
      student: Student.fromJson(json['student']),
      comment: json['comments'] ?? '',
      score: json['score'] ?? 0,
      attendance: json['attendence'] ?? 0,
      totalAttendanceScore: json['total_attendance_score'] ?? 0,
      finalScore: json['final_score'] ?? 0,
      midtermScore: json['midterm_score'] ?? 0,
      quizScore: json['quiz_score'] ?? 0,
    );
  }

  get total_score => null;
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

