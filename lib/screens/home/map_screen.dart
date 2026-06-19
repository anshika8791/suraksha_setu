import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? currentPosition;
  final Set<Marker> _markers = {};

  late final String apiKey;

  @override
  void initState() {
    super.initState();

    apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

    _init();
  }

  Future<void> _init() async {
    await _getUserLocation();

    if (currentPosition != null) {
      await _fetchAllSafePlaces();
    }
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled =
    await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      debugPrint("Location service disabled");
      return;
    }

    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
      await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission ==
            LocationPermission.deniedForever) {
      return;
    }

    Position position =
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );

    currentPosition = LatLng(
      position.latitude,
      position.longitude,
    );

    _markers.add(
      Marker(
        markerId: const MarkerId("user"),
        position: currentPosition!,
        infoWindow:
        const InfoWindow(title: "You are here"),
        icon:
        BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue,
        ),
      ),
    );

    setState(() {});
  }

  Future<void> _fetchAllSafePlaces() async {
    await _fetchPlacesByType("hospital");
    await _fetchPlacesByType("police");
    await _fetchPlacesByType("fire_station");
    await _fetchPlacesByKeyword("shelter");

    setState(() {});
  }

  Future<void> _fetchPlacesByType(String type) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        "?location=${currentPosition!.latitude},${currentPosition!.longitude}"
        "&radius=5000"
        "&type=$type"
        "&key=$apiKey";

    final response = await http.get(
      Uri.parse(url),
    );

    final data = jsonDecode(response.body);

    if (data["results"] != null) {
      for (var place in data["results"]) {
        _addMarker(place);
      }
    }
  }

  Future<void> _fetchPlacesByKeyword(
      String keyword) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        "?location=${currentPosition!.latitude},${currentPosition!.longitude}"
        "&radius=5000"
        "&keyword=$keyword"
        "&key=$apiKey";

    final response = await http.get(
      Uri.parse(url),
    );

    final data = jsonDecode(response.body);

    if (data["results"] != null) {
      for (var place in data["results"]) {
        _addMarker(place);
      }
    }
  }

  void _addMarker(dynamic place) {
    final lat =
    place["geometry"]["location"]["lat"];
    final lng =
    place["geometry"]["location"]["lng"];
    final name = place["name"];

    _markers.add(
      Marker(
        markerId:
        MarkerId("$name$lat$lng"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: name,
          snippet: "Tap for directions",
          onTap: () {
            _openDirections(lat, lng);
          },
        ),
        icon:
        BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        ),
      ),
    );
  }

  Future<void> _openDirections(
      double lat,
      double lng,
      ) async {
    final uri = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode:
        LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentPosition == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: currentPosition!,
        zoom: 14,
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }
}