class StudentModel {
  final int id;
  final String matricule;
  final String department;
  final String level;
  final int userId;

  StudentModel({
    required this.id,
    required this.matricule,
    required this.department,
    required this.level,
    required this.userId,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      matricule: json['matricule'],
      department: json['department'],
      level: json['level'],
      userId: json['user'],
    );
  }
}
