import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/package%20box.dart';
import 'package:taqreeb/theme/color.dart';

class CategoryView_VideoEditor extends StatelessWidget {
  const CategoryView_VideoEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),

            // Image Section
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                'https://www.careergirls.org/wp-content/uploads/2018/05/Video_Editor1920x1080.jpg',
                fit: BoxFit.cover,
              ),
            ),

            // Main Content Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 40,
                vertical: 20,
              ),
              color: MyColors.Dark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Icon
                  buildTitleRow("Masako Hawkins", isSmallScreen),
                  buildRatingsAndLocation(),
                  Divider(color: MyColors.DarkLighter),

                  // Pricing Section
                  buildTextRow("Pricing:", "Rs. 20,000 - 150,000"),
                  buildTextRow("Basic Price:", "30,000"),
                  Divider(color: MyColors.DarkLighter),

                  // Description
                  buildSectionTitle("Description"),
                  buildDescription(),
                  Divider(color: MyColors.DarkLighter),

                  // Packages Section
                  buildSectionTitle("Packages"),
                  PackageBox(
                    packagename: "Standard Package",
                    packagedetails: "Details Here",
                    packageprice: "30,000",
                  ),
                  PackageBox(
                    packagename: "Premium Package",
                    packagedetails: "More Details",
                    packageprice: "50,000",
                  ),
                  Divider(color: MyColors.DarkLighter),

                  // Portfolio Section
                  buildSectionTitle("Portfolio"),
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://www.careergirls.org/wp-content/uploads/2018/05/Video_Editor1920x1080.jpg',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // Reviews Section
                  SizedBox(height: 20),
                  buildSectionTitle("Reviews"),
                  buildReviewsSection(),

                  // Book Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ColoredButton(text: 'Book Video Editor'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  Widget buildTitleRow(String title, bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.w600,
              color: MyColors.white,
            ),
          ),
          Icon(
            Icons.add,
            color: MyColors.Yellow,
            size: isSmallScreen ? 24 : 28,
          ),
        ],
      ),
    );
  }

  Widget buildRatingsAndLocation() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Icon(Icons.star, color: MyColors.Yellow, size: 20),
          SizedBox(width: 5),
          Text(
            "4.5 (30)",
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: MyColors.white,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "North Nazimabad Block M, Karachi",
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: MyColors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: MyColors.Yellow,
        ),
      ),
    );
  }

  Widget buildTextRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: MyColors.Yellow,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: MyColors.Yellow,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDescription() {
    return Text(
      "Hi! If you're searching for a Pro Video Editor for your car videos, I'm your guy. "
      "I will edit your car clips and make them viral trending videos for TikTok, YouTube, and Instagram. "
      "Just send me your footage, and I'll deliver high-quality video editing for you!",
      style: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: MyColors.white,
      ),
    );
  }

  Widget buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildStarRow("5 Stars", "21"),
        buildStarRow("4 Stars", "10"),
        buildStarRow("3 Stars", "8"),
        buildStarRow("2 Stars", "3"),
        buildStarRow("1 Star", "2"),
      ],
    );
  }

  Widget buildStarRow(String starText, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              starText,
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: MyColors.white,
              ),
            ),
          ),
          Expanded(
            child: Text(
              count,
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: MyColors.Yellow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
