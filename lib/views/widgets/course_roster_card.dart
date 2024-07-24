import 'package:flutter/material.dart';

class CourseRosterCard extends StatelessWidget {
  final String courseCode;
  final String courseName;
  final String department;
  final String semester;
  final VoidCallback onTap;

  const CourseRosterCard({
    super.key,
    required this.courseCode,
    required this.courseName,
    required this.department,
    required this.semester,
    required this.onTap,
  });

  String _getFormattedDepartment(String department) {
    switch (department.toLowerCase()) {
      case 'computer':
        return 'Computer Engineering';
      case 'electrical':
        return 'Electrical Engineering';
      case 'mechanical':
        return 'Mechanical Engineering';
      case 'civil':
        return 'Civil Engineering';
      default:
        return department;
    }
  }

  String _getFormattedSemester(String semester) {
    switch (semester.toLowerCase()) {
      case 'first':
        return 'First Semester';
      case 'second':
        return 'Second Semester';
      default:
        return semester;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          title: Text(
            '$courseCode: $courseName',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_getFormattedDepartment(department)),
              Text(_getFormattedSemester(semester)),
            ],
          ),
        ),
      ),
    );
  }
}
