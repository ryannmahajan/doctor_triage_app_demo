import 'package:doctor_triage_app/models/appointment.dart';
import 'package:doctor_triage_app/screens/appointment_detail_screen.dart';
import 'package:doctor_triage_app/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  _AppointmentListScreenState createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  DateTime _selectedDate = DateTime.now();
  List<Appointment> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  // Mock data loading function - replace with Firebase later
  Future<void> _loadAppointments() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));
    
    setState(() {
      _appointments = [
        Appointment(
          id: '1',
          patientName: 'John Doe',
          age: 45,
          gender: 'Male',
          phoneNumber: '+1 (555) 123-4567',
          isAmbulatory: true,
          needsWheelchair: false,
          needsStretcher: false,
          appointmentDateTime: DateTime.now().add(Duration(days: 2, hours: 3)),
        ),
        Appointment(
          id: '2',
          patientName: 'Jane Smith',
          age: 45,
          gender: 'Female',
          phoneNumber: '+1 (555) 123-4567',
          isAmbulatory: true,
          needsWheelchair: false,
          needsStretcher: false,
          appointmentDateTime: DateTime.now().add(Duration(days: 2, hours: 3)),
        ),
        Appointment(
          id: '3',
          patientName: 'John Smith',
          age: 39,
          gender: 'Male',
          phoneNumber: '+1 (555) 123-4567',
          isAmbulatory: true,
          needsWheelchair: false,
          needsStretcher: false,
          appointmentDateTime: DateTime.now().add(Duration(days: 2, hours: 3)),
        ),
      ];
      _isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _isLoading = true;
      });
      _loadAppointments(); // Reload appointments for the new date
    }
  }

  void _navigateToAddTriage() {
    // Navigate to add triage screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Add new triage - To be implemented')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: Column(
        children: [
          _buildDateFilter(),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _appointments.isEmpty
                    ? Center(child: Text('No appointments for this date'))
                    : ListView.builder(
                        itemCount: _appointments.length,
                        itemBuilder: (context, index) {
                          return _buildAppointmentCard(_appointments[index]);
                        },
                      ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _navigateToAddTriage,
      //   tooltip: 'Add New Triage',
      //   child: Icon(Icons.add),
      // ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(Icons.medical_services),
            icon: Icon(Icons.medical_services_outlined),
            label: 'Concerns',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_today),
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Appointments',
          ),
        ],
        onDestinationSelected: (index) {
          if (index == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Appointments - To be implemented')),
            );
          }
        },
      ),
    );
  }

  Widget _buildDateFilter() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat.yMMMd().format(_selectedDate),
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.calendar_today, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentDetailScreen(appointment: appointment),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [

              SizedBox(width: 16),
              // Patient info
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        appointment.patientName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        FormatUtils.formatTime(appointment.appointmentDateTime),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}