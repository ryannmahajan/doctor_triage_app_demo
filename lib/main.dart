import 'package:doctor_triage_app/screens/home_page.dart';
import 'package:doctor_triage_app/screens/list_screens.dart';
import 'package:doctor_triage_app/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Triage App',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light
      ),
      home: LoginScreen(),
      // For testing, you can switch between these screens:
      // home: AppointmentDetailScreen(
      //   appointment: Appointment(
      //     id: '1',
      //     patientName: 'John Doe',
      //     age: 45,
      //     gender: 'Male',
      //     phoneNumber: '+1 (555) 123-4567',
      //     isAmbulatory: true,
      //     needsWheelchair: false,
      //     needsStretcher: false,
      //     appointmentDateTime: DateTime.now().add(Duration(days: 2, hours: 3)),
      //   ),
      // ),
      // home: TriageDetailScreen(
      //   patient: Patient(
      //     id: '1',
      //     name: 'John Doe',
      //     phoneNumber: '+1 (555) 123-4567',
      //     isUrgent: true,
      //     complaintDetails: 'Patient is experiencing severe chest pain and shortness of breath for the past 2 hours.',
      //     complaintTime: DateTime.now().subtract(Duration(hours: 2)),
      //     resolutionETA: DateTime.now().add(Duration(minutes: 30)),
      //     assignedTo: 'Dr. Smith',
      //   ),
      // ),
    );
  }
}