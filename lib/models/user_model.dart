class UserModel {
  final int id;
  final String userName;
  final String email;
  final String number;
  final String role;
  final String? image;

  UserModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.number,
    required this.role,
    required this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userName: json['user_name'],
      email: json['email'],
      number: json['number'],
      role: json['role'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'email': email,
      'number': number,
      'role': role,
      'image': image,
    };
  }
}
