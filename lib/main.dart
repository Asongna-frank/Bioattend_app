import 'package:flutter/material.dart';
import 'package:bioattend_app/views/screens/splash_screen.dart';
import 'package:bioattend_app/views/screens/login_option_screen.dart';
import 'package:bioattend_app/views/screens/home_screen.dart';
import 'package:bioattend_app/views/screens/profile_screen.dart';
import 'package:bioattend_app/views/screens/attendance_history_screen.dart';
import 'package:bioattend_app/views/screens/view_courses_screen.dart';
import 'package:bioattend_app/views/screens/take_attendance_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Attendance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => SplashScreen(), // Splash Screen route
        '/loginOptionScreen': (context) => LoginOptionScreen(), // Login Option Screen route
        '/homeScreen': (context) => HomeScreen(), // Home Screen route
        '/profileScreen': (context) => ProfileScreen(), // Profile Screen route
        '/attendanceHistoryScreen': (context) => AttendanceHistoryScreen(), // Attendance History Screen route
        '/viewCoursesScreen': (context) => ViewCoursesScreen(), // View Courses Screen route
        '/takeAttendance': (context) => AttendanceScreen(), // Take Attendance Screen route
      },
    );
  }
}
