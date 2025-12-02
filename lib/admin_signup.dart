import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'user_type_screen.dart';

class AdminSignUpScreen extends StatelessWidget {
  const AdminSignUpScreen({Key? key}) : super(key: key);

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
        backgroundColor: const Color(0xFF2D2D50),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserTypeScreen()),
            );
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
                const Icon(Icons.admin_panel_settings, size: 60, color: Colors.blue),
                const SizedBox(height: 16),
                const TextField(decoration: InputDecoration(labelText: 'Admin Name')),
                const SizedBox(height: 12),
                const TextField(decoration: InputDecoration(labelText: 'Email Address')),
                const SizedBox(height: 12),
                const TextField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                const TextField(decoration: InputDecoration(labelText: 'Code')),
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
