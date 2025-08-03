class Student {
  final String id;
  final String khName;
  late final String engName;
  final String gender;
  final String phoneNumber;
  final String? email;
  final String? fatherName;
  final String? motherName;
  final String? familyCommune;
  final String? familyDistrict;
  final String? familyProvince;
  final String? familyVillage; 
  final String? image;
  final String? commune;
  final String? district;
  final String? village;
  final String? province;
  Student({
    required this.id,
    required this.khName,
    required this.engName,
    required this.gender,
    required this.phoneNumber,
    this.email,
    this.fatherName,
    this.motherName,
    this.familyCommune,
    this.familyDistrict,
    this.familyProvince,
    this.familyVillage,
    this.province,
    this.image,   
    this.commune,
    this.district,  
    this.village,
    
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
       khName: json['kh_name'] ?? '',
      engName: json['eng_name'] ?? '',
      gender: json['gender'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'],
      fatherName: json['father_name'],
      motherName: json['mother_name'],
      familyCommune: json['family_commune'],
      familyDistrict: json['family_district'],
      familyProvince: json['family_province'],
      familyVillage: json['family_village'],
      image: json['image'], id: '',
      village: json['village'],
      commune: json['commune'],
      district: json['district'],
      province: json['province'],
    );
  }
}
