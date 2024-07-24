import 'package:bioattend_app/controllers/attendance_controller.dart';
import 'package:bioattend_app/views/widgets/attendance_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bioattend_app/global.dart';
import 'base_screen.dart';
import 'home_screen.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  _AttendanceHistoryScreenState createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  final AttendanceController _attendanceController = AttendanceController();
  List<Map<String, dynamic>> _attendanceHistory = [];
  bool _isLoading = true;
  String? _selectedStatus;
  String? _searchQuery;
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceHistory();
  }

  Future<void> _fetchAttendanceHistory() async {
    try {
      final attendanceHistory = await _attendanceController.getAttendanceHistory(isStudent ? studentModel!.id : lecturerModel!.lecturerID);
      for (var attendance in attendanceHistory) {
        try {
          final courseDetails = await _attendanceController.getCourseDetails(attendance['course']);
          attendance['courseName'] = courseDetails['courseName'];
          attendance['courseCode'] = courseDetails['courseCode'];
        } catch (e) {
          print('Error fetching course details for course ID ${attendance['course']}: $e');
          attendance['courseName'] = 'Unknown Course';
          attendance['courseCode'] = 'Unknown Code';
        }
      }
      setState(() {
        _attendanceHistory = attendanceHistory;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching attendance history: $e')));
    }
  }

  void _filterAttendanceHistory() {
    setState(() {});
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedDateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
        _filterAttendanceHistory();
      });
    }
  }

  List<Map<String, dynamic>> get filteredAttendanceHistory {
    List<Map<String, dynamic>> filteredHistory = _attendanceHistory;

    if (_selectedStatus != null && _selectedStatus != 'All') {
      filteredHistory = filteredHistory.where((attendance) => attendance['status'].toLowerCase() == _selectedStatus!.toLowerCase()).toList();
    }

    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      filteredHistory = filteredHistory.where((attendance) {
        final courseName = attendance['courseName'].toLowerCase();
        final courseCode = attendance['courseCode'].toLowerCase();
        final studentName = attendance['student_name'].toLowerCase();
        final query = _searchQuery!.toLowerCase();
        return courseName.contains(query) || courseCode.contains(query) || studentName.contains(query);
      }).toList();
    }

    if (_selectedDateRange != null) {
      filteredHistory = filteredHistory.where((attendance) {
        final attendanceDate = DateTime.parse(attendance['date']);
        return attendanceDate.isAfter(_selectedDateRange!.start) && attendanceDate.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    return filteredHistory;
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 1,
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
          title: const Text('Attendance History'),
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
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search for Course or Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (value) {
                        _searchQuery = value;
                        _filterAttendanceHistory();
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<String>(
                          hint: const Text('Status'),
                          value: _selectedStatus,
                          items: <String>['All', 'Present', 'Absent'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            _selectedStatus = value;
                            _filterAttendanceHistory();
                          },
                        ),
                        TextButton(
                          onPressed: () => _selectDateRange(context),
                          child: const Text('Date'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your Attendance',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredAttendanceHistory.length,
                        itemBuilder: (context, index) {
                          final attendance = filteredAttendanceHistory[index];
                          String studentImage;
                          String studentName;
                          if (isStudent) {
                            studentImage = 'https://biometric-attendance-application.onrender.com${userModel?.image ?? ''}';
                            studentName = userModel!.userName;
                          } else {
                            studentImage = 'https://biometric-attendance-application.onrender.com${attendance['student_image']}';
                            studentName = attendance['student_name'];
                          }
                          return AttendanceCard(
                            studentName: studentName,
                            courseCode: attendance['courseCode'],
                            courseName: attendance['courseName'],
                            date: DateFormat('EEE d MMM | hh:mm a').format(DateTime.parse(attendance['date'])),
                            status: attendance['status'],
                            studentImage: studentImage,
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
