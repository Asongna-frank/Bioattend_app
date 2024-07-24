import 'package:flutter/material.dart';
import 'package:bioattend_app/views/widgets/student_card.dart';

class StudentListScreen extends StatelessWidget {
  final Map<String, dynamic> course;

  const StudentListScreen({super.key, required this.course});

  String _getFormattedDepartment(String department) {
    switch (department) {
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
    switch (semester) {
      case 'first':
        return 'First Semester';
      case 'second':
        return 'Second Semester';
      default:
        return semester;
    }
  }

  void _showStudentDetails(BuildContext context, Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(student['user_name']),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('https://biometric-attendance-application.onrender.com${student['image'] ?? ''}'),
              radius: 40,
            ),
            const SizedBox(height: 10),
            Text('Email: ${student['email']}'),
            Text('Phone: ${student['number']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final students = course['students'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${course['courseName']} (${course['courseCode']})',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${_getFormattedDepartment(course['department'])} | ${_getFormattedSemester(course['semester'])}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return StudentCard(
                    studentName: student['user_name'],
                    studentMatricule: student['id'].toString(),
                    department: _getFormattedDepartment(course['department']),
                    studentImage: 'https://biometric-attendance-application.onrender.com${student['image'] ?? ''}',
                    onTap: () {
                      _showStudentDetails(context, student);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
