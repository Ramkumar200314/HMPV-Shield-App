import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MythsScreen extends StatefulWidget {
  final String imgPath;
  final Color color;

  MythsScreen({Key? key, required this.imgPath, required this.color}) : super(key: key);

  @override
  _MythsScreenState createState() => _MythsScreenState();
}

class _MythsScreenState extends State<MythsScreen> {
  final PageController controller = PageController(initialPage: 0);
  late Timer _timer;
  int _currentPage = 0;

  List<Map<String, String>> myths = [
    {
      "myth": "HMPV (Human Metapneumovirus) CAN ONLY affect children",
      "desc": "HMPV can affect people of all ages. Although children, elderly, and those with weakened immune systems may be at higher risk, adults can also get infected.",
      "imgPath": "assets/myths/hmpv_children.png",
    },
    {
      "myth": "HMPV is only transmitted through contact with respiratory droplets",
      "desc": "HMPV can spread through respiratory droplets, but it may also spread by touching surfaces contaminated with the virus and then touching the mouth, nose, or eyes.",
      "imgPath": "assets/myths/hmpv_contact.jfif",
    },
    {
      "myth": "Antibiotics CAN treat HMPV infections",
      "desc": "HMPV is a viral infection, so antibiotics are not effective. Antiviral treatments specifically for HMPV are not widely available. Treatment is typically supportive.",
      "imgPath": "assets/myths/hmpv_antibiotic.jfif",
    },
    {
      "myth": "HMPV infections only cause mild symptoms",
      "desc": "HMPV can cause a range of symptoms from mild to severe, especially in vulnerable populations such as the elderly and those with underlying health conditions. It can lead to pneumonia and bronchiolitis.",
      "imgPath": "assets/myths/hmpv_severity.jfif",
    },
    {
      "myth": "You CANNOT get HMPV more than once",
      "desc": "It is possible to get infected with HMPV more than once, as immunity from a previous infection may not last long enough to prevent reinfection.",
      "imgPath": "assets/myths/hmpv_reinfection.jfif",
    },
    {
      "myth": "HMPV infections are only a concern in the winter months",
      "desc": "While HMPV is more common in winter, it can circulate year-round and cause illness in any season.",
      "imgPath": "assets/myths/hmpv_season.jfif",
    },
  ];

  @override
  void initState() {
    super.initState();

    // Timer to automatically slide pages every 3 seconds
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < myths.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // Loop back to the first myth
      }
      controller.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: widget.color,
              size: 28,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          // Cover Image Container
          Container(
            height: 230,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0),
              ),
              color: widget.color.withOpacity(0.2),
            ),
            width: MediaQuery.of(context).size.width,
            child: LayoutBuilder(
              builder: (ctx, constraint) => Stack(
                children: <Widget>[
                  // Title
                  Positioned(
                    top: constraint.maxHeight * 0.45,
                    left: 20,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: constraint.maxWidth * 0.55,
                        child: AutoSizeText(
                          "Virus Myths",
                          style: TextStyle(
                            color: widget.color,
                            fontFamily: "Montserrat",
                            fontSize: 31,
                            fontWeight: FontWeight.w700,
                          ),
                          stepGranularity: 1,
                          maxFontSize: 31,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),

                  // Image
                  Positioned.fill(
                    bottom: -17.0,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: LayoutBuilder(
                          builder: (ctx, constraint) => Hero(
                            tag: widget.imgPath,
                            child: Image(
                              image: AssetImage(widget.imgPath),
                              height: constraint.maxHeight * 0.93, // Increased image size
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Myth card
          Flexible(
            fit: FlexFit.loose,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 15),
              width: MediaQuery.of(context).size.width > 360.0
                  ? MediaQuery.of(context).size.width - 31.0
                  : MediaQuery.of(context).size.width,
              child: Material(
                borderRadius: BorderRadius.circular(15.0),
                elevation: 5,
                child: Column(
                  children: <Widget>[
                    // Details
                    Flexible(
                      fit: FlexFit.loose,
                      child: PageView.builder(
                        controller: controller,
                        physics: BouncingScrollPhysics(),
                        itemCount: myths.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.fromLTRB(23, 35, 23, 15),
                            child: LayoutBuilder(
                              builder: (ctx, constraint) => Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  LimitedBox(
                                    maxHeight: constraint.maxHeight * 0.35, // Increased image size
                                    child: Image(
                                      image: AssetImage(
                                          "${myths[index]["imgPath"]}"),
                                      height: 120.0, // Increased size
                                    ),
                                  ),
                                  SizedBox(
                                    height: constraint.maxHeight * 0.11,
                                  ),
                                  LimitedBox(
                                    maxHeight: constraint.maxHeight * 0.17,
                                    child: AutoSizeText(
                                      "${myths[index]["myth"]}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 19,
                                        height: 1.1,
                                        fontFamily: "Montserrat",
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxFontSize: 20,
                                      stepGranularity: 2,
                                      maxLines: 3,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 13,
                                  ),
                                  LimitedBox(
                                    maxHeight: constraint.maxHeight * 0.45,
                                    child: AutoSizeText(
                                      "${myths[index]['desc']}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16.5,
                                        height: 1.4,
                                        fontFamily: "Montserrat",
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxFontSize: 16.5,
                                      stepGranularity: 1.5,
                                      maxLines: 6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Dot Indicator
                    Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      child: SmoothPageIndicator(
                        controller: controller,
                        count: myths.length,
                        effect: WormEffect(
                          dotHeight: 11,
                          dotWidth: 11,
                          spacing: 12.0,
                          strokeWidth: 1.2,
                          dotColor: Colors.grey[400]!,

                          activeDotColor: Colors.redAccent[700]!,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
