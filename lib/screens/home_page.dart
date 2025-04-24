// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'concern_list_screen.dart';
import 'appointment_list_screen.dart'; // We'll create this
// import 'security_followup_screen.dart'; // We'll create this
import 'stats_screen.dart'; // We'll create this
// import 'edit_concern_screen.dart'; // We'll create this
// import 'edit_appointment_screen.dart'; // We'll create this

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Different screens based on user role
    if (widget.user.role == UserRole.securityGuard) {
      // return SecurityFollowupScreen();
      return _buildStandardView();
    } else if (widget.user.role == UserRole.admin) {
      // Dr. AP Singh gets the admin view with stats
      return _buildAdminView();
    } else {
      // Regular doctors and staff get normal concerns and appointments
      return _buildStandardView();
    }
  }

  Widget _buildAdminView() {
    final List<Widget> _screens = [
      ConcernListScreen(),
      AppointmentListScreen(),
      StatsScreen(), // Additional stats screen for admin
    ];

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Concerns',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
        ],
      ),
    );
  }

  Widget _buildStandardView() {
    final List<Widget> _screens = [
      ConcernListScreen(),
      AppointmentListScreen(),
    ];

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Concerns',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
        ],
      ),
    );
  }
}