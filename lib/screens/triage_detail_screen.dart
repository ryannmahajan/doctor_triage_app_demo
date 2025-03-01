import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../utils/format_utils.dart'; // We'll create this later

class TriageDetailScreen extends StatefulWidget {
  final Patient patient;

  const TriageDetailScreen({super.key, required this.patient});

  @override
  _TriageDetailScreenState createState() => _TriageDetailScreenState();
}

class _TriageDetailScreenState extends State<TriageDetailScreen> {
  late Patient patient;
  
  @override
  void initState() {
    super.initState();
    patient = widget.patient;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Triage Details'),
        backgroundColor: patient.isUrgent ? Colors.red : Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientInfoSection(),
            SizedBox(height: 24),
            _buildComplaintSection(),
            SizedBox(height: 24),
            _buildTimingSection(),
            SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfoSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    patient.name,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (patient.isUrgent)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'URGENT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, size: 18, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(
                  patient.phoneNumber,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complaint Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              patient.complaintDetails,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimingSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Timing Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(
                  'Registered: ${FormatUtils.formatDateTime(patient.complaintTime)}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            if (patient.resolutionETA != null)
              Row(
                children: [
                  Icon(Icons.timer, size: 18, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    'Expected Resolution: ${FormatUtils.formatDateTime(patient.resolutionETA!)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.transfer_within_a_station),
          label: Text('Reroute to Another Staff'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50), backgroundColor: Colors.orange,
          ),
          onPressed: () {
            // Show staff selection dialog
            _showRerouteDialog();
          },
        ),
        SizedBox(height: 16),
        ElevatedButton.icon(
          icon: Icon(Icons.check_circle),
          label: Text('Resolve Concern'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50), backgroundColor: Colors.green,
          ),
          onPressed: patient.isResolved ? null : () {
            // Handle resolution logic
            _resolveComplaint();
          },
        ),
      ],
    );
  }

  void _showRerouteDialog() {
    // This would show a dialog with staff members to select
    // For now, we'll just show a placeholder dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Staff Member'),
        content: Text('Staff selection will be implemented here'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Here you would update the patient's assignedTo field
              // and sync with Firebase
            },
            child: Text('CONFIRM'),
          ),
        ],
      ),
    );
  }

  void _resolveComplaint() {
    // This would update the patient's isResolved status
    // and sync with Firebase
    setState(() {
      patient = Patient(
        id: patient.id,
        name: patient.name,
        phoneNumber: patient.phoneNumber,
        isUrgent: patient.isUrgent,
        complaintDetails: patient.complaintDetails,
        complaintTime: patient.complaintTime,
        resolutionETA: patient.resolutionETA,
        isResolved: true,
        assignedTo: patient.assignedTo,
      );
    });
    
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Complaint resolved')),
    );
  }
}