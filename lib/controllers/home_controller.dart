import 'dart:convert';
import 'package:bioattend_app/global.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeController {
  Future<List<Map<String, dynamic>>> getCardDetails(int studentID, String day) async {
    final response = await http.post(
      Uri.parse("https://biometric-attendance-application.onrender.com/api/timetable/student/get_student_timetable/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"studentID": studentID, "day": day}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // Extract courses and timetable data
      final courses = responseData['courses'] as List<dynamic>;
      final timetable = responseData['timetable'] as List<dynamic>;

      // Create a map to hold course details
      final courseDetailsMap = {
        for (var course in courses)
          course['courseID']: {
            'courseID': course['courseID'],
            'courseName': course['courseName'],
            'courseCode': course['courseCode']
          }
      };

      // Create the final list of objects with course details and times
      final cardDetails = timetable.map((entry) {
        final courseID = entry['course'];
        final courseDetails = courseDetailsMap[courseID];
        return {
          'courseID': courseID,
          'courseName': courseDetails?['courseName'],
          'courseCode': courseDetails?['courseCode'],
          'startTime': entry['start_time'],
          'endTime': entry['end_time'],
        };
      }).toList();

      return cardDetails;
    } else {
      throw Exception('Failed to load timetable');
    }
  }

  final AnimationController profileImageController;

  HomeController({required this.profileImageController});

  Animation<double> get profileImageAnimation =>
      Tween(begin: 1.0, end: 0.95).animate(profileImageController);

  Future<void> animateProfileImage() async {
    await profileImageController.forward();
    profileImageController.reverse();
  }
}
