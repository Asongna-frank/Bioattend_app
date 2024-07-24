import 'dart:convert';
import 'package:bioattend_app/global.dart';
import 'package:http/http.dart' as http;

class CoursesController {
  Future<List<Map<String, dynamic>>> getCourses(int id) async {
    String url = isStudent
        ? "https://biometric-attendance-application.onrender.com/api/courses/student/"
        : "https://biometric-attendance-application.onrender.com/api/courses/lecturer/";

    final response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(isStudent ? {"studentID": id} : {"lecturerID": id}));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData
          .map((course) => course as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }
}
