import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/package%20box.dart';
import 'package:taqreeb/theme/color.dart';

class Categoryview_Spa extends StatelessWidget {
  const Categoryview_Spa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            Container(
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5DJA0WgEFo7X9kXf00EtVnpGPD3mAvh1e8A&s',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            SizedBox(
              height: 2000,
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
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Hair cut & Hair color",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                      SizedBox(width: 175),
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
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Hair Treatements",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                      SizedBox(width: 200),
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
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Manicure & Pedicure",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                      SizedBox(width: 175),
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
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Eyebrows & Lashes",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                      SizedBox(width: 185),
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
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Waxing",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                      SizedBox(width: 273),
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
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Skin Care",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                      SizedBox(width: 250),
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
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Makeup",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                      SizedBox(width: 260),
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
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Haicut & Protien Treatement",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ]
                  ),
                   SizedBox(
                    height: 10,
                  ),
                   Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Jenson Facial",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ]
                  ),
                   SizedBox(
                    height: 10,
                  ),
                   Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Eyebrows and Upperlips",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ]
                  ),
                  SizedBox(
                    height: 10,
                  ),
                   Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Full Body Wax",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ]
                  ),
                  SizedBox(
                    height: 10,
                  ),
                   Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Face Wax",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ]
                  ),
                  SizedBox(
                    height: 10,
                  ),
                   Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Manicure & Pedicure",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ]
                  ),
                  SizedBox(
                    height: 10,
                  ),
                   Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Neck Massage",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ]
                  ),
                   Row(
                    children: [
                      SizedBox(width: 300),
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
                  //grey container lgyga

                  SizedBox(height: 30),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Haicut & Protien Treatement",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ]
                  ),
                   SizedBox(
                    height: 10,
                  ),
                   Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Mix Fruit Facial",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ]
                  ),
                   SizedBox(
                    height: 10,
                  ),
                   Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Eyebrows and Upperlips",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ]
                  ),
                  SizedBox(
                    height: 10,
                  ),
                   Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Full Body Wax",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ]
                  ),
                  SizedBox(
                    height: 10,
                  ),
                   Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Face Wax",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ]
                  ),
                  SizedBox(
                    height: 10,
                  ),
                   Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Manicure & Pedicure",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ]
                  ),
                  SizedBox(
                    height: 10,
                  ),
                   Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Neck Massage",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ]
                  ),
                   Row(
                    children: [
                      SizedBox(width: 300),
                      Text(
                        "22,000",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: MyColors.Yellow,
                        ),
                      ),
                    ],
                  ),
                  //grey container lgyga

                  SizedBox(height: 30),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Haicut & Protien Treatement",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ]
                  ),
                   SizedBox(
                    height: 10,
                  ),
                   Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Hydra Facial",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ]
                  ),
                   SizedBox(
                    height: 10,
                  ),
                   Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Eyebrows and Upperlips",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ]
                  ),
                  SizedBox(
                    height: 10,
                  ),
                   Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Full Body Wax",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ]
                  ),
                  SizedBox(
                    height: 10,
                  ),
                   Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Face Wax",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ]
                  ),
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
    );
  }
}
