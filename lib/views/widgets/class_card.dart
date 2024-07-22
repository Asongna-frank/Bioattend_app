import 'dart:async'; // Make sure this import is present
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../screens/take_attendance_screen.dart';

class ClassCard extends StatefulWidget {
  final String code;
  final String title;
  final String time;
  final int index;
  final int courseID;
  final String courseName;
  final String courseCode;
  final String startTime;
  final String endTime;

  const ClassCard({
    super.key,
    required this.code,
    required this.title,
    required this.time,
    required this.index,
    required this.courseID,
    required this.courseName,
    required this.courseCode,
    required this.startTime,
    required this.endTime,
  });

  @override
  _ClassCardState createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;
  String status = 'Ongoing';
  Color statusColor = const Color.fromRGBO(28, 90, 64, 1);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _updateStatus();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateStatus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _updateStatus() {
    final now = TimeOfDay.now();
    final startTime = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(widget.startTime));
    final endTime = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(widget.endTime));

    if (_isBefore(now, startTime)) {
      setState(() {
        status = 'Coming';
        statusColor = Colors.blue;
      });
    } else if (_isAfter(now, endTime)) {
      setState(() {
        status = 'Finished';
        statusColor = Colors.grey;
      });
    } else {
      setState(() {
        status = 'Ongoing';
        statusColor = const Color.fromRGBO(28, 90, 64, 1);
      });
    }
  }

  bool _isBefore(TimeOfDay a, TimeOfDay b) {
    return a.hour < b.hour || (a.hour == b.hour && a.minute < b.minute);
  }

  bool _isAfter(TimeOfDay a, TimeOfDay b) {
    return a.hour > b.hour || (a.hour == b.hour && a.minute > b.minute);
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceScreen(
          courseID: widget.courseID,
          courseName: widget.courseName,
          courseCode: widget.courseCode,
          startTime: widget.startTime,
          endTime: widget.endTime,
        ),
      ),
    );
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final startTimeFormatted = DateFormat('hh:mm a').format(DateFormat('HH:mm').parse(widget.startTime));
    final endTimeFormatted = DateFormat('hh:mm a').format(DateFormat('HH:mm').parse(widget.endTime));

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.95).animate(_controller),
        child: Card(
          color: const Color.fromRGBO(248, 248, 249, 1),
          child: Container(
            constraints: const BoxConstraints(minHeight: 100, maxHeight: 120), // Ensures all cards are of the same size
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color.fromRGBO(28, 90, 64, 1),
                child: Text(
                  widget.index.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                '${widget.code}: ${widget.title}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text('$startTimeFormatted | $endTimeFormatted'),
              trailing: Text(
                status,
                style: TextStyle(color: statusColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
