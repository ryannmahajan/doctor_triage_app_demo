import 'package:doctor_triage_app/models/Concern.dart';
import 'package:doctor_triage_app/screens/list_screens.dart';
import 'package:doctor_triage_app/services/repositories/concern_repository_interface.dart';
import 'package:doctor_triage_app/services/repositories/remote_concern_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'concern_detail_screen.dart';

class ConcernListScreen extends ListScreenBase {
  final IConcernRepository concernRepository;
  ConcernListScreen({super.key, IConcernRepository? concernRepository}):concernRepository = concernRepository ?? RemoteConcernRepository();

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
  List<Concern> _concerns = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConcerns();
  }

  Future<void> _loadConcerns() async {
    final temp = await widget.concernRepository.getConcernsForDate(_selectedDate);
    setState(() {
      _concerns = temp;
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
      _loadConcerns(); // Reload concerns for the new date
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
                : _concerns.isEmpty
                    ? Center(child: Text('No triage cases for this date'))
                    : ListView.builder(
                        itemCount: _concerns.length,
                        itemBuilder: (context, index) {
                          return _buildTriageCard(_concerns[index]);
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

  Widget _buildTriageCard(Concern concern) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConcernDetailScreen(concern: concern),
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
                color: concern.isUrgent ? Colors.red : Colors.green,
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
                            concern.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (concern.isResolved)
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
                      concern.complaintDetails,
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
                          concern.resolutionETA != null 
                              ? 'ETA: ${DateFormat.jm().format(concern.resolutionETA!)}'
                              : 'No ETA',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Urgency tag
              if (concern.isUrgent && !concern.isResolved)
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