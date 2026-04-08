import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString("name") ?? "No Name";
      email = prefs.getString("email") ?? "No Email";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2F),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 30),

            /// 👤 Avatar
            const CircleAvatar(
              radius: 55,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),

            const SizedBox(height: 20),

            /// 👤 Name (Big Text)
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            /// 📦 Info Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [

                  /// 📧 Email
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.blueAccent),
                    title: const Text(
                      "Email",
                      style: TextStyle(color: Colors.white70),
                    ),
                    subtitle: Text(
                      email,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                  const Divider(color: Colors.white24, height: 1),

                  /// 👤 Name
                  ListTile(
                    leading: const Icon(
                        Icons.person, color: Colors.purpleAccent),
                    title: const Text(
                      "Name",
                      style: TextStyle(color: Colors.white70),
                    ),
                    subtitle: Text(
                      name,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}