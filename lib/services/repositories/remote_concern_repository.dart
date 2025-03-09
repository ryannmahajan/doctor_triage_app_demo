import 'package:doctor_triage_app/models/Concern.dart';
import 'package:doctor_triage_app/services/repositories/concern_repository_interface.dart';

class RemoteConcernRepository implements IConcernRepository {
  @override
  Future<Concern> createConcern(Concern concern) {
    // TODO: implement createConcern
    throw UnimplementedError();
  }

  @override
  Future<void> deleteConcern(int id) {
    // TODO: implement deleteConcern
    throw UnimplementedError();
  }

  @override
  Future<Concern> getConcern(int id) {
    // TODO: implement getConcern
    throw UnimplementedError();
  }

  @override
  Future<List<Concern>> getConcerns() {
    // TODO: implement getConcerns
    throw UnimplementedError();
  }

  @override
  Future<Concern> updateConcern(Concern concern) {
    // TODO: implement updateConcern
    throw UnimplementedError();
  }
  
  @override
  Future<List<Concern>> getConcernsForDate(DateTime date) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));
    return [
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
  }

}