import 'package:flutter/material.dart';
import 'base_screen.dart';
import 'home_screen.dart';
import 'package:bioattend_app/global.dart';

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
    String imageUrl = 'https://biometric-attendance-application.onrender.com${userModel?.image ?? ''}';
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: BaseScreen(
        currentIndex: 3,
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F8F9),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF1C5A40),
            elevation: 0,
            flexibleSpace: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl),
                    radius: 50,
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildSectionTitle('General'),
                  const SizedBox(height: 10),
                  _buildInfoCard('Full Names', userModel?.userName ?? ''),
                  _buildInfoCard('Email', userModel?.email ?? ''),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Academic'),
                  const SizedBox(height: 10),
                  _buildInfoCard('Matricule', studentModel?.matricule ?? ''),
                  _buildInfoCard('Department', studentModel?.department ?? ''),
                  _buildInfoCard('Level', studentModel?.level ?? ''),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Change Password'),
                  const SizedBox(height: 10),
                  _buildPasswordField('Current Password'),
                  _buildPasswordField('New Password'),
                  _buildPasswordField('Confirm Password'),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        backgroundColor: const Color(0xFF1C5A40),
                      ),
                      child: const Text('Change Password'),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
