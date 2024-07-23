import 'package:bioattend_app/controllers/courses_controller.dart';
import 'package:bioattend_app/global.dart';
import 'package:bioattend_app/views/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'base_screen.dart';
import 'home_screen.dart';

class ViewCoursesScreen extends StatefulWidget {
  const ViewCoursesScreen({super.key});

  @override
  _ViewCoursesScreenState createState() => _ViewCoursesScreenState();
}

class _ViewCoursesScreenState extends State<ViewCoursesScreen> {
  final CoursesController _coursesController = CoursesController();
  List<Map<String, dynamic>> _courses = [];
  List<Map<String, dynamic>> _filteredCourses = [];
  bool _isLoading = true;
  String? _selectedDepartment;
  String? _selectedSemester;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      final courses = await _coursesController.getCourses(studentModel!.id);
      setState(() {
        _courses = courses;
        _filteredCourses = courses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching courses: $e')));
    }
  }

  void _filterCourses() {
    setState(() {
      _filteredCourses = _courses.where((course) {
        final matchesDepartment = _selectedDepartment == null || _selectedDepartment == 'All' || _getFormattedDepartment(course['course']['department']) == _selectedDepartment;
        final matchesSemester = _selectedSemester == null || _selectedSemester == 'All' || _getFormattedSemester(course['course']['semester']) == _selectedSemester;
        final matchesSearch = _searchQuery.isEmpty ||
            course['course']['courseName'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            course['course']['courseCode'].toLowerCase().contains(_searchQuery.toLowerCase());

        return matchesDepartment && matchesSemester && matchesSearch;
      }).toList();
    });
  }

  String _getFormattedDepartment(String department) {
    switch (department) {
      case 'computer':
        return 'Computer Engineering';
      case 'electrical':
        return 'Electrical Engineering';
      case 'mechanical':
        return 'Mechanical Engineering';
      case 'civil':
        return 'Civil Engineering';
      default:
        return department;
    }
  }

  String _getFormattedSemester(String semester) {
    switch (semester) {
      case 'first':
        return 'First Semester';
      case 'second':
        return 'Second Semester';
      default:
        return semester;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          title: const Text('View Courses'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                          _filterCourses();
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search for Course',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButton<String>(
                          value: _selectedDepartment,
                          hint: const Text('Department'),
                          items: <String>['All', 'Computer Engineering', 'Electrical Engineering', 'Mechanical Engineering', 'Civil Engineering'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDepartment = value!;
                              _filterCourses();
                            });
                          },
                        ),
                        DropdownButton<String>(
                          value: _selectedSemester,
                          hint: const Text('Semester'),
                          items: <String>['All', 'First Semester', 'Second Semester'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSemester = value!;
                              _filterCourses();
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredCourses.length,
                        itemBuilder: (context, index) {
                          final course = _filteredCourses[index];
                          return CourseCard(
                            courseCode: course['course']['courseCode'],
                            courseName: course['course']['courseName'],
                            department: _getFormattedDepartment(course['course']['department']),
                            semester: _getFormattedSemester(course['course']['semester']),
                            lecturerName: '${course['lecturer']['user_name']}',
                            lecturerEmail: course['lecturer']['email'],
                            lecturerNumber: course['lecturer']['number'],
                            lecturerImage: course['lecturer']['image'],
                            timetable: List<Map<String, dynamic>>.from(course['timetable']),
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
