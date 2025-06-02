import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../screens/myths_page.dart';
import '../../screens/precautions_page.dart';
import '../../screens/symptoms_page.dart';
import '../../screens/updates_page.dart';
import '../../screens/virus_details_page.dart';
import '../../screens/stats_dashboard_screens/world_stat.dart';
import '../../screens/nearby_hospitals_screen.dart';
import '../../screens/symptom_checker.dart'; // Import Symptom Checker Screen

class CategoryTab extends StatelessWidget {
  final String imgPath, tabName, tabDesc;
  final double imgHeight, imgLeft, imgBottom;
  final Color color;
  final AutoSizeGroup titleGrp, descGrp;

  const CategoryTab({
    required this.imgPath,
    required this.tabName,
    required this.tabDesc,
    required this.color,
    required this.titleGrp,
    required this.descGrp,
    this.imgHeight = 150.0,
    this.imgLeft = 15.0,
    this.imgBottom = -8.0,
  });

  Function getPage(String tabName, BuildContext context) {
    switch (tabName) {
      case "Symptoms":
        return () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                SymptomsScreen(color: color, imgPath: imgPath)));
      case "Precautions":
        return () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                PrecautionsScreen(color: color, imgPath: imgPath)));
      case "Myths":
        return () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MythsScreen(color: color, imgPath: imgPath)));
      case "Virus":
        return () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                VirusDetailsScreen(color: color, imgPath: imgPath)));
      case "Updates":
        return () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                UpdatesPage(color: color, imgPath: imgPath)));
      case "Phylogeny":
        return () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => WorldStatScreen()));
      case "Nearby Hospitals":  
        return () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                NearbyHospitalsScreen(color: color, imgPath: imgPath)));
      case "Symptom Checker":  
        return () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                SymptomCheckerScreen())); // Navigate to Symptom Checker
      default:
        return () {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => getPage(tabName, context)(),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
        height: 142,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(left: 150, right: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: color.withOpacity(0.13),
                  ),
                  height: 125,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AutoSizeText(
                        tabName,
                        style: TextStyle(
                          color: color,
                          fontFamily: "Montserrat",
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                        ),
                        stepGranularity: 1,
                        maxFontSize: 23,
                        maxLines: 1,
                        group: titleGrp,
                      ),
                      AutoSizeText(
                        tabDesc,
                        style: TextStyle(
                          color: color,
                          fontFamily: "Montserrat",
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                        ),
                        stepGranularity: 1,
                        maxFontSize: 19,
                        maxLines: 3,
                        group: descGrp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: imgLeft,
              bottom: imgBottom,
              child: Container(
                height: imgHeight,
                child: Hero(
                    tag: imgPath, child: Image(image: AssetImage(imgPath))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
