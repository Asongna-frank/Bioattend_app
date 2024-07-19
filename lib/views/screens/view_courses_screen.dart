import 'package:bioattend_app/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'base_screen.dart';

class ViewCoursesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 2,
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
          title: Text('View Courses'),
        ),
        body: Center(
          child: Text('View Courses Screen'),
        ),
      ),
    );
  }
}
