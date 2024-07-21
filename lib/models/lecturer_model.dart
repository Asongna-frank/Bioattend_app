class LecturerModel {
  final int lecturerID;
  final int user;

  LecturerModel({required this.lecturerID, required this.user});

  factory LecturerModel.fromJson(Map<String, dynamic> json) {
    return LecturerModel(
      lecturerID: json['lecturerID'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lecturerID': lecturerID,
      'user': user,
    };
  }
}
