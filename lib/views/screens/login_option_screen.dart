import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'package:bioattend_app/global.dart'; // Import global variables

class LoginOptionScreen extends StatelessWidget {
  const LoginOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 248, 249, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(248, 248, 249, 1),
        elevation: 0,
        toolbarHeight: 0, // Removes the app bar
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 200, 10, 0),
                child: Text(
                  'Welcome To The Best Attendance Companion',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    textStyle: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 184),
              ElevatedButton(
                onPressed: () {
                  isStudent = true; // Set global isStudent variable
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen(isStudentLogin: true)),
                  );
                },
                child: Text(
                  "I'm a Student",
                  style: GoogleFonts.spaceGrotesk(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromRGBO(28, 90, 64, 1), // foreground
                  minimumSize: const Size(350, 50), // button size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // reduced border radius
                  ),
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  isStudent = false; // Set global isStudent variable
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen(isStudentLogin: false)),
                  );
                },
                child: Text(
                  "I'm a Lecturer",
                  style: GoogleFonts.spaceGrotesk(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color.fromRGBO(28, 90, 64, 1),
                  minimumSize: const Size(350, 50), // button size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // reduced border radius
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
