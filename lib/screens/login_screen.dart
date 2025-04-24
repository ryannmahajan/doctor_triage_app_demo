// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passcodeController = TextEditingController();
  final List<User> _users = User.predefinedUsers;
  User? _selectedUser;
  String? _errorMessage;
  
  @override
  void dispose() {
    _passcodeController.dispose();
    super.dispose();
  }

  void _attemptLogin() {
    final passcode = _passcodeController.text.trim();
    if (passcode.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a passcode';
      });
      return;
    }

    final user = User.findUserByPasscode(passcode);
    if (user == null) {
      setState(() {
        _errorMessage = 'Invalid passcode';
      });
      return;
    }

    // Login successful
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(user: user),
      ),
    );
  }

  

  void _selectUser(User user) {
    setState(() {
      _selectedUser = user;
      _passcodeController.text = '';
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'Doctor Triage App',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              if (_selectedUser == null) ...[
                Text(
                  'Select User',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return _buildUserCard(user);
                    },
                  ),
                ),
              ] else ...[
                Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        _getRoleIcon(_selectedUser!.role),
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _selectedUser!.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _passcodeController,
                      decoration: InputDecoration(
                        labelText: 'Enter Passcode',
                        border: OutlineInputBorder(),
                        errorText: _errorMessage,
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 4,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, letterSpacing: 8),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _attemptLogin,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text('Login'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedUser = null;
                          _errorMessage = null;
                        });
                      },
                      child: Text('Change User'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(User user) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: () => _selectUser(user),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getRoleIcon(user.role),
              size: 32,
              color: Colors.blue,
            ),
            const SizedBox(height: 8),
            Text(
              user.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.doctor:
        return Icons.medical_services;
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.staff:
        return Icons.person;
      case UserRole.securityGuard:
        return Icons.security;
    }
  }
}