import 'package:flutter/material.dart';
import 'base_screen.dart';
import 'home_screen.dart';
import 'package:bioattend_app/global.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showPasswordFields = false;

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
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 100.0),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1C5A40),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
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
                              padding: const EdgeInsets.all(12.0),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(imageUrl),
                        radius: 75, // Increased size by a factor of 3 (original was 50)
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildSectionTitle('General'),
                      const SizedBox(height: 10),
                      _buildInfoSection(
                        context,
                        [
                          _buildInfoItem('Full Names', userModel?.userName ?? ''),
                          _buildInfoItem('Email', userModel?.email ?? ''),
                          _buildInfoItem('Number', userModel?.number ?? ''),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Academic'),
                      const SizedBox(height: 10),
                      _buildInfoSection(
                        context,
                        [
                          _buildInfoItem('Matricule', studentModel?.matricule ?? ''),
                          _buildInfoItem('Department', studentModel?.department ?? ''),
                          _buildInfoItem('Level', studentModel?.level ?? ''),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildPasswordSection(),
                      if (_showPasswordFields) ...[
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
                    ],
                  ),
                ),
              ],
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

  Widget _buildInfoSection(BuildContext context, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
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
    );
  }

  Widget _buildPasswordSection() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showPasswordFields = !_showPasswordFields;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                _showPasswordFields ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Colors.grey,
              ),
            ],
          ),
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
