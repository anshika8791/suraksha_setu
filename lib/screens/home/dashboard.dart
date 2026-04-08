import 'package:flutter/material.dart';
import 'package:suraksha_setu/screens/disaster/natural_disaster.dart';
import 'package:suraksha_setu/screens/disaster/manmade_disaster.dart';
import 'package:suraksha_setu/services/disaster_api_service.dart';
import 'package:suraksha_setu/screens/auth/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'emer.dart';
import 'locate.dart';
import 'package:suraksha_setu/services/location_service.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double? lat;
  double? lon;

  final LocationService _locationService = LocationService();
  final DisasterApiService _apiService = DisasterApiService();

  String? severity;
  String? advice;
  bool isLoadingPrediction = false;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      setState(() {
        lat = position.latitude;
        lon = position.longitude;
      });

      await _getPrediction();
    } catch (e) {
      print("Location error: $e");
    }
  }

  Future<void> _getPrediction() async {
    if (lat == null || lon == null) return;

    setState(() => isLoadingPrediction = true);

    try {
      final results = await _apiService.predictAll(
        lat: lat!,
        lon: lon!,
        country: "India",
        region: "Southern Asia",
      );

      if (results.isNotEmpty) {
        results.sort((a, b) =>
            b["severity_code"].compareTo(a["severity_code"]));

        final top = results.first;

        setState(() {
          severity = top["severity_label"];
          advice = top["advice"];
        });
      }
    } catch (e) {
      print("Prediction error: $e");
    }

    setState(() => isLoadingPrediction = false);
  }

  Future<void> _openYouTubePlaylist() async {
    final Uri url = Uri.parse(
      "https://youtu.be/WvIt_sM1kKc?si=xNd9Ia7CWK1HE_wn",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      backgroundColor: const Color(0xFF1C1C2E),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1C1C2E), Color(0xFF121212)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Welcome Back 👋",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      lat != null
                          ? "Lat: ${lat!.toStringAsFixed(4)}, Lon: ${lon!.toStringAsFixed(4)}"
                          : "Fetching your location...",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white54,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// 🔥 AI Prediction Card
                    _buildPredictionCard(),

                    const SizedBox(height: 30),

                    const Text(
                      "Quick Actions",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                    const EmergencyContactsScreen()),
                              );
                            },
                            child: _quickActionCard(
                                Icons.phone, "Emergency\nContacts"),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                    const SafeLocationsScreen()),
                              );
                            },
                            child: _quickActionCard(
                                Icons.location_on, "Safe\nLocations"),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),

                    /// Learning Modules
                    const Text(
                      "Learning Modules",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _learningModuleCard(
                      "Natural Disaster",
                      0.8,
                      Colors.green,
                      _openYouTubePlaylist,
                    ),

                    const SizedBox(height: 16),

                    _learningModuleCard(
                      "Man-Made Disaster",
                      0.45,
                      Colors.orange,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                              const ManMadeDisasterScreen()),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    _sectionCard("Mock Drills", "No drills available"),

                    const SizedBox(height: 20),

                    _sectionCard(
                      "Alerts",
                      severity != null
                          ? "Current Risk: $severity"
                          : "Fetching alerts...",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 Prediction Card
  Widget _buildPredictionCard() {
    Color color = Colors.blue;

    if (severity == "Low") color = Colors.green;
    if (severity == "Medium") color = Colors.orange;
    if (severity == "High") color = Colors.red;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
        ),
      ),
      child: isLoadingPrediction
          ? const Center(
          child: CircularProgressIndicator(color: Colors.white))
          : Row(
        children: [
          const Icon(Icons.warning, color: Colors.white, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  severity != null
                      ? "Risk Level: $severity"
                      : "Analyzing conditions...",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  advice ?? "Fetching AI prediction...",
                  style:
                  const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// AppBar
  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      floating: true,
      snap: true,
      expandedHeight: 90,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () =>
              Scaffold.of(context).openDrawer(),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding:
        const EdgeInsets.only(left: 16, bottom: 12),
        title: Row(
          children: [
            Image.asset('assets/LOGO (1).png', height: 30),
            const SizedBox(width: 10),
            const Text(
              "Suraksha Setu",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  /// Drawer
  static Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1E2F), Color(0xFF2D2D50)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [

            /// Header
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.purpleAccent],
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Suraksha Setu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            /// Profile
            _drawerTile(Icons.person, "Profile", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
            }),

            /// Modules
            _drawerTile(Icons.menu_book, "Modules", () {}),

            /// Logout
            _drawerTile(Icons.logout, "Logout", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
  /// Quick Action Card
  static Widget _quickActionCard(
      IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF2E2E48), Color(0xFF23233A)],
        ),
      ),
      padding: const EdgeInsets.symmetric(
          vertical: 30, horizontal: 12),
      child: Column(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 30),
          const SizedBox(height: 14),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  /// Learning Module Card (same as yours)
  static Widget _learningModuleCard(
      String title,
      double progress,
      Color progressColor,
      VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFF2E2E48), Color(0xFF23233A)],
          ),
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.school,
                    color: Colors.amber),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: progress),
          ],
        ),
      ),
    );
  }

  static Widget _sectionCard(
      String title, String content) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF23233A),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          Text(content,
              style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
  static Widget _drawerTile(
      IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }

}
