import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class VirusDetailsScreen extends StatelessWidget {
  final String imgPath;
  final Color color;

  static List<Map<String, String>> details = [
    {
      "detail": "Introduction",
      "desc":
          "Human Metapneumovirus (HMPV) is a virus that causes respiratory infections, primarily in young children, the elderly, and individuals with weakened immune systems. It is part of the Paramyxoviridae family, which also includes viruses like the respiratory syncytial virus (RSV). HMPV is known for causing upper and lower respiratory infections, such as the common cold, pneumonia, and bronchitis.",
    },
    {
      "detail": "Origin",
      "desc": "HMPV was first identified in the Netherlands in 2001. It is thought to be a human-specific virus, and while it can be found worldwide, its peak activity is often during the winter and early spring months. The virus is primarily spread through respiratory droplets when an infected person coughs or sneezes, though it can also be spread by direct contact with contaminated surfaces.",
    },
    {
      "detail": "How dangerous is it?",
      "desc": "HMPV can range in severity from mild symptoms, such as a runny nose or cough, to more severe conditions like pneumonia or bronchiolitis, especially in infants and the elderly. In most cases, the infection resolves on its own, but hospitalization may be required in severe cases. People with pre-existing respiratory conditions or weakened immune systems are more vulnerable to complications.",
    },
    {
      "detail": "How is it transmitted?",
      "desc": "HMPV is primarily spread through respiratory droplets from an infected person's coughs or sneezes. It can also be transmitted by touching surfaces contaminated with the virus and then touching the face, particularly the mouth, nose, or eyes. The virus is most contagious during the symptomatic phase, but it can also be spread by people who are asymptomatic.",
    },
    {
      "detail": "Are there any vaccines for HMPV?",
      "desc": "Currently, there is no vaccine available for HMPV. Treatment focuses on relieving symptoms and supporting respiratory function, such as using humidifiers or administering oxygen if necessary. Research into vaccines and treatments for HMPV is ongoing, but there is no specific antiviral medication for the virus as of now.",
    },
  ];

  static AutoSizeGroup titleGrp = AutoSizeGroup();
  static AutoSizeGroup descGrp = AutoSizeGroup();

  // Add required modifier to parameters.
  const VirusDetailsScreen({
    Key? key, // Use Key? to make it nullable
    required this.imgPath,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double pageHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: color,
            size: 28,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: pageHeight,
        child: Column(
          children: <Widget>[
            //image tag container
            Container(
              height: 220,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                  ),
                  color: color.withOpacity(0.2)),
              width: MediaQuery.of(context).size.width,
              child: LayoutBuilder(
                builder: (ctx, constraint) => Stack(
                  children: <Widget>[
                    //Title
                    Positioned(
                      top: constraint.maxHeight * 0.45,
                      left: 20,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: constraint.maxWidth * 0.55,
                          child: AutoSizeText(
                            "HMPV",
                            style: TextStyle(
                              color: color,
                              fontFamily: "Montserrat",
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                            stepGranularity: 2,
                            maxFontSize: 30,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),

                    //Image
                    Positioned.fill(
                      right: -90,
                      bottom: -30,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: LayoutBuilder(
                          builder: (ctx, constraint) => Hero(
                              tag: imgPath,
                              child: Image(
                                image: AssetImage(imgPath),
                                height: constraint.maxHeight * 0.92,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Details List
            Container(
              height: pageHeight - 220,
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.all(0),
                scrollDirection: Axis.vertical,
                itemCount: details.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: LayoutBuilder(
                      builder: (ctx, constraint) => LimitedBox(
                        maxWidth: constraint.maxWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            AutoSizeText(
                              "${details[index]["detail"]}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 28,
                                fontFamily: "Montserrat",
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                              maxFontSize: 28,
                              stepGranularity: 2,
                              maxLines: 3,
                              group: titleGrp,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AutoSizeText(
                              "${details[index]['desc']}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 18,
                                height: 1.5,
                                fontFamily: "Montserrat",
                                color: Colors.grey[850],
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w500,
                              ),
                              maxFontSize: 18,
                              group: descGrp,
                              stepGranularity: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
