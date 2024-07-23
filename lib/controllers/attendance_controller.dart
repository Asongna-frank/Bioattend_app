import 'dart:convert';
import 'package:http/http.dart' as http;

class AttendanceController {
  Future<List<Map<String, dynamic>>> getAttendanceHistory(int studentID) async {
    final response = await http.post(
      Uri.parse("https://biometric-attendance-application.onrender.com/api/attendance/student/get_student_attendance/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"studentID": studentID}),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load attendance history');
    }
  }

  Future<Map<String, dynamic>> getCourseDetails(int courseID) async {
    final response = await http.get(
      Uri.parse("https://biometric-attendance-application.onrender.com/api/course/$courseID/"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load course details');
    }
  }
}
