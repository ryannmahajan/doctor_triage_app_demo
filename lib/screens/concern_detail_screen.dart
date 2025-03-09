import 'package:flutter/material.dart';
import '../models/concern.dart';
import '../utils/format_utils.dart'; 

class ConcernDetailScreen extends StatefulWidget {
  final Concern concern;

  ConcernDetailScreen({super.key, Concern? concern}) : concern = concern ?? Concern();

  @override
  _ConcernDetailScreenState createState() => _ConcernDetailScreenState();
}

class _ConcernDetailScreenState extends State<ConcernDetailScreen> {
  late Concern concern;
  
  @override
  void initState() {
    super.initState();
    concern = widget.concern;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Concern Details'),
        backgroundColor: concern.isUrgent ? Colors.red : Colors.blue,
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
                    concern.name,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (concern.isUrgent)
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
                  concern.phoneNumber,
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
              concern.complaintDetails,
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
                  'Registered: ${FormatUtils.formatDateTime(concern.complaintTime)}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            if (concern.resolutionETA != null)
              Row(
                children: [
                  Icon(Icons.timer, size: 18, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    'Expected Resolution: ${concern.resolutionETA!=null? FormatUtils.formatDateTime(concern.resolutionETA!): "Not Set"}',
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
          onPressed: concern.isResolved ? null : () {
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
      concern = Concern(
        id: concern.id,
        name: concern.name,
        phoneNumber: concern.phoneNumber,
        isUrgent: concern.isUrgent,
        complaintDetails: concern.complaintDetails,
        complaintTime: concern.complaintTime,
        resolutionETA: concern.resolutionETA,
        isResolved: true,
        assignedTo: concern.assignedTo,
      );
    });
    
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Complaint resolved')),
    );
  }
}