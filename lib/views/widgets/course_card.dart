import 'package:flutter/material.dart';

class CourseCard extends StatefulWidget {
  final String courseCode;
  final String courseName;
  final String department;
  final String semester;
  final String lecturerName;
  final String lecturerEmail;
  final String lecturerNumber;
  final String lecturerImage;
  final List<Map<String, dynamic>> timetable;

  const CourseCard({
    super.key,
    required this.courseCode,
    required this.courseName,
    required this.department,
    required this.semester,
    required this.lecturerName,
    required this.lecturerEmail,
    required this.lecturerNumber,
    required this.lecturerImage,
    required this.timetable,
  });

  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getFormattedDepartment(String department) {
    switch (department.toLowerCase()) {
      case 'mechanical':
        return 'Mechanical Engineering';
      case 'computer':
        return 'Computer Engineering';
      case 'electrical':
        return 'Electrical Engineering';
      case 'civil':
        return 'Civil Engineering';
      default:
        return department;
    }
  }

  String getFormattedSemester(String semester) {
    switch (semester.toLowerCase()) {
      case 'first':
        return 'First Semester';
      case 'second':
        return 'Second Semester';
      default:
        return semester;
    }
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    _showCourseDetails();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  void _showCourseDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${widget.courseCode}: ${widget.courseName}'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(getFormattedDepartment(widget.department)),
            Text(getFormattedSemester(widget.semester)),
            Text(widget.lecturerName),
            const SizedBox(height: 10),
            const Text('Timetable:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...widget.timetable.map((t) => Text(
                '${t['day']} | ${t['room'].replaceAll('_', ' ')} | ${t['start_time']} - ${t['end_time']}')).toList(),
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
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.95).animate(_controller),
        child: Card(
          color: const Color.fromRGBO(248, 248, 249, 1),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF1C5A40),
              child: Text(
                'C',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              '${widget.courseCode}: ${widget.courseName}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${getFormattedDepartment(widget.department)} | ${getFormattedSemester(widget.semester)}'),
                Text('${widget.lecturerName}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
