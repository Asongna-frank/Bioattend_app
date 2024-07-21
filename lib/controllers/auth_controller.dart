import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bioattend_app/models/student_model.dart';
import 'package:bioattend_app/models/user_model.dart';
import 'package:bioattend_app/models/lecturer_model.dart';

class AuthController {
  static const String studentLoginUrl =
      "https://biometric-attendance-application.onrender.com/api/auth/login/student/";
  static const String lecturerLoginUrl =
      "https://biometric-attendance-application.onrender.com/api/auth/login/lecturer/";

  Future<Map<String, dynamic>?> login(
      String email, String password, bool isStudent) async {
    print(email);
    print(password);
    print('is student: $isStudent'); //checking for is student value
    final url = isStudent ? studentLoginUrl : lecturerLoginUrl;
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    print(response.body);

    if (response.statusCode == 200) {
      print(
          'response status: ${response.statusCode}'); //checking the status code
      final responseData = jsonDecode(response.body);
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (isStudent) {
        final student = StudentModel.fromJson(responseData['student']);
        print('student: ${student.toJson()}'); // checking for student instance
        prefs.setString('student', jsonEncode(student));
        
      } else {
        final lecturer = LecturerModel.fromJson(responseData['lecturer']);
        print('lecturer: $lecturer'); // checking for lecturer instance
        prefs.setString('lecturer', jsonEncode(lecturer));
      }

      final user = UserModel.fromJson(responseData['user']);
      print('user: $user'); // checking for user instance
      prefs.setString('user', jsonEncode(user));

      return {
        'access': responseData['access'],
        'refresh': responseData['refresh'],
        'user': responseData['user'],
       
      };
    } else {
      return null;
    }
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('access_token', accessToken);
    prefs.setString('refresh_token', refreshToken);
  }
}
