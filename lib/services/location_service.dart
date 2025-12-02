import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {

    Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception("Location services disabled");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are permanently denied");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  static Future<Map<String, double>> getCoordinatesFromPlace(String place) async {
    List<Location> locations = await locationFromAddress(place);

    return {
      "lat": locations.first.latitude,
      "lng": locations.first.longitude,
    };
  }
  static Future<String> predictDisaster(double lat, double lng) async {
    final url = Uri.parse("YOUR_MODEL_API_URL");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "latitude": lat,
        "longitude": lng,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["prediction"];
    } else {
      throw Exception("Prediction failed");
    }
  }
}
