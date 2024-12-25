import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';

class Parlors extends StatefulWidget {
  const Parlors({super.key});

  @override
  State<Parlors> createState() => _ParlorsState();
}

class _ParlorsState extends State<Parlors> {
  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  void _getHeaderHeight() {
    final RenderObject? renderBox =
        _headerKey.currentContext?.findRenderObject();

    if (renderBox is RenderBox) {
      setState(() {
        _headerHeight = renderBox.size.height;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(children: [
                SizedBox(height: _headerHeight),

                SizedBox(
                  height: 30,
                ),

                //Text
                Text(
                  "Elevate your bridal experience with top artists in Karachi that\n"
                  "fit your budget on Taqreeb. Explore comprehensive details\n"
                  "about salon makeup artists, hairstylists, their pricing, and\n"
                  "more!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w200,
                      color: MyColors.white),
                ),
                SizedBox(
                  height: 30,
                ),

                //Spa and Services
                Container(
                  height: 170,
                  width: 380,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: MyColors.DarkLighter,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.network(
                        "https://t3.ftcdn.net/jpg/08/47/15/58/360_F_847155855_DsH51GZkt56KyrrsJpts9U2a1fwLhPlg.jpg",
                        width: 190,
                        height: 280,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Spa and Services"),
                          MyDivider(
                            width: 50,
                          ),
                          Text(
                            "Indulge in a variety of\n"
                            "spa services, from \n"
                            "soothing massages to\n"
                            "revitalizing facials, for\n"
                            "the ultimate wellness\n"
                            "experience.",
                            textAlign: TextAlign.end,
                            style: GoogleFonts.montserrat(
                                fontSize: 9,
                                fontWeight: FontWeight.w200,
                                color: MyColors.white),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),

                //Makeup
                Container(
                  height: 170,
                  width: 380,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: MyColors.DarkLighter,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.network(
                        "https://t3.ftcdn.net/jpg/08/47/15/58/360_F_847155855_DsH51GZkt56KyrrsJpts9U2a1fwLhPlg.jpg",
                        width: 190,
                        height: 250,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("MakeUp"),
                          MyDivider(
                            width: 40,
                          ),
                          Text(
                            "Enhance your natural\n"
                            "beauty with expertly\n"
                            "applied makeup, tailored\n"
                            "to highlight your best\n"
                            "features. Perfect for any\n"
                            "occasion, from casual\n"
                            "outings to glamorous\n"
                            "events.",
                            textAlign: TextAlign.end,
                            style: GoogleFonts.montserrat(
                                fontSize: 9,
                                fontWeight: FontWeight.w200,
                                color: MyColors.white),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),

                //Divider
                MyDivider(width: screenWidth * 0.6),
                const SizedBox(height: 20),

                //Colored Button
                ColoredButton(text: 'Continue'),
                SizedBox(
                  height: 20,
                ),
              ]),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: "Parlors",
              para: "Where beauty meets elegance!",
            ),
          ),
        ],
      ),
    );
  }
}
