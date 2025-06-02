import 'package:flutter/material.dart';
import '../utils/risk_assessment.dart';
import '../screens/nearby_doctors_screen.dart'; // Import Nearby Doctors Screen

class SymptomCheckerScreen extends StatefulWidget {
  @override
  _SymptomCheckerScreenState createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  List<String> symptoms = [
    "Cough",
    "Fever",
    "Shortness of Breath",
    "Sore Throat",
    "Fatigue",
    "Others"
  ];
  
  List<String> selectedSymptoms = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Symptom Checker")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Select Symptoms", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: symptoms.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(symptoms[index]),
                    value: selectedSymptoms.contains(symptoms[index]),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedSymptoms.add(symptoms[index]);
                        } else {
                          selectedSymptoms.remove(symptoms[index]);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                int riskLevel = calculateRisk(selectedSymptoms);
                String riskMessage = getRiskMessage(riskLevel);

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Risk Assessment"),
                    content: Text(riskMessage),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("OK"),
                      ),
                      if (riskLevel >= 2) // Show for Medium & High Risk
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NearbyDoctorsScreen(),
                              ),
                            );
                          },
                          child: Text("Find Nearby Doctors"),
                        ),
                    ],
                  ),
                );
              },
              child: Text("Check Risk Level"),
            ),
          ],
        ),
      ),
    );
  }
}
