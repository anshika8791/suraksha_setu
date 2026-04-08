import 'package:flutter/material.dart';
import 'package:suraksha_setu/screens/home/video_player_screen.dart';

class ManMadeDisasterScreen extends StatelessWidget {
  const ManMadeDisasterScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> videos = const [
    {'title': 'Bomb Threat Response', 'asset': 'assets/videos/bomb_public.mp4'},
    //{'title': 'Chemical Spill Protocol', 'asset': 'assets/videos/chemical_spill.mp4'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D50),
      appBar: AppBar(title: const Text('Man-Made Disasters'), backgroundColor: Colors.orange),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.play_circle_fill, color: Colors.orange),
              title: Text(videos[index]['title']!),
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
    );
  }
}
