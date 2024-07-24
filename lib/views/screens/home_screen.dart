import 'package:flutter/material.dart';
import 'package:bioattend_app/global.dart';
import '../../controllers/home_controller.dart';
import '../widgets/home_card.dart';
import '../widgets/class_card.dart';
import 'base_screen.dart';
import 'profile_screen.dart';
import 'attendance_history_screen.dart';
import 'view_courses_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final HomeController _homeController;
  List<Map<String, dynamic>> timetable = [];

  @override
  void initState() {
    super.initState();
    print('user model: ${userModel?.toJson()}');
    _homeController = HomeController(
      profileImageController: AnimationController(
        duration: const Duration(milliseconds: 100),
        vsync: this,
      ),
    );

    _fetchTimetable();
  }

  Future<void> _fetchTimetable() async {
    Map<int, dynamic> days = {
      1: "monday",
      2: "tuesday",
      3: "wednesday",
      4: "thursday",
      5: "friday",
      6: "saturday",
      7: "sunday"
    };

    try {
      final result = await _homeController.getCardDetails(
          isStudent ? studentModel!.id : lecturerModel!.lecturerID, days[DateTime.now().weekday]);
      setState(() {
        timetable = result;
      });
    } catch (e) {
      print('Error fetching timetable: $e');
    }
  }

  @override
  void dispose() {
    _homeController.profileImageController.dispose();
    super.dispose();
  }

  void _handleProfileTap() {
    _homeController.animateProfileImage().then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    });
  }

  Future<bool> _onWillPop() async {
    return true; // Return true to allow back button to close the app
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BaseScreen(
        currentIndex: 0,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color.fromRGBO(248, 248, 249, 1),
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
                            'Hey ${userModel?.userName ?? "User"}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
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
                          backgroundImage: (userModel != null && userModel!.image != null && userModel!.image!.isNotEmpty)
                              ? NetworkImage('https://biometric-attendance-application.onrender.com${userModel?.image ?? ''}')
                              : const AssetImage('assets/images/profile.jpg') as ImageProvider,
                          radius: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: HomePage(timetable: timetable),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>> timetable;

  const HomePage({super.key, required this.timetable});

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AttendanceHistoryScreen()),
                  );
                },
              ),
              HomeButton(
                icon: Icons.book,
                label: 'View Courses',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ViewCoursesScreen()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Today\'s Classes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Material(
                color: const Color.fromRGBO(28, 90, 64, 1),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: const Text('All'),
                              onTap: () {
                                _filterClasses('All');
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Finished'),
                              onTap: () {
                                _filterClasses('Finished');
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Ongoing'),
                              onTap: () {
                                _filterClasses('Ongoing');
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Coming'),
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
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.filter_list, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: widget.timetable.length,
              itemBuilder: (context, index) {
                final item = widget.timetable[index];
                return ClassCard(
                  index: index + 1,
                  code: item['courseCode'],
                  title: item['courseName'],
                  time: '${item['startTime']} | ${item['endTime']}',
                  courseID: item['courseID'],
                  courseName: item['courseName'],
                  courseCode: item['courseCode'],
                  startTime: item['startTime'],
                  endTime: item['endTime'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
