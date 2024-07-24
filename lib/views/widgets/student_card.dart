import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  final String studentName;
  final String studentMatricule;
  final String department;
  final String studentImage;
  final VoidCallback onTap;

  const StudentCard({
    super.key,
    required this.studentName,
    required this.studentMatricule,
    required this.department,
    required this.studentImage,
    required this.onTap,
  });

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
          leading: CircleAvatar(
            backgroundImage: NetworkImage(studentImage),
            radius: 30,
          ),
          title: Text(
            studentName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Matricule: $studentMatricule',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                department,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
