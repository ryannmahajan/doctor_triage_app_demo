import 'package:flutter/material.dart';
import 'models/patient.dart';
import 'screens/triage_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Triage App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TriageDetailScreen(
        patient: Patient(
          id: '1',
          name: 'John Doe',
          phoneNumber: '+1 (555) 123-4567',
          isUrgent: true,
          complaintDetails: 'Patient is experiencing severe chest pain and shortness of breath for the past 2 hours.',
          complaintTime: DateTime.now().subtract(Duration(hours: 2)),
          resolutionETA: DateTime.now().add(Duration(minutes: 30)),
          assignedTo: 'Dr. Smith',
        ),
      ),
    );
  }
}