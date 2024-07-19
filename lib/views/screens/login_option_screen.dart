import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class LoginOptionScreen extends StatelessWidget {
  const LoginOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 248, 249, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(248, 248, 249, 1),
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
                padding: const EdgeInsets.fromLTRB(10,200,10,0),
                child: Text(
                  'Welcome To The Best Attendance Companion',

                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    textStyle: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 184),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text(
                  "I'm a Student",
                  style: GoogleFonts.spaceGrotesk(
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromRGBO(28, 90, 64, 1), // foreground
                  minimumSize: Size(350, 50), // button size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // reduced border radius
                  ),
                ),
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text(
                  "I'm a Lecturer",
                  style: GoogleFonts.spaceGrotesk(
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Color.fromRGBO(28, 90, 64, 1),
                  minimumSize: Size(350, 50), // button size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // reduced border radius
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
