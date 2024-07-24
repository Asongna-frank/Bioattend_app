import 'package:flutter/material.dart';
import 'package:bioattend_app/controllers/students_controller.dart';
import 'package:bioattend_app/views/screens/student_list_screen.dart';
import 'package:bioattend_app/views/widgets/course_roster_card.dart';
import 'base_screen.dart';
import 'home_screen.dart';
import 'package:bioattend_app/global.dart';

class ViewStudentsScreen extends StatefulWidget {
  const ViewStudentsScreen({super.key});

  @override
  _ViewStudentsScreenState createState() => _ViewStudentsScreenState();
}

class _ViewStudentsScreenState extends State<ViewStudentsScreen> {
  final StudentsController _studentsController = StudentsController();
  List<Map<String, dynamic>> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCoursesAndStudents();
  }

  Future<void> _fetchCoursesAndStudents() async {
    try {
      final courses = await _studentsController.getCoursesAndStudents(lecturerModel!.lecturerID);
      setState(() {
        _courses = courses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching courses and students: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Class Roster'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Tap on the course to view its class roster',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _courses.length,
                        itemBuilder: (context, index) {
                          final course = _courses[index];
                          return CourseRosterCard(
                            courseCode: course['courseCode'],
                            courseName: course['courseName'],
                            department: course['department'],
                            semester: course['semester'],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudentListScreen(course: course),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
