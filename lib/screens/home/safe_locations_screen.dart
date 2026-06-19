import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'package:suraksha_setu/screens/home/map_screen.dart';

class SafeLocationsScreen extends StatelessWidget {
  const SafeLocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nearby Safe Locations"),
      ),
      body: MapScreen(),
    );
  }
}