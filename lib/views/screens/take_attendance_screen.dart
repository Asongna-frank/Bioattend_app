import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'home_screen.dart'; // Import the HomeScreen
import 'wifi_selection_screen.dart';

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

  @override
  void initState() {
    super.initState();
    print('from take attendance screen: ${widget.courseID}, ${widget.courseName}, ${widget.courseCode}');
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
    bool authenticated = false;
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
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

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const WiFiSelectionScreen()),
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
    return false;
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
          actions: const [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
            SizedBox(width: 16),
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
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C5A40),
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
                onPressed: _authenticateAndNavigate,
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF1C5A40),
                  shape: const CircleBorder(),
                  backgroundColor: Colors.grey[200],
                  padding: const EdgeInsets.all(40),
                  side: const BorderSide(
                    color: Color(0xFF1C5A40),
                    width: 8,
                  ),
                ),
                child: const Icon(
                  Icons.fingerprint,
                  size: 64,
                  color: Color(0xFF1C5A40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
