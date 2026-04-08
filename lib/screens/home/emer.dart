import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> emergencyNumbers = const [
    {
      "title": "Police",
      "number": "100",
      "icon": Icons.local_police,
      "color": Colors.blue
    },
    {
      "title": "Ambulance",
      "number": "108",
      "icon": Icons.medical_services,
      "color": Colors.green
    },
    {
      "title": "Fire Brigade",
      "number": "101",
      "icon": Icons.local_fire_department,
      "color": Colors.red
    },
    {
      "title": "Women Helpline",
      "number": "1091",
      "icon": Icons.woman,
      "color": Colors.purple
    },
    {
      "title": "Disaster Management",
      "number": "1078",
      "icon": Icons.warning,
      "color": Colors.orange
    },
  ];

  Future<void> _callNumber(BuildContext context, String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);

    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: const Text("Confirm Call"),
            content: Text("Do you want to call $number?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  if (await canLaunchUrl(phoneUri)) {
                    await launchUrl(phoneUri);
                  }
                },
                child: const Text("Call"),
              ),
            ],
          ),
    );
  }

  Future<void> _openDialPad() async {
    final Uri phoneUri = Uri(scheme: 'tel');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2D2D50), Color(0xFF1E1E2F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              /// Custom App Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Emergency Contacts",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// Emergency Cards
              Expanded(
                child: ListView.builder(
                  itemCount: emergencyNumbers.length,
                  itemBuilder: (context, index) {
                    final item = emergencyNumbers[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () =>
                            _callNumber(context, item["number"]),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            children: [

                              /// Icon Circle
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: item["color"].withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  item["icon"],
                                  color: item["color"],
                                  size: 28,
                                ),
                              ),

                              const SizedBox(width: 16),

                              /// Title + Number
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item["title"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item["number"],
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(
                                Icons.call,
                                color: Colors.white70,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// Dial Pad Button
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.dialpad),
                    label: const Text(
                      "Open Dial Pad",
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8,
                    ),
                    onPressed: _openDialPad,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}