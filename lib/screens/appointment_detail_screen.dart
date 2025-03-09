import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../utils/format_utils.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailScreen({super.key, this.appointment = const Appointment()});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientInfoCard(),
            const SizedBox(height: 20),
            _buildMobilityCard(),
            const SizedBox(height: 20),
            _buildAppointmentTimeCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.person,
              label: 'Name',
              value: appointment.patientName,
            ),
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: 'Age',
              value: appointment.age != null? '${appointment.age} years': '',
            ),
            _buildInfoRow(
              icon: Icons.wc,
              label: 'Gender',
              value: appointment.gender,
            ),
            _buildInfoRow(
              icon: Icons.phone,
              label: 'Phone',
              value: appointment.phoneNumber,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobilityCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mobility Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildMobilityIndicator(
              icon: Icons.directions_walk,
              label: 'Ambulatory',
              isActive: appointment.isAmbulatory,
            ),
            _buildMobilityIndicator(
              icon: Icons.accessible,
              label: 'Needs Wheelchair',
              isActive: appointment.needsWheelchair,
            ),
            _buildMobilityIndicator(
              icon: Icons.hotel,
              label: 'Needs Stretcher',
              isActive: appointment.needsStretcher,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentTimeCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointment Time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.event, color: Colors.blue),
                const SizedBox(width: 12),
                Text(
                  appointment.appointmentDateTime == null ? '' : FormatUtils.formatDate(appointment.appointmentDateTime!),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.blue),
                const SizedBox(width: 12),
                Text(
                  appointment.appointmentDateTime == null ? '' : FormatUtils.formatTime(appointment.appointmentDateTime!),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobilityIndicator({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isActive ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isActive ? Colors.black : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const Spacer(),
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            size: 20,
            color: isActive ? Colors.green : Colors.red[300],
          ),
        ],
      ),
    );
  }
}