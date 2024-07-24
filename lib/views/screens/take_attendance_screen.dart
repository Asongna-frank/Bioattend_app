import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:bioattend_app/global.dart';
import 'package:http/http.dart' as http;
import 'package:app_settings/app_settings.dart';
import 'home_screen.dart';
import 'attendance_history_screen.dart';

class AttendanceScreen extends StatefulWidget {
  final int courseID;
  final String courseName;
  final String courseCode;
  final String startTime;
  final String endTime;

  const AttendanceScreen({
    super.key,
    required this.courseID,
    required this.courseName,
    required this.courseCode,
    required this.startTime,
    required this.endTime,
  });

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late Timer _timer;
  String _formattedTime = '';
  String _formattedDate = '';
  final LocalAuthentication auth = LocalAuthentication();
  bool _isSessionActive = false;

  @override
  void initState() {
    super.initState();
    _formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    _formattedDate = DateFormat('MMM dd, yyyy - EEEE').format(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _formattedTime = DateFormat('hh:mm a').format(DateTime.now());
        _formattedDate =
            DateFormat('MMM dd, yyyy - EEEE').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _authenticateAndNavigate() async {
    if (isStudent) {
      // Student authentication and navigation
      bool authenticated = false;
      try {
        final bool canAuthenticateWithBiometrics =
            await auth.canCheckBiometrics;
        final bool canAuthenticate =
            canAuthenticateWithBiometrics || await auth.isDeviceSupported();
        if (!canAuthenticate) {
          return;
        }

        final List<BiometricType> availableBiometrics =
            await auth.getAvailableBiometrics();

        if (availableBiometrics.isEmpty) {
          return;
        }

        authenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to take attendance',
          options: const AuthenticationOptions(
            biometricOnly: true,
          ),
        );
      } on Exception catch (e) {
        print('Authentication error: $e');
      }

      if (!authenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication failed or not set up.')),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication successful!')),
      );

      // Open WiFi settings
      AppSettings.openAppSettings(type: AppSettingsType.wifi);

      // Check WiFi connection status
      WiFiForIoTPlugin.isConnected().then((isConnected) async {
        if (isConnected) {
          print('Student ID: ${studentModel?.id}');
          print('Course ID: ${widget.courseID}');
          await _postAttendanceData();
          _showSuccessMessage();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to connect to the network.')),
          );
        }
      });
    } else {
      // Lecturer session management
      if (_isSessionActive) {
        _endSession();
      } else {
        _startSession();
      }
    }
  }

  Future<void> _postAttendanceData() async {
    final url = 'https://biometric-attendance-application.onrender.com/api/attendance/';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "date": DateTime.now().toIso8601String(),
        "status": "present",
        "student": studentModel?.id,
        "course": widget.courseID,
      }),
    );

    if (response.statusCode == 200) {
      print('Attendance data posted successfully.');
      print(response.body);
    } else {
      print('Failed to post attendance data. Status code: ${response.statusCode}');
      print(response.body);
    }
  }

  void _showSuccessMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Authentication successful!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const AttendanceHistoryScreen()),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _startSession() {
    AppSettings.openAppSettings(type: AppSettingsType.hotspot);
    setState(() {
      _isSessionActive = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please turn on the hotspot.')),
    );
  }

  void _endSession() {
    AppSettings.openAppSettings(type: AppSettingsType.hotspot);
    setState(() {
      _isSessionActive = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please turn off the hotspot.')),
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
    return false;
  }

  bool get _isOngoing {
    final now = TimeOfDay.now();
    final startTime =
        TimeOfDay.fromDateTime(DateFormat('HH:mm:ss').parse(widget.startTime));
    final endTime =
        TimeOfDay.fromDateTime(DateFormat('HH:mm:ss').parse(widget.endTime));
    return _isAfter(now, startTime) && _isBefore(now, endTime);
  }

  bool _isBefore(TimeOfDay a, TimeOfDay b) {
    return a.hour < b.hour || (a.hour == b.hour && a.minute < b.minute);
  }

  bool _isAfter(TimeOfDay a, TimeOfDay b) {
    return a.hour > b.hour || (a.hour == b.hour && a.minute > b.minute);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          title: const Text(
            'Take Attendance',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                'https://biometric-attendance-application.onrender.com${userModel?.image ?? ''}',
              ),
            ),
            const SizedBox(width: 16),
          ],
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formattedTime,
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color:
                      _isSessionActive ? Colors.red : const Color(0xFF1C5A40),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formattedDate,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isOngoing ? _authenticateAndNavigate : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      _isSessionActive ? Colors.red : const Color(0xFF1C5A40),
                  shape: const CircleBorder(),
                  backgroundColor: Colors.grey[200],
                  padding: const EdgeInsets.all(40),
                  side: BorderSide(
                    color:
                        _isSessionActive ? Colors.red : const Color(0xFF1C5A40),
                    width: 8,
                  ),
                ),
                child: Icon(
                  _isSessionActive ? Icons.stop : Icons.fingerprint,
                  size: 64,
                  color:
                      _isSessionActive ? Colors.red : const Color(0xFF1C5A40),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isSessionActive
                    ? 'Tap to End the Session'
                    : 'Tap to Start the Session',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      _isSessionActive ? Colors.red : const Color(0xFF1C5A40),
                ),
              ),
              const SizedBox(height: 8),
              if (!isStudent)
                Text(
                  'Ensure Your Hotspot Name is ${userModel?.userName}_FET',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        _isSessionActive ? Colors.red : const Color(0xFF1C5A40),
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
