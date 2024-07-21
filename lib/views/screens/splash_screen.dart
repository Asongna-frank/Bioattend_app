import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart'; // Add alias for HTTP package

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void getData() async {
    Response response = await get(Uri.parse('https://biometric-attendance-application.onrender.com/api/users/'));
    print(response.body);
  }

  @override
  void initState() {
    super.initState();
    _navigateToHome();
    getData();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 5), () {});
    Navigator.pushReplacementNamed(context, '/loginOptionScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(28, 90, 64, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Logo
            const Icon(
              Icons.check_circle_outline,
              size: 128,
              color: Colors.white,
            ),
            const SizedBox(height: 26),
            // App Name
            Text(
              'BioAttend',
              style: GoogleFonts.dmSans(
                textStyle: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 1),
            // Tagline
            Text(
              'Reliable Attendance Tracking',
              style: GoogleFonts.spaceGrotesk(
                textStyle: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.normal
                ),
              ),
            ),
            const SizedBox(height: 26),
            // Loading Animation
            const CircularProgressIndicator(
              strokeWidth: 8.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
