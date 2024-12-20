import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/calendar.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/package%20box.dart';
import 'package:taqreeb/theme/color.dart';

class CategoryView_Venue extends StatefulWidget {
  const CategoryView_Venue({super.key});

  @override
  State<CategoryView_Venue> createState() => _CategoryView_VenueState();
}

class _CategoryView_VenueState extends State<CategoryView_Venue> {
  int _currentIndex = 0;
  String description =
      "Qasr-e-Noor is a premier marriage hall located in the heart of Karachi, offering an elegant and spacious venue for weddings, receptions, and other special events. The hall is designed to accommodate both large and intimate gatherings, with luxurious interiors, state-of-the-art facilities, and exceptional services to make your event unforgettable";
  bool isToggled = true;
  List<String> headings = ['Venue Type', 'Catering', 'Staff', 'Guests'];
  List<String> values = [
    'Banquet',
    'Internal & External',
    'Male',
    '200-500 Persons'
  ];
  List<String> addonsheadings = ['Decoration', 'Female Staff', 'Extra Staff'];
  List<String> addonsvalues = [
    'Rs. 30,000',
    'Rs. 10,000',
    'Rs. 100/Person',
  ];
  List<String> stars = [
    '5 Stars',
    '4 Stars',
    '3 Stars',
    '2 Stars',
    '1 Stars',
  ];
  List<String> starsvalue = [
    '(32)',
    '(21)',
    '(3)',
    '(2)',
    '(4)',
  ];

  final List<String> _imageUrls = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5DJA0WgEFo7X9kXf00EtVnpGPD3mAvh1e8A&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5DJA0WgEFo7X9kXf00EtVnpGPD3mAvh1e8A&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5DJA0WgEFo7X9kXf00EtVnpGPD3mAvh1e8A&s',
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double maximumDimension =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.3,
                      child: PageView.builder(
                        itemCount: _imageUrls.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            _imageUrls[index],
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: -(maximumDimension * 0.01),
                      child: Container(
                        height: maximumDimension * 0.05,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: MyColors.Dark,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.only(top: maximumDimension * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_imageUrls.length, (index) {
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              width: _currentIndex == index
                                  ? maximumDimension * 0.015
                                  : maximumDimension * 0.01,
                              height: _currentIndex == index
                                  ? maximumDimension * 0.015
                                  : maximumDimension * 0.01,
                              decoration: BoxDecoration(
                                color: _currentIndex == index
                                    ? MyColors.red
                                    : MyColors.whiteDarker,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Container(
              width: screenWidth,
              color: MyColors.Dark,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.01,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "Qasr - e - Noor Banquet",
                            softWrap: true,
                            style: GoogleFonts.montserrat(
                              fontSize: maximumDimension * 0.025,
                              fontWeight: FontWeight.w600,
                              color: MyColors.white,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.add,
                          color: MyColors.Yellow,
                          size: maximumDimension * 0.05,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: maximumDimension * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.star, color: MyColors.Yellow),
                              Text(
                                "4.5 (30)",
                                style: GoogleFonts.montserrat(
                                    fontSize: maximumDimension * 0.015,
                                    color: MyColors.white),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "North Nazimabad Block M, Karachi",
                            softWrap: true,
                            style: GoogleFonts.montserrat(
                                fontSize: maximumDimension * 0.015,
                                color: MyColors.white),
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: maximumDimension * 0.01),
                          child: Icon(
                            Icons.location_on,
                            color: MyColors.white,
                            size: maximumDimension * 0.04,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                    child: Center(
                        child: MyDivider(
                      width: screenWidth * 0.85,
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pricing:",
                              style: GoogleFonts.montserrat(
                                fontSize: maximumDimension * 0.02,
                                fontWeight: FontWeight.w500,
                                color: MyColors.white,
                              ),
                            ),
                            Text(
                              "Rs. 200,000 - 700,000",
                              style: GoogleFonts.montserrat(
                                fontSize: maximumDimension * 0.02,
                                fontWeight: FontWeight.w400,
                                color: MyColors.white,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: maximumDimension * 0.015),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Basic Price:",
                                style: GoogleFonts.montserrat(
                                  fontSize: maximumDimension * 0.015,
                                  fontWeight: FontWeight.w500,
                                  color: MyColors.Yellow,
                                ),
                              ),
                              Text(
                                "200,000",
                                style: GoogleFonts.montserrat(
                                  fontSize: maximumDimension * 0.015,
                                  fontWeight: FontWeight.w400,
                                  color: MyColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                    child: Center(
                        child: MyDivider(
                      width: screenWidth * 0.85,
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin:
                              EdgeInsets.only(bottom: maximumDimension * 0.015),
                          child: Text(
                            "Description",
                            style: GoogleFonts.montserrat(
                              fontSize: maximumDimension * 0.025,
                              fontWeight: FontWeight.w600,
                              color: MyColors.Yellow,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => setState(() => isToggled = !isToggled),
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: maximumDimension * 0.01),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  description,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: isToggled ? 6 : 200,
                                  style: GoogleFonts.montserrat(
                                    fontSize: maximumDimension * 0.015,
                                    fontWeight: FontWeight.w300,
                                    color: MyColors.white,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                                Icon(isToggled
                                    ? Icons.arrow_downward_outlined
                                    : Icons.arrow_upward_outlined)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                    child: Center(
                        child: MyDivider(
                      width: screenWidth * 0.85,
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: Column(
                      children: [
                        for (var heading in headings)
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: maximumDimension * 0.01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  heading,
                                  style: GoogleFonts.montserrat(
                                    fontSize: maximumDimension * 0.015,
                                    fontWeight: FontWeight.w500,
                                    color: MyColors.Yellow,
                                  ),
                                ),
                                Text(
                                  values[headings.indexOf(heading)],
                                  style: GoogleFonts.montserrat(
                                    fontSize: maximumDimension * 0.015,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                    child: Center(
                        child: MyDivider(
                      width: screenWidth * 0.85,
                    )),
                  ),
                  Text(
                    'Add-Ons',
                    style: GoogleFonts.montserrat(
                      fontSize: maximumDimension * 0.025,
                      fontWeight: FontWeight.w600,
                      color: MyColors.Yellow,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: Column(
                      children: [
                        for (var heading in addonsheadings)
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: maximumDimension * 0.01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  heading,
                                  style: GoogleFonts.montserrat(
                                    fontSize: maximumDimension * 0.015,
                                    fontWeight: FontWeight.w500,
                                    color: MyColors.Yellow,
                                  ),
                                ),
                                Text(
                                  addonsvalues[addonsheadings.indexOf(heading)],
                                  style: GoogleFonts.montserrat(
                                    fontSize: maximumDimension * 0.015,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                    child: Center(
                        child: MyDivider(
                      width: screenWidth * 0.85,
                    )),
                  ),
                  Text(
                    'Packages',
                    style: GoogleFonts.montserrat(
                      fontSize: maximumDimension * 0.025,
                      fontWeight: FontWeight.w600,
                      color: MyColors.Yellow,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: Column(
                      children: [
                        PackageBox(
                            packagedetails: '',
                            packageprice: '20,000',
                            packagename: 'Standard'),
                        PackageBox(
                            packagedetails: '',
                            packageprice: '20,000',
                            packagename: 'Standard'),
                        PackageBox(
                            packagedetails: 'Flower Decoration',
                            packageprice: '20,000',
                            packagename: 'Standard'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                    child: Center(
                        child: MyDivider(
                      width: screenWidth * 0.85,
                    )),
                  ),
                  Text(
                    'Available Slots',
                    style: GoogleFonts.montserrat(
                      fontSize: maximumDimension * 0.025,
                      fontWeight: FontWeight.w600,
                      color: MyColors.Yellow,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: maximumDimension * 0.02,
                        horizontal: maximumDimension * 0.01),
                    child: CalendarView(
                      bookedDates: [
                        DateTime.now().add(const Duration(days: 3)),
                        DateTime.now().add(const Duration(days: 5)),
                        DateTime.now().add(const Duration(days: 10)),
                        DateTime.now().add(const Duration(days: 15)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                    child: Center(
                        child: MyDivider(
                      width: screenWidth * 0.85,
                    )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reviews',
                        style: GoogleFonts.montserrat(
                          fontSize: maximumDimension * 0.025,
                          fontWeight: FontWeight.w600,
                          color: MyColors.Yellow,
                        ),
                      ),
                      Text(
                        'View All',
                        style: GoogleFonts.montserrat(
                          fontSize: maximumDimension * 0.015,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: maximumDimension * 0.02,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '30 Reviews',
                          style: GoogleFonts.montserrat(
                            fontSize: maximumDimension * 0.015,
                            fontWeight: FontWeight.w400,
                            color: MyColors.white,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Icon(Icons.star, color: MyColors.Yellow),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          "4.5",
                          style: GoogleFonts.montserrat(
                              fontSize: maximumDimension * 0.015,
                              color: MyColors.white),
                        ),
                      ],
                    ),
                  ),
                  for (var star in stars)
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: maximumDimension * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            star,
                            style: GoogleFonts.montserrat(
                              fontSize: maximumDimension * 0.015,
                              fontWeight: FontWeight.w500,
                              color: MyColors.white,
                            ),
                          ),
                          Text(
                            starsvalue[stars.indexOf(star)],
                            style: GoogleFonts.montserrat(
                              fontSize: maximumDimension * 0.015,
                              fontWeight: FontWeight.w500,
                              color: MyColors.Yellow,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: screenHeight * 0.05,
                    child: Center(
                        child: MyDivider(
                      width: screenWidth * 0.85,
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.03),
                    child: Center(child: ColoredButton(text: 'Book Venue')),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
