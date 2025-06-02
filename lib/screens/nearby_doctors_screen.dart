import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/nearby_doctors_service.dart';
import 'chat_screen.dart';

class NearbyDoctorsScreen extends StatefulWidget {
  @override
  _NearbyDoctorsScreenState createState() => _NearbyDoctorsScreenState();
}

class _NearbyDoctorsScreenState extends State<NearbyDoctorsScreen> {
  final NearbyDoctorsService _nearbyDoctorsService = NearbyDoctorsService();
  List<Map<String, String>> _doctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  void _fetchDoctors() async {
    try {
      List<Map<String, String>> doctors = await _nearbyDoctorsService.fetchNearbyDoctors();
      setState(() {
        _doctors = doctors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: $e");
    }
  }

  void _makeCall(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _startChat(BuildContext context, String doctorName) async {
    String chatRoomId = "chat_${doctorName.replaceAll(" ", "_")}";
    await FirebaseFirestore.instance.collection("chats").doc(chatRoomId).set({"doctor": doctorName});

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(doctorName: doctorName, chatRoomId: chatRoomId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nearby Doctors")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _doctors.length,
              itemBuilder: (context, index) {
                final doctor = _doctors[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(doctor["name"]!, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(doctor["address"]!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.call, color: Colors.green),
                          onPressed: () => _makeCall(doctor["phone"]!),
                        ),
                        IconButton(
                          icon: Icon(Icons.chat, color: Colors.blue),
                          onPressed: () => _startChat(context, doctor["name"]!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
