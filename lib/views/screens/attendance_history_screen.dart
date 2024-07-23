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
  List<Map<String, dynamic>> _filteredAttendanceHistory = [];
  bool _isLoading = true;
  String _selectedStatus = 'All';
  String _searchQuery = '';
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceHistory();
  }

  Future<void> _fetchAttendanceHistory() async {
    try {
      final attendanceHistory = await _attendanceController.getAttendanceHistory(studentModel!.id);
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
        _attendanceHistory = attendanceHistory.reversed.toList(); // Most recent first
        _filteredAttendanceHistory = attendanceHistory.reversed.toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching attendance history: $e')));
    }
  }

  void _filterAttendance() {
    setState(() {
      _filteredAttendanceHistory = _attendanceHistory.where((attendance) {
        final matchesStatus = _selectedStatus == 'All' || attendance['status'] == _selectedStatus.toLowerCase();
        final matchesDateRange = _selectedDateRange == null || (
          DateTime.parse(attendance['date']).isAfter(_selectedDateRange!.start) &&
          DateTime.parse(attendance['date']).isBefore(_selectedDateRange!.end.add(const Duration(days: 1)))
        );
        final matchesSearch = _searchQuery.isEmpty ||
            attendance['courseName'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            attendance['courseCode'].toLowerCase().contains(_searchQuery.toLowerCase());

        return matchesStatus && matchesDateRange && matchesSearch;
      }).toList();
    });
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
        _filterAttendance();
      });
    }
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
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                          _filterAttendance();
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
                          value: _selectedStatus,
                          hint: const Text('Status'),
                          items: <String>['All', 'Present', 'Absent'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value!;
                              _filterAttendance();
                            });
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
                        itemCount: _filteredAttendanceHistory.length,
                        itemBuilder: (context, index) {
                          final attendance = _filteredAttendanceHistory[index];
                          return AttendanceCard(
                            index: index + 1,
                            name: userModel!.userName,
                            courseCode: attendance['courseCode'],
                            courseName: attendance['courseName'],
                            date: DateFormat('EEE d MMM | hh:mm a').format(DateTime.parse(attendance['date'])),
                            status: attendance['status'],
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
