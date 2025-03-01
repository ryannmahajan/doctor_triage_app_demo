class Patient {
  final String id;
  final String name;
  final String phoneNumber;
  final bool isUrgent;
  final String complaintDetails;
  final DateTime complaintTime;
  final DateTime? resolutionETA;
  final bool isResolved;
  final String assignedTo;

  Patient({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.isUrgent,
    required this.complaintDetails,
    required this.complaintTime,
    this.resolutionETA,
    this.isResolved = false,
    required this.assignedTo,
  });

  // Convert to/from JSON methods for Firebase
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phoneNumber': phoneNumber,
    'isUrgent': isUrgent,
    'complaintDetails': complaintDetails,
    'complaintTime': complaintTime.toIso8601String(),
    'resolutionETA': resolutionETA?.toIso8601String(),
    'isResolved': isResolved,
    'assignedTo': assignedTo,
  };

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
    id: json['id'],
    name: json['name'],
    phoneNumber: json['phoneNumber'],
    isUrgent: json['isUrgent'],
    complaintDetails: json['complaintDetails'],
    complaintTime: DateTime.parse(json['complaintTime']),
    resolutionETA: json['resolutionETA'] != null 
        ? DateTime.parse(json['resolutionETA']) 
        : null,
    isResolved: json['isResolved'] ?? false,
    assignedTo: json['assignedTo'],
  );
}