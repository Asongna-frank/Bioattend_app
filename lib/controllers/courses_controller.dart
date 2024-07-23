import 'dart:convert';
import 'package:bioattend_app/global.dart';
import 'package:http/http.dart' as http;

class CoursesController {
  Future<List<Map<String, dynamic>>> getCourses(int studentID) async {
    final response = await http.post(
      Uri.parse("https://biometric-attendance-application.onrender.com/api/courses/student/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"studentID": studentID}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((course) => course as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }
}
