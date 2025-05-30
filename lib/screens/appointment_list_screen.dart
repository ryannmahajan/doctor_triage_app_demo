import 'package:doctor_triage_app/models/appointment.dart';
import 'package:doctor_triage_app/screens/appointment_detail_screen.dart';
import 'package:doctor_triage_app/screens/list_screens.dart';
import 'package:doctor_triage_app/services/repositories/appointment_repository_interface.dart';
import 'package:doctor_triage_app/services/repositories/remote_appointment_repository.dart';
import 'package:doctor_triage_app/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentListScreen extends ListScreenBase {
  final IAppointmentRepository appointmentRepository;
  AppointmentListScreen({super.key, IAppointmentRepository? appointmentRepository}):appointmentRepository = appointmentRepository ?? RemoteAppointmentRepository();

  @override
  _AppointmentListScreenState createState() => _AppointmentListScreenState();
  
  @override
  FloatingActionButton? floatingActionButton(BuildContext context) => 
    FloatingActionButton(
          onPressed:() => _navigateToAddAppointment(context),
          tooltip: 'Add New Appointment',
          child: Icon(Icons.add),
    );
  
  @override
  String get title => "Appointments";

  void _navigateToAddAppointment(BuildContext c) {
    Navigator.push(
      c,
      MaterialPageRoute(builder: (context) => AppointmentDetailScreen()),
    );
  }
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

  Future<void> _loadAppointments() async {
    final temp = await widget.appointmentRepository.getAppointmentsForDate(_selectedDate);
    setState(() {
      _appointments = temp;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: widget.floatingActionButton(context),
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
                        FormatUtils.formatTime(appointment.appointmentDateTime!),
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