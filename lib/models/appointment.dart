class Appointment {
  final String id;
  final String patientName;
  final int? age;
  final String gender;
  final String phoneNumber;
  final bool isAmbulatory;
  final bool needsWheelchair;
  final bool needsStretcher;
  final DateTime? appointmentDateTime;

  const Appointment({
    this.id = "",
    this.patientName = "",
    this.age,
    this.gender = "",
    this.phoneNumber = "",
    this.isAmbulatory = false,
    this.needsWheelchair = false,
    this.needsStretcher = false,
    this.appointmentDateTime,
  });

  // Convert to/from JSON methods for Firebase
  Map<String, dynamic> toJson() => {
    'id': id,
    'patientName': patientName,
    'age': age,
    'gender': gender,
    'phoneNumber': phoneNumber,
    'isAmbulatory': isAmbulatory,
    'needsWheelchair': needsWheelchair,
    'needsStretcher': needsStretcher,
    'appointmentDateTime': appointmentDateTime!.toIso8601String(),
  };

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    id: json['id'],
    patientName: json['patientName'],
    age: json['age'],
    gender: json['gender'],
    phoneNumber: json['phoneNumber'],
    isAmbulatory: json['isAmbulatory'],
    needsWheelchair: json['needsWheelchair'],
    needsStretcher: json['needsStretcher'],
    appointmentDateTime: DateTime.parse(json['appointmentDateTime']),
  );
}
