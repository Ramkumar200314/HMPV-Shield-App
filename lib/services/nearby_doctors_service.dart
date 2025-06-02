import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class NearbyDoctorsService {
  static const String googlePlacesApiKey = "AlzaSyfXCCgsK5WE1U8bm9EvZJAyJv6ZIH7lpiF";

  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<List<Map<String, String>>> fetchNearbyDoctors() async {
    Position position = await _getCurrentLocation();

    final url = Uri.parse(
        "https://maps.gomaps.pro/maps/api/place/nearbysearch/json?"
        "location=${position.latitude},${position.longitude}"
        "&radius=5000" 
        "&type=doctor"
        "&key=$googlePlacesApiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Map<String, String>> doctors = [];

      for (var place in data["results"]) {
        doctors.add({
          "name": place["name"] ?? "Unknown Doctor",
          "address": place["vicinity"] ?? "No Address",
          "place_id": place["place_id"] ?? "",
        });
      }
      return doctors;
    } else {
      throw Exception("Failed to load nearby doctors");
    }
  }
}
