import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:animate_do/animate_do.dart'; // For animations
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For stylish icons
import 'package:url_launcher/url_launcher.dart'; // For opening links
import '../widgets/home_page_widgets/home_categories.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _userRating = 3; // Default rating

  // Show Rate Us Dialog
  void _showRateDialog() {
    showDialog(
      context: context,
      builder: (context) => FadeIn(
        duration: const Duration(milliseconds: 300),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Rate HMPV Shield", textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("How would you rate our app?", textAlign: TextAlign.center),
              const SizedBox(height: 10),
              StatefulBuilder(
                builder: (context, setState) => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _userRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            _userRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            _customButton("Close", Colors.grey, () => Navigator.pop(context)),
            _customButton("Submit", Colors.blue, () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Thanks for rating $_userRating stars!"),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // Show Credits Dialog
  void _showCreditsDialog() {
    showDialog(
      context: context,
      builder: (context) => FadeIn(
        duration: const Duration(milliseconds: 300),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("App Credits", textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Developed by: Ram Kumar\n\nSpecial thanks to contributors and testers."),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.github, color: Colors.black),
                    onPressed: () => _launchURL('https://github.com/Ramkumar200314/'),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.linkedin, color: Colors.blue),
                    onPressed: () => _launchURL('https://linkedin.com/in/ram-kumar-kundrapu-57387b2a5/'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            _customButton("Close", Colors.grey, () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  // Function to open URLs properly
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Show About Dialog
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => FadeIn(
        duration: const Duration(milliseconds: 300),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("About HMPV Shield", textAlign: TextAlign.center),
          content: const Text(
            "HMPV Shield is an awareness app designed to provide essential "
            "information about Human Metapneumovirus (HMPV).\n\n"
            "**Features:**\n"
            "✔ Symptoms, precautions, myths\n"
            "✔ Latest updates on HMPV\n"
            "✔ Nearby hospital search\n"
            "✔ Interactive statistics dashboard\n\n"
            "Stay informed, stay safe!",
            textAlign: TextAlign.center,
          ),
          actions: [
            _customButton("Close", Colors.grey, () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  // Custom Button Widget for Dialogs
  Widget _customButton(String text, Color color, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: Colors.black, size: 28),
          onSelected: (value) {
            if (value == 'rate') {
              _showRateDialog();
            } else if (value == 'credits') {
              _showCreditsDialog();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'rate', child: Text("⭐ Rate Us")),
            const PopupMenuItem(value: 'credits', child: Text("👨‍💻 Credits")),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showAboutDialog, // Fixed info icon functionality
            icon: const Icon(Icons.info_outline, color: Colors.black, size: 28),
          ),
        ],
        centerTitle: true,
        title: AutoSizeText(
          "HMPV SHIELD",
          style: const TextStyle(
            fontSize: 22,
            fontFamily: "Montserrat",
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
          minFontSize: 14,
          stepGranularity: 2,
          maxLines: 1,
        ),
      ),
      body: HomeCategories(),
    );
  }
}
