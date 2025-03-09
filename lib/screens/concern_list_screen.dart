// lib/screens/triage_list_screen.dart
import 'package:doctor_triage_app/screens/list_screens.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/concern.dart';
import 'concern_detail_screen.dart';

class ConcernListScreen extends ListScreenBase {
  const ConcernListScreen({super.key});

  @override
  _ConcernListScreenState createState() => _ConcernListScreenState();

  @override
  FloatingActionButton? floatingActionButton(BuildContext context) => 
    FloatingActionButton(
          onPressed:() => _navigateToAddTriage(context),
          tooltip: 'Add New Concern',
          child: Icon(Icons.add),
    );
  
  @override
  String get title => "Concerns";

  void _navigateToAddTriage(BuildContext c) {
    Navigator.push(
      c,
      MaterialPageRoute(builder: (context) => ConcernDetailScreen()),
    );
  }
}

class _ConcernListScreenState extends State<ConcernListScreen> {
  DateTime _selectedDate = DateTime.now();
  List<Concern> _patients = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  // Mock data loading function - replace with Firebase later
  Future<void> _loadPatients() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));
    
    setState(() {
      _patients = [
        Concern(
          id: '1',
          name: 'John Doe',
          phoneNumber: '+1 (555) 123-4567',
          isUrgent: true,
          complaintDetails: 'Severe chest pain and shortness of breath',
          complaintTime: DateTime.now().subtract(Duration(hours: 2)),
          resolutionETA: DateTime.now().add(Duration(minutes: 30)),
          assignedTo: 'Dr. Smith',
        ),
        Concern(
          id: '2',
          name: 'Jane Smith',
          phoneNumber: '+1 (555) 987-6543',
          isUrgent: false,
          complaintDetails: 'Mild fever and sore throat',
          complaintTime: DateTime.now().subtract(Duration(hours: 4)),
          resolutionETA: DateTime.now().add(Duration(hours: 2)),
          assignedTo: 'Dr. Johnson',
        ),
        Concern(
          id: '3',
          name: 'Robert Brown',
          phoneNumber: '+1 (555) 555-5555',
          isUrgent: true,
          complaintDetails: 'High blood pressure and dizziness',
          complaintTime: DateTime.now().subtract(Duration(hours: 1)),
          resolutionETA: DateTime.now().add(Duration(minutes: 45)),
          assignedTo: 'Dr. Williams',
          isResolved: true,
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
      _loadPatients(); // Reload patients for the new date
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter Triage Cases'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: Text('Urgent Cases Only'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: Text('Resolved Cases'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: Text('Unresolved Cases'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('APPLY'),
          ),
        ],
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sort Triage Cases'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: Text('Urgency (High to Low)'),
              value: 'urgency',
              groupValue: 'urgency',
              onChanged: (value) {},
            ),
            RadioListTile(
              title: Text('Time (Newest First)'),
              value: 'newest',
              groupValue: 'urgency',
              onChanged: (value) {},
            ),
            RadioListTile(
              title: Text('Time (Oldest First)'),
              value: 'oldest',
              groupValue: 'urgency',
              onChanged: (value) {},
            ),
            RadioListTile(
              title: Text('Nearest ETA'),
              value: 'eta',
              groupValue: 'urgency',
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('APPLY'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          _buildDateFilter(),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _patients.isEmpty
                    ? Center(child: Text('No triage cases for this date'))
                    : ListView.builder(
                        itemCount: _patients.length,
                        itemBuilder: (context, index) {
                          return _buildTriageCard(_patients[index]);
                        },
                      ),
          ),
        ],
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
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: _showSortDialog,
            tooltip: 'Sort',
          ),
        ],
      ),
    );
  }

  Widget _buildTriageCard(Concern patient) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConcernDetailScreen(concern: patient),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Urgency indicator
              Container(
                width: 4,
                height: 70,
                color: patient.isUrgent ? Colors.red : Colors.green,
              ),
              SizedBox(width: 16),
              // Patient info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            patient.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (patient.isResolved)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Resolved',
                              style: TextStyle(
                                color: Colors.green[800],
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      patient.complaintDetails,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                        SizedBox(width: 4),
                        Text(
                          patient.resolutionETA != null 
                              ? 'ETA: ${DateFormat.jm().format(patient.resolutionETA!)}'
                              : 'No ETA',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Urgency tag
              if (patient.isUrgent && !patient.isResolved)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'URGENT',
                    style: TextStyle(
                      color: Colors.red[800],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}