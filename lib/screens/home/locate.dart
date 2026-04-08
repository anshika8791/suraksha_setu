import 'package:flutter/material.dart';

class SafeLocationsScreen extends StatelessWidget {
  const SafeLocationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safe Locations'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);  // Navigates back to dashboard
          },
        ),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text(
          'Will be provided soon',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
