import 'package:bioattend_app/global.dart';
import 'package:bioattend_app/models/user_model.dart';
import 'package:flutter/material.dart';
import '../../controllers/home_controller.dart';
import '../widgets/home_card.dart';
import '../widgets/class_card.dart';
import 'base_screen.dart';
import 'profile_screen.dart';
import 'attendance_history_screen.dart';
import 'view_courses_screen.dart';
import 'take_attendance_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final HomeController _homeController;

  @override
  void initState() {
    super.initState();
    print(userModel);
    _homeController = HomeController(profileImageController: AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    ));
  }

  @override
  void dispose() {
    _homeController.profileImageController.dispose();
    super.dispose();
  }

  void _handleProfileTap() {
    _homeController.animateProfileImage().then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 0,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromRGBO(248, 248, 249, 1),
            elevation: 0,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hey Chezem Miguel',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Welcome back to BioAttend',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _handleProfileTap,
                    child: ScaleTransition(
                      scale: _homeController.profileImageAnimation,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage('https://your_image_url'),
                        radius: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String filter = 'All';

  void _filterClasses(String status) {
    setState(() {
      filter = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HomeButton(
                icon: Icons.article,
                label: 'Attendance History',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AttendanceHistoryScreen()),
                  );
                },
              ),
              HomeButton(
                icon: Icons.book,
                label: 'View Courses',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ViewCoursesScreen()),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Classes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Material(
                color: Color.fromRGBO(28, 90, 64, 1),
                shape: CircleBorder(),
                child: InkWell(
                  customBorder: CircleBorder(),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text('All'),
                              onTap: () {
                                _filterClasses('All');
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: Text('Finished'),
                              onTap: () {
                                _filterClasses('Finished');
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: Text('Ongoing'),
                              onTap: () {
                                _filterClasses('Ongoing');
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: Text('Coming'),
                              onTap: () {
                                _filterClasses('Coming');
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.filter_list, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 4, // Update this count based on your data
              itemBuilder: (context, index) {
                return ClassCard(
                  index: index + 1, // Pass the index + 1 to start from 1
                  code: 'CEF 246',
                  title: 'Algebra',
                  time: '09:00 am | 11:00 am',
                  status: 'Finished',
                  statusColor: Color.fromRGBO(28, 90, 64, 1),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
