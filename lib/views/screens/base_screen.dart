import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'attendance_history_screen.dart';
import 'view_courses_screen.dart';
import 'profile_screen.dart';
import 'package:bioattend_app/models/user_model.dart';

class BaseScreen extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  final bool showBackButton;

  const BaseScreen({Key? key, required this.child, required this.currentIndex, this.showBackButton = false}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {

    void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AttendanceHistoryScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ViewCoursesScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(248, 248, 249, 1),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: widget.currentIndex == 0 ? Color.fromRGBO(28, 90, 64, 1) : Color(0xFF333333)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, color: widget.currentIndex == 1 ? Color.fromRGBO(28, 90, 64, 1) : Color(0xFF333333)),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: widget.currentIndex == 2 ? Color.fromRGBO(28, 90, 64, 1) : Color(0xFF333333)),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: widget.currentIndex == 3 ? Color.fromRGBO(28, 90, 64, 1) : Color(0xFF333333)),
            label: 'Profile',
          ),
        ],
        currentIndex: widget.currentIndex,
        selectedItemColor: Color.fromRGBO(28, 90, 64, 1),
        onTap: _onItemTapped,
      ),
    );
  }
}
