class Student {
  final String id;
  final String khName;
  final String engName;
  final String gender;
  final String phoneNumber;
  final String? email;
  final String? image;
  final String? fatherName;
  final String? motherName;
  final String? dateOfBirth; // Added this line

  // Current Address
  final String? province;
  final String? district;
  final String? commune;
  final String? village;

  // Birth Address
  final String? stBirthProvince;
  final String? stBirthDistrict;
  final String? stBirthCommune;
  final String? stBirthVillage;

  // Family Address
  final String? familyProvince;
  final String? familyDistrict;
  final String? familyCommune;
  final String? familyVillage;

  // Document Info
  final String? documentType;
  final String? documentNumber;
  final String? documentImage;

  // Payment Info
  final String? paymentDate;
  final String? paymentType;
  final String? nextPaymentDate;

  Student({
    required this.id,
    required this.khName,
    required this.engName,
    required this.gender,
    required this.phoneNumber,
    this.email,
    this.image,
    this.fatherName,
    this.motherName,
    this.dateOfBirth, // Added this line
    this.province,
    this.district,
    this.commune,
    this.village,
    this.stBirthProvince,
    this.stBirthDistrict,
    this.stBirthCommune,
    this.stBirthVillage,
    this.familyProvince,
    this.familyDistrict,
    this.familyCommune,
    this.familyVillage,
    this.documentType,
    this.documentNumber,
    this.documentImage,
    this.paymentDate,
    this.paymentType,
    this.nextPaymentDate,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'] ?? '',
      khName: json['kh_name'] ?? '',
      engName: json['eng_name'] ?? '',
      gender: json['gender'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'],
      image: json['image'],
      fatherName: json['father_name'],
      motherName: json['mother_name'],
      dateOfBirth: json['date_of_birth'], // Added this line

      // Current Address
      province: json['province'],
      district: json['district'],
      commune: json['commune'],
      village: json['village'],

      // Birth Address
      stBirthProvince: json['st_birth_province'],
      stBirthDistrict: json['st_birth_district'],
      stBirthCommune: json['st_birth_commune'],
      stBirthVillage: json['st_birth_village'],

      // Family Address
      familyProvince: json['family_province'],
      familyDistrict: json['family_district'],
      familyCommune: json['family_commune'],
      familyVillage: json['family_village'],

      // Document Info
      documentType: json['document_type'],
      documentNumber: json['document_number'],
      documentImage: json['document_image'],

      // Payment Info
      paymentDate: json['payment_date'],
      paymentType: json['payment_type'],
      nextPaymentDate: json['next_payment_date'],
    );
  }
}
