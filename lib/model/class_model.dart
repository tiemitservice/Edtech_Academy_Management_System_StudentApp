
class ClassModel {
  final String id;
  final String name;
  final List<StudentRecord> students;
  final String staff;

  ClassModel({
    required this.id,
    required this.name,
    required this.students,
    required this.staff,

  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['_id'],
      name: json['name'],
      students: (json['students'] as List)
          .map((e) => StudentRecord.fromJson(e))
          .toList(),
      staff: json['staff'] ?? '',
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

  StudentRecord({
    required this.student,
    required this.comment,
    this.totalScore,
  });

  factory StudentRecord.fromJson(Map<String, dynamic> json) {
    return StudentRecord(
      student: Student.fromJson(json['student']),
      comment: json['comments'] ?? '',
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

