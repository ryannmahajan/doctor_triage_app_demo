import 'package:doctor_triage_app/models/appointment.dart';
import 'package:doctor_triage_app/services/repositories/appointment_repository_interface.dart';

class RemoteAppointmentRepository implements IAppointmentRepository {
  @override
  Future<Appointment> createAppointment(Appointment appointment) {
    // TODO: implement createAppointment
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAppointment(int id) {
    // TODO: implement deleteAppointment
    throw UnimplementedError();
  }

  @override
  Future<Appointment> getAppointment(int id) {
    // TODO: implement getAppointment
    throw UnimplementedError();
  }

  @override
  Future<List<Appointment>> getAppointments() {
    // TODO: implement getAppointments
    throw UnimplementedError();
  }

  @override
  Future<List<Appointment>> getAppointmentsForDate(DateTime date) async {
    await Future.delayed(Duration(seconds: 1));
    return [
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
  }

  @override
  Future<Appointment> updateAppointment(Appointment appointment) {
    // TODO: implement updateAppointment
    throw UnimplementedError();
  }

}