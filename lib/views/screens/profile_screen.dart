import 'package:bioattend_app/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'base_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 3,
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
          title: const Text('Profile Screen'),
        ),
        body: const Center(
          child: Text('Profile Screen'),
        ),
      ),
    );
  }
}
