import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'wifi_selection_screen.dart';

class AttendanceScreen extends StatefulWidget {
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
    _formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    _formattedDate = DateFormat('MMM dd, yyyy - EEEE').format(DateTime.now());
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _formattedTime = DateFormat('hh:mm a').format(DateTime.now());
        _formattedDate = DateFormat('MMM dd, yyyy - EEEE').format(DateTime.now());
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
        SnackBar(content: Text('Authentication failed or not set up.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Authentication successful!')),
    );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => WiFiSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Take Attendance',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
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
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C5A40),
              ),
            ),
            SizedBox(height: 8),
            Text(
              _formattedDate,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _authenticateAndNavigate,
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFF1C5A40),
                shape: CircleBorder(),
                backgroundColor: Colors.grey[200],
                padding: EdgeInsets.all(40),
                side: BorderSide(
                  color: Color(0xFF1C5A40),
                  width: 8,
                ),
              ),
              child: Icon(
                Icons.fingerprint,
                size: 64,
                color: Color(0xFF1C5A40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
