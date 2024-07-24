import 'dart:convert';
import 'package:bioattend_app/global.dart';
import 'package:http/http.dart' as http;

class StudentsController {
  Future<List<Map<String, dynamic>>> getCoursesAndStudents(int lecturerID) async {
    final response = await http.post(
      Uri.parse("https://biometric-attendance-application.onrender.com/api/classroster/get_class_roster/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"lecturerID": lecturerID}),
    );

    print(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((course) => course as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load courses and students');
    }
  }
}
