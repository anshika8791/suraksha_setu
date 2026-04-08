import 'package:flutter/material.dart';
import 'package:suraksha_setu/screens/home/video_player_screen.dart';

class NaturalDisasterScreen extends StatelessWidget {
  const NaturalDisasterScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> videos = const [
    {'title': 'Earthquake Safety', 'asset': 'assets/videos/earthquake.mp4'},
    // Add more video entries if needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D50),
      appBar: AppBar(
        title: const Text('Natural Disasters'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2D2D50), Color(0xFF1E1E2F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.play_circle_fill, color: Colors.green, size: 32),
                title: Text(
                  videos[index]['title']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoPlayerScreen(assetPath: videos[index]['asset']!),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}