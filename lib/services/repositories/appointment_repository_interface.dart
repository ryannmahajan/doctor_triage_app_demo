import 'package:doctor_triage_app/models/appointment.dart';

abstract interface class IAppointmentRepository {
  Future<List<Appointment>> getAppointments();
  Future<List<Appointment>> getAppointmentsForDate(DateTime date);
  Future<Appointment> getAppointment(int id);
  Future<Appointment> createAppointment(Appointment appointment);
  Future<Appointment> updateAppointment(Appointment appointment);
  Future<void> deleteAppointment(int id);

}