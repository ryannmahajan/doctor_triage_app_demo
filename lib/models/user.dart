enum UserRole {
  doctor,
  staff,
  securityGuard,
  admin, // Dr. AP Singh
}

class User {
  final String id;
  final String name;
  final UserRole role;
  final String passcode;

  User({
    required this.id,
    required this.name,
    required this.role,
    required this.passcode,
  });

  static List<User> predefinedUsers = [
    User(id: '1', name: 'Dr. Sharan', role: UserRole.doctor, passcode: '1111'),
    User(id: '2', name: 'Dr. AP Singh', role: UserRole.admin, passcode: '2222'),
    User(id: '3', name: 'Person 1', role: UserRole.staff, passcode: '3333'),
    User(id: '4', name: 'Person 2', role: UserRole.staff, passcode: '4444'),
    User(id: '5', name: 'Security Guard', role: UserRole.securityGuard, passcode: '5555'),
  ];

  static User? findUserByPasscode(String passcode) {
    try {
      return predefinedUsers.firstWhere((user) => user.passcode == passcode);
    } catch (e) {
      return null;
    }
  }
}