class StudentModel {
  final int id;
  final String matricule;
  final String department;
  final String level;
  final int user;

  StudentModel({required this.id, required this.matricule, required this.department, required this.level, required this.user});

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      matricule: json['matricule'],
      department: json['department'],
      level: json['level'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matricule': matricule,
      'department': department,
      'level': level,
      'user': user,
    };
  }
}
