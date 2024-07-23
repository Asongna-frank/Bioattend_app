import 'package:flutter/material.dart';

class AttendanceCard extends StatelessWidget {
  final int index;
  final String name;
  final String courseCode;
  final String courseName;
  final String date;
  final String status;

  const AttendanceCard({
    super.key,
    required this.index,
    required this.name,
    required this.courseCode,
    required this.courseName,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(248, 248, 249, 1),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1C5A40),
          child: Text(
            '$index',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          '$courseCode: $courseName',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(date),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Status:',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              status,
              style: TextStyle(
                color: status.toLowerCase() == 'present' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
