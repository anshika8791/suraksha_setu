import 'dart:convert';
import 'package:http/http.dart' as http;

class DisasterApiService {
  static const String baseUrl = "https://disaster-prediction-api.onrender.com";

  static const List<String> disasterTypes = [
    "Flood",
    "Earthquake",
    "Cyclone",
    "Drought",
    "Landslide",
  ];

  Future<Map<String, dynamic>> predict({
    required double lat,
    required double lon,
    required String disasterType,
    required String country,
    required String region,
    int durationDays = 3,
  }) async {
    try {
      final url = Uri.parse(
        "$baseUrl/predict"
            "?lat=$lat"
            "&lon=$lon"
            "&disaster_type=${Uri.encodeComponent(disasterType)}"
            "&country=${Uri.encodeComponent(country)}"
            "&region=${Uri.encodeComponent(region)}"
            "&duration_days=$durationDays",
      );

      final response = await http.get(url).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("API Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Request failed: $e");
    }
  }

  Future<List<Map<String, dynamic>>> predictAll({
    required double lat,
    required double lon,
    required String country,
    required String region,
  }) async {
    final results = <Map<String, dynamic>>[];
    for (final type in disasterTypes) {
      try {
        final result = await predict(
          lat: lat,
          lon: lon,
          disasterType: type,
          country: country,
          region: region,
        );
        results.add({...result, "queried_disaster_type": type});
      } catch (_) {}
    }
    return results;
  }
}