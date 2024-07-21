import 'package:flutter/material.dart';
import 'base_screen.dart';
import 'home_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<bool> _onWillPop(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: BaseScreen(
        currentIndex: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
          ),
          body: const Center(
            child: Text('Profile Screen'),
          ),
        ),
      ),
    );
  }
}
