import 'package:flutter/material.dart';
import '../screens/take_attendance_screen.dart';

class ClassCard extends StatefulWidget {
  final String code;
  final String title;
  final String time;
  final String status;
  final Color statusColor;
  final int index; // Add an index parameter

  const ClassCard({
    Key? key,
    required this.code,
    required this.title,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.index, // Initialize the index parameter
  }) : super(key: key);

  @override
  _ClassCardState createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AttendanceScreen()),
    );
  }

  void _handleTapCancel() {
    _controller.reverse();
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
          color: Color.fromRGBO(248, 248, 249, 1),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Color.fromRGBO(28, 90, 64, 1),
              child: Text(
                widget.index.toString(), // Use the index to display the number
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text('${widget.code}: ${widget.title}'),
            subtitle: Text(widget.time),
            trailing: Text(
              widget.status,
              style: TextStyle(color: widget.statusColor),
            ),
          ),
        ),
      ),
    );
  }
}
