import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/package%20box.dart';
import 'package:taqreeb/theme/color.dart';

class Categoryview_Spa extends StatefulWidget {
  const Categoryview_Spa({super.key});

  @override
  State<Categoryview_Spa> createState() => _Categoryview_SpaState();
}

class _Categoryview_SpaState extends State<Categoryview_Spa> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5DJA0WgEFo7X9kXf00EtVnpGPD3mAvh1e8A&s',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                SizedBox(
                  height: 2300,
                  width: 428,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            "Nabila's Salon and Spa",
                            style: GoogleFonts.montserrat(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 30),
                          Icon(
                            Icons.add,
                            color: MyColors.Yellow,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Icon(
                            Icons.star,
                            color: MyColors.Yellow,
                          ),
                          Text(
                            "4.5 (30)",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(width: 10),
                          // SvgPicture.asset(MyIcons.mapMarker,
                          // height: 20,width: 20,)
                          // Icon(Icons.mapMarker,
                          // color: MyColors.Yellow,),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: 324,
                          child: Divider(
                            color: MyColors.DarkLighter,
                          )),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            "Pricing:",
                            style: GoogleFonts.montserrat(
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 90),
                          Text(
                            "Rs. 25,000 - 30,000",
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            "Basic Price:",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: MyColors.Yellow,
                            ),
                          ),
                          SizedBox(width: 180),
                          Text(
                            "28,000",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: MyColors.Yellow,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: 324,
                          child: Divider(
                            color: MyColors.DarkLighter,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            "Description",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: MyColors.Yellow,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Text(
                              "Nabila’s Spa offers a luxurious retreat with rejuvenating treatments that relax both body and mind. From facials to massages their expert therapists provide a serene and personalized experience. Step into tranquility and leave feeling completely refreshed.",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                                color: MyColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: 324,
                          child: Divider(
                            color: MyColors.DarkLighter,
                          )),
                      SizedBox(height: 10),

                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            "Add-Ons",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: MyColors.Yellow,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 270,
                        width: double
                            .infinity, // Ensures it takes up the full width
                        decoration: BoxDecoration(
                          color: MyColors
                              .DarkLighter, // Replace with your desired background color
                          borderRadius: BorderRadius.circular(
                              10), // Optional for rounded corners
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10), // Adds padding for content
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align content to the start
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Even spacing between rows
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Hair cut & Hair color",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.white,
                                  ),
                                ),
                                Text(
                                  "2000",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.Yellow,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Hair Treatments",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.white,
                                  ),
                                ),
                                Text(
                                  "1500",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.Yellow,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Manicure & Pedicure",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.white,
                                  ),
                                ),
                                Text(
                                  "1000",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.Yellow,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Eyebrows & Lashes",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.white,
                                  ),
                                ),
                                Text(
                                  "5000",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.Yellow,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Waxing",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.white,
                                  ),
                                ),
                                Text(
                                  "800",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.Yellow,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Skin Care",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.white,
                                  ),
                                ),
                                Text(
                                  "5000",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.Yellow,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Makeup",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.white,
                                  ),
                                ),
                                Text(
                                  "6000",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.Yellow,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      //grey container lgyga

                      SizedBox(
                          width: 324,
                          child: Divider(
                            color: MyColors.DarkLighter,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            "Packages",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: MyColors.Yellow,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(width: 40),
                          SizedBox(
                              width: 346,
                              child: PackageBox(
                                  packagedetails: '',
                                  packageprice: '',
                                  packagename: 'standard Package')),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity, // Full width
                        decoration: BoxDecoration(
                          color: MyColors.DarkLighter, // Background color
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20), // Padding for spacing
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align content to the start
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Aligns text in row with space between
                              children: [
                                Text(
                                  "Haircut & Protein Treatment",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.white,
                                  ),
                                ),
                                Text(
                                  "28,000",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.Yellow,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Jenson Facial",
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: MyColors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Eyebrows and Upperlips",
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: MyColors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Full Body Wax",
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: MyColors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Face Wax",
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: MyColors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Manicure & Pedicure",
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: MyColors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Neck Massage",
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: MyColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      //grey container lgyga

                      SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          color: MyColors.DarkLighter,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(20),
                        child: Center(
                          // Center content within the fixed height
                          child: Column(
                            mainAxisSize: MainAxisSize
                                .min, // Content takes only the space it needs
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Haircut & Protein Treatment",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: MyColors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Mix Fruit Facial",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: MyColors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Eyebrows and Upperlips",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: MyColors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Full Body Wax",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: MyColors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Face Wax",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: MyColors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Manicure & Pedicure",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: MyColors.white,  
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Neck Massage",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: MyColors.white,
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "22,000",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.Yellow,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      //grey container lgyga

                      SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          color: MyColors.DarkLighter,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(20),
                        child: Center(
                          // Center content within the fixed height

                          child: Column(
                            children: [
                              Row(children: [
                                SizedBox(width: 20),
                                Text(
                                  "Haicut & Protien Treatement",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.white,
                                  ),
                                ),
                              ]),
                              SizedBox(
                                height: 10,
                              ),
                              Row(children: [
                                SizedBox(width: 20),
                                Text(
                                  "Hydra Facial",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.white,
                                  ),
                                ),
                              ]),
                              SizedBox(
                                height: 10,
                              ),
                              Row(children: [
                                SizedBox(width: 20),
                                Text(
                                  "Eyebrows and Upperlips",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.white,
                                  ),
                                ),
                              ]),
                              SizedBox(
                                height: 10,
                              ),
                              Row(children: [
                                SizedBox(width: 20),
                                Text(
                                  "Full Body Wax",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.white,
                                  ),
                                ),
                              ]),
                              SizedBox(
                                height: 10,
                              ),
                              Row(children: [
                                SizedBox(width: 20),
                                Text(
                                  "Face Wax",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.white,
                                  ),
                                ),
                              ]),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 300),
                                  Text(
                                    "18,000",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: MyColors.Yellow,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      //grey container lgyga

                      SizedBox(height: 20),
                      SizedBox(
                          width: 324,
                          child: Divider(
                            color: MyColors.DarkLighter,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            "Reviews",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: MyColors.Yellow,
                            ),
                          ),
                          SizedBox(
                            width: 260,
                          ),
                          Icon(Icons.arrow_right),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            "30 Reviews",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: MyColors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.star,
                            color: MyColors.Yellow,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "4.5 ",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: MyColors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            "5 Stars",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: MyColors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "21",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: MyColors.Yellow,
                            ),
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          Text(
                            "4 Stars",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: MyColors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "10",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: MyColors.Yellow,
                            ),
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          Text(
                            "3 Stars",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: MyColors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "8",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: MyColors.Yellow,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            "2 Stars",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: MyColors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "3",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: MyColors.Yellow,
                            ),
                          ),
                          SizedBox(
                            width: 80,
                          ),
                          Text(
                            "1 Stars",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: MyColors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "2",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: MyColors.Yellow,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                          width: 324,
                          child: Divider(
                            color: MyColors.DarkLighter,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      ColoredButton(text: 'Book Appointments')
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
              child: Header(
            key: _headerKey,
          )),
        ],
      ),
    );
  }
}
