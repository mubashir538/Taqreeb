import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/package%20box.dart';
import 'package:taqreeb/theme/color.dart';

class CategoryView_GraphicDesigner extends StatefulWidget {
  const CategoryView_GraphicDesigner({super.key});

  @override
  State<CategoryView_GraphicDesigner> createState() =>
      _CategoryView_GraphicDesignerState();
}

class _CategoryView_GraphicDesignerState
    extends State<CategoryView_GraphicDesigner> {
  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  void _getHeaderHeight() {
    final RenderBox renderBox =
        _headerKey.currentContext?.findRenderObject() as RenderBox;
    setState(() {
      _headerHeight = renderBox.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: _headerHeight,
                ),
                Container(
                  child: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5DJA0WgEFo7X9kXf00EtVnpGPD3mAvh1e8A&s',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                SizedBox(
                  height: 1700,
                  width: 428,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            "Nabila's Salon and Salon",
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
                          SizedBox(width: 40),
                          Text(
                            "Rs. 25,000 - 30,000",
                            style: GoogleFonts.montserrat(
                              fontSize: 21,
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
                            "Basic Price: :",
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
                              "Nabila’s Spa offers a luxurious retreat with rejuvenating treatments that relax both body and mind. From facials to massages, their expert therapists provide a serene and personalized experience. Step into tranquility and leave feeling completely refreshed.",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
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
                            "Decor Type",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: MyColors.Yellow,
                            ),
                          ),
                          SizedBox(width: 180),
                          Text(
                            "Traditional",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: MyColors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            "Catering",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: MyColors.Yellow,
                            ),
                          ),
                          SizedBox(width: 130),
                          Text(
                            "Internal & External",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: MyColors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            "Staff",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: MyColors.Yellow,
                            ),
                          ),
                          SizedBox(width: 280),
                          Text(
                            "Male",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: MyColors.white,
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
                        height: 20,
                      ),
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
                            "Decorations",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: MyColors.Yellow,
                            ),
                          ),
                          SizedBox(width: 175),
                          Text(
                            "Rs. 30,000",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: MyColors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            "Female Staff",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: MyColors.Yellow,
                            ),
                          ),
                          SizedBox(width: 175),
                          Text(
                            "Rs. 10,000",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: MyColors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            "Extra Staff",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: MyColors.Yellow,
                            ),
                          ),
                          SizedBox(width: 160),
                          Text(
                            "Rs. 100/Person",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: MyColors.white,
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
                          SizedBox(width: 40),
                          SizedBox(
                              width: 346,
                              child: PackageBox(
                                  packagedetails: '',
                                  packageprice: '',
                                  packagename: 'VIP Package')),
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
                      ColoredButton(text: 'Book Us')
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(child: Header(
            key: _headerKey,
          )),
        ],
      ),
    );
  }
}
