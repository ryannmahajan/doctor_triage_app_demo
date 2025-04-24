import 'dart:collection';

import 'package:doctor_triage_app/screens/appointment_list_screen.dart';
import 'package:doctor_triage_app/screens/concern_list_screen.dart';
import 'package:flutter/material.dart';

class MainListScreensWithBottomNavBar extends StatefulWidget {
  const MainListScreensWithBottomNavBar({super.key});

  @override
  MainListScreensWithBottomNavBarState createState()=>MainListScreensWithBottomNavBarState();
}

class MainListScreensWithBottomNavBarState extends State<MainListScreensWithBottomNavBar> {
  var _selectedIndex = 0;
  ListScreenBase get _currentPage => _pages.values.elementAt(_selectedIndex);

  final LinkedHashMap<NavigationDestination, ListScreenBase> _pages = LinkedHashMap.from(
  {
    NavigationDestination(
      selectedIcon: Icon(Icons.medical_services),
      icon: Icon(Icons.medical_services_outlined),
      label: 'Concerns',
    ) : ConcernListScreen(),
    
    NavigationDestination(
      selectedIcon: Icon(Icons.calendar_today),
      icon: Icon(Icons.calendar_today_outlined),
      label: 'Appointments',
    ): AppointmentListScreen()
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentPage.title),
      ),
      floatingActionButton: _currentPage.floatingActionButton(context),
      body: _currentPage,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        destinations: _pages.keys.toList(),
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          }); 
        },
    )
    );
  }
}

class ListScreen extends StatefulWidget {
  int index;

  ListScreen(this.index, {super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  var _selectedIndex;
  ListScreenBase get _currentPage => _pages.values.elementAt(_selectedIndex);

  final LinkedHashMap<NavigationDestination, ListScreenBase> _pages = LinkedHashMap.from(
  {
    NavigationDestination(
      selectedIcon: Icon(Icons.medical_services),
      icon: Icon(Icons.medical_services_outlined),
      label: 'Concerns',
    ) : ConcernListScreen(),
    
    NavigationDestination(
      selectedIcon: Icon(Icons.calendar_today),
      icon: Icon(Icons.calendar_today_outlined),
      label: 'Appointments',
    ): AppointmentListScreen()
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentPage.title),
      ),
      floatingActionButton: _currentPage.floatingActionButton(context),
      body: _currentPage,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        destinations: _pages.keys.toList(),
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          }); 
        },
    )
    );
  }
}

abstract class ListScreenBase extends StatefulWidget {
  const ListScreenBase({super.key});

  String get title;
  FloatingActionButton? floatingActionButton(BuildContext context);
}