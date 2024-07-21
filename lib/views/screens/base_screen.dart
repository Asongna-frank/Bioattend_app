import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'attendance_history_screen.dart';
import 'view_courses_screen.dart';
import 'profile_screen.dart';
import 'view_students_screen.dart';
import 'package:bioattend_app/global.dart'; // Import global variables

class BaseScreen extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  final bool showBackButton;

  const BaseScreen({
    super.key,
    required this.child,
    required this.currentIndex,
    this.showBackButton = false,
  });

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AttendanceHistoryScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ViewCoursesScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
      case 4: // New case for Student screen, only for lecturers
        if (!isStudent) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ViewStudentsScreen()),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(248, 248, 249, 1),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: widget.currentIndex == 0 ? const Color.fromRGBO(28, 90, 64, 1) : const Color(0xFF333333)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, color: widget.currentIndex == 1 ? const Color.fromRGBO(28, 90, 64, 1) : const Color(0xFF333333)),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: widget.currentIndex == 2 ? const Color.fromRGBO(28, 90, 64, 1) : const Color(0xFF333333)),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: widget.currentIndex == 3 ? const Color.fromRGBO(28, 90, 64, 1) : const Color(0xFF333333)),
            label: 'Profile',
          ),
          if (!isStudent)
            BottomNavigationBarItem(
              icon: Icon(Icons.school, color: widget.currentIndex == 4 ? const Color.fromRGBO(28, 90, 64, 1) : const Color(0xFF333333)),
              label: 'Student',
            ),
        ],
        currentIndex: widget.currentIndex,
        selectedItemColor: const Color.fromRGBO(28, 90, 64, 1),
        onTap: _onItemTapped,
      ),
    );
  }
}
