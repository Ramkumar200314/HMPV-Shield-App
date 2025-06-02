import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class NearbyHospitalsScreen extends StatefulWidget {
  final Color color; 
  final String imgPath; 

  const NearbyHospitalsScreen({required this.color, required this.imgPath}); 

  @override
  _NearbyHospitalsScreenState createState() => _NearbyHospitalsScreenState();
}

class _NearbyHospitalsScreenState extends State<NearbyHospitalsScreen> {
  late GoogleMapController mapController;
  LatLng _userLocation = const LatLng(16.9891, 82.2475); 
  Set<Marker> _markers = {};
  bool _isLoading = true;

  static const String apiKey = "AlzaSyfXCCgsK5WE1U8bm9EvZJAyJv6ZIH7lpiF"; 

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // Get User's Location
  Future<void> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied.")),
        );
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
      _markers.add(Marker(
        markerId: const MarkerId("user_location"),
        position: _userLocation,
        infoWindow: const InfoWindow(title: "Your Location"),
      ));
    });

    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newLatLngZoom(_userLocation, 14.0));
    }

    _fetchNearbyHospitals();
  }

  // Fetch Only Nearby Hospitals
  Future<void> _fetchNearbyHospitals() async {
    setState(() => _isLoading = true);

    String url =
        "https://maps.gomaps.pro/maps/api/place/nearbysearch/json?location=${_userLocation.latitude},${_userLocation.longitude}&radius=20000&type=hospital&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        setState(() {
          _markers.addAll(data['results'].map<Marker>((hospital) {
            return Marker(
              markerId: MarkerId(hospital['place_id']),
              position: LatLng(
                hospital['geometry']['location']['lat'],
                hospital['geometry']['location']['lng'],
              ),
              infoWindow: InfoWindow(
                title: hospital['name'],
                snippet: hospital['vicinity'],
              ),
            );
          }).toList());
        });

        if (mapController != null && _markers.isNotEmpty) {
          mapController.animateCamera(CameraUpdate.newLatLngBounds(_getBounds(), 100));
        }
      } else {
        print("No hospitals found. Status: ${data['status']}");
      }
    } catch (e) {
      print("Error fetching hospitals: $e");
    }

    setState(() => _isLoading = false);
  }

  // Calculate map bounds to fit all hospitals
  LatLngBounds _getBounds() {
    double minLat = _userLocation.latitude, maxLat = _userLocation.latitude;
    double minLng = _userLocation.longitude, maxLng = _userLocation.longitude;

    for (var marker in _markers) {
      minLat = marker.position.latitude < minLat ? marker.position.latitude : minLat;
      maxLat = marker.position.latitude > maxLat ? marker.position.latitude : maxLat;
      minLng = marker.position.longitude < minLng ? marker.position.longitude : minLng;
      maxLng = marker.position.longitude > maxLng ? marker.position.longitude : maxLng;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_userLocation.latitude != 0 && _userLocation.longitude != 0) {
      mapController.animateCamera(CameraUpdate.newLatLngZoom(_userLocation, 14.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color, // ✅ Use the passed color
        title: const Text("Nearby Hospitals"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _userLocation,
              zoom: 14.0,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          if (_isLoading)
            Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
