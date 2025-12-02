import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'user_type_screen.dart';// Make sure to import your login screen

class StudentSignUpScreen extends StatelessWidget {
  const StudentSignUpScreen({Key? key}) : super(key: key);

  BoxDecoration _backgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF2D2D50), Color(0xFF1E1E2F)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D50), // same as top gradient color
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserTypeScreen()),
            );// Go back to previous screen
          },
        ),
      ),
      body: Container(
        decoration: _backgroundDecoration(),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.school, size: 60, color: Colors.blue),
                const SizedBox(height: 16),
                const TextField(decoration: InputDecoration(labelText: 'Student Name')),
                const SizedBox(height: 12),
                const TextField(decoration: InputDecoration(labelText: 'Email Address')),
                const SizedBox(height: 12),
                const TextField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                const TextField(decoration: InputDecoration(labelText: 'Roll Number')),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
