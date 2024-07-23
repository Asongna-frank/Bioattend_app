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
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF1C5A40),
              child: Text(
                index.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '$courseCode: $courseName',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    date,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Status',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 14,
                    color: status.toLowerCase() == 'present' ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
