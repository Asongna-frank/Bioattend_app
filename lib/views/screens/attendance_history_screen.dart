import 'package:bioattend_app/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'base_screen.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          title: Text('Attendance History'),
        ),
        body: Center(
          child: Text('Attendance History Screen'),
        ),
      ),
    );
  }
}
