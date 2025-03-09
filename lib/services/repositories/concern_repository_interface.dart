import 'package:doctor_triage_app/models/Concern.dart';

abstract interface class IConcernRepository {
  Future<List<Concern>> getConcerns();
  Future<List<Concern>> getConcernsForDate(DateTime date);
  Future<Concern> getConcern(int id);
  Future<Concern> createConcern(Concern concern);
  Future<Concern> updateConcern(Concern concern);
  Future<void> deleteConcern(int id);

}