import 'dart:async';
import 'package:bioattend_app/global.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home_screen.dart';
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
  bool _isSessionActive = false;

  @override
  void initState() {
    super.initState();
    print('from take attendance screen: ${widget.courseID}, ${widget.courseName}, ${widget.courseCode}');
    _formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    _formattedDate = DateFormat('MMM dd, yyyy - EEEE').format(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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

  Future<void> _startSession() async {
    final status = await [
      Permission.location,
      Permission.locationWhenInUse,
      Permission.locationAlways,
      Permission.nearbyWifiDevices,
    ].request();

    if (status[Permission.location] != PermissionStatus.granted ||
        status[Permission.locationWhenInUse] != PermissionStatus.granted ||
        status[Permission.locationAlways] != PermissionStatus.granted ||
        status[Permission.nearbyWifiDevices] != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissions not granted.')),
      );
      return;
    }

    bool hotspotOn = await WiFiForIoTPlugin.isWiFiAPEnabled();

    if (!hotspotOn) {
      bool hotspotStarted = await WiFiForIoTPlugin.setWiFiAPEnabled(true);
      if (!hotspotStarted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to start hotspot.')),
        );
        return;
      }
    }

    // Check if the API level supports setting the SSID
    if (androidInfo.version.sdkInt < 26) {
      await WiFiForIoTPlugin.setWiFiAPSSID('${userModel!.userName}_FET');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Setting SSID is not supported on API level >= 26.')),
      );
    }

    setState(() {
      _isSessionActive = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session started, hotspot is now active.')),
    );
  }

  Future<void> _endSession() async {
    await WiFiForIoTPlugin.setWiFiAPEnabled(false);
    setState(() {
      _isSessionActive = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session ended, hotspot is now off.')),
    );
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
    final startTime = TimeOfDay.fromDateTime(DateFormat('HH:mm:ss').parse(widget.startTime));
    final endTime = TimeOfDay.fromDateTime(DateFormat('HH:mm:ss').parse(widget.endTime));
    final now = TimeOfDay.now();
    final isOngoing = now.hour > startTime.hour ||
        (now.hour == startTime.hour && now.minute >= startTime.minute) &&
        now.hour < endTime.hour ||
        (now.hour == endTime.hour && now.minute <= endTime.minute);

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
            'Start Session',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            CircleAvatar(
              backgroundImage: (userModel != null && userModel!.image != null && userModel!.image!.isNotEmpty)
                  ? NetworkImage('https://biometric-attendance-application.onrender.com${userModel!.image!}')
                  : const AssetImage('assets/images/profile.jpg') as ImageProvider,
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
                  color: _isSessionActive ? Colors.red : Color(0xFF1C5A40),
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
                onPressed: isOngoing
                    ? () {
                        if (_isSessionActive) {
                          _endSession();
                        } else {
                          _startSession();
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: _isSessionActive ? Colors.red : Color(0xFF1C5A40),
                  shape: const CircleBorder(),
                  backgroundColor: Colors.grey[200],
                  padding: const EdgeInsets.all(40),
                  side: BorderSide(
                    color: _isSessionActive ? Colors.red : Color(0xFF1C5A40),
                    width: 8,
                  ),
                ),
                child: Icon(
                  Icons.wifi,
                  size: 64,
                  color: _isSessionActive ? Colors.red : Color(0xFF1C5A40),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _isSessionActive ? 'Tap to End the Session' : 'Tap to Start the Session',
                style: TextStyle(
                  fontSize: 16,
                  color: _isSessionActive ? Colors.red : Color(0xFF1C5A40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
