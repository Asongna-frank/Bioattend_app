import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bioattend_app/global.dart';

class AttendanceController {
  Future<List<Map<String, dynamic>>> getAttendanceHistory(int id) async {
    final String url = isStudent
        ? "https://biometric-attendance-application.onrender.com/api/attendance/student/get_student_attendance/"
        : "https://biometric-attendance-application.onrender.com/api/attendance/lecturer/get_lecturer_attendance/";

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(isStudent ? {"studentID": id} : {"lecturerID": id}),
    );

    print(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(responseData);
    } else {
      throw Exception('Failed to load attendance history');
    }
  }

  Future<Map<String, dynamic>> getCourseDetails(int courseID) async {
    final response = await http.get(
      Uri.parse(
          "https://biometric-attendance-application.onrender.com/api/course/$courseID/"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load course details');
    }
  }
}
