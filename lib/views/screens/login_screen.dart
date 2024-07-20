import 'package:bioattend_app/global.dart';
import 'package:bioattend_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bioattend_app/controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await _authController.login(email, password);

    setState(() {
      _isLoading = false;
    });

    if (response != null) {
      final accessToken = response['access'];
      final refreshToken = response['refresh'];
      final user = response['user'];

      userModel = UserModel.fromJson(user);

      // Save tokens securely
      await _authController.saveTokens(accessToken, refreshToken);

      // Navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 248, 249, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(248, 248, 249, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'BioAttend',
                          style: GoogleFonts.dmSans(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Welcome back to BioAttend',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Login to manage courses and track attendance seamlessly',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 19,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Image.asset(
                      'assets/images/login_image.png',
                      height: 200,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Email',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: _emailController,
                    style: GoogleFonts.spaceGrotesk(),
                    decoration: InputDecoration(
                      hintText: 'Enter your Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Password',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    style: GoogleFonts.spaceGrotesk(),
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot password? ',
                        style: GoogleFonts.spaceGrotesk(),
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle password reset
                        },
                        child: Text(
                          'Reset it',
                          style: GoogleFonts.spaceGrotesk(
                            color: Color.fromRGBO(28, 90, 64, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _login,
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        textStyle: GoogleFonts.spaceGrotesk(),
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromRGBO(28, 90, 64, 1), // foreground color
                        minimumSize: Size(double.infinity, 50), // button size
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // border radius
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
