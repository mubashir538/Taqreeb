import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/package%20box.dart';
import 'package:taqreeb/theme/color.dart';

class CategoryView_Venue extends StatelessWidget {
  const CategoryView_Venue({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.03), // Adjust padding dynamically
              child: SizedBox(
                width: double.infinity,
                height: screenHeight * 0.3, // Adjust image height dynamically
                child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5DJA0WgEFo7X9kXf00EtVnpGPD3mAvh1e8A&s',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: screenWidth,
              color: MyColors.Dark,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02, // Reduced horizontal padding
                vertical: 10, // Reduced vertical padding
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02), // Adjust top padding dynamically
                    child: _buildTitleRow(screenWidth),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02), // Adjust padding dynamically
                    child: _buildLocationRow(),
                  ),
                  _buildDivider(),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02), // Adjust padding dynamically
                    child: _buildPricingSection(),
                  ),
                  _buildDivider(),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02), // Adjust padding dynamically
                    child: _buildDescriptionSection(),
                  ),
                  _buildDivider(),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02), // Adjust padding dynamically
                    child: _buildDetailsSection(),
                  ),
                  _buildDivider(),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02), // Adjust padding dynamically
                    child: _buildAddOnsSection(),
                  ),
                  _buildDivider(),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02), // Adjust padding dynamically
                    child: _buildPackagesSection(),
                  ),
                  _buildDivider(),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02), // Adjust padding dynamically
                    child: _buildReviewsSection(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.03), // Adjust bottom padding dynamically
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

  // Section Widgets:
  Widget _buildTitleRow(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            "Qasr - e - Noor Banquet",
            style: GoogleFonts.montserrat(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: MyColors.white,
            ),
          ),
        ),
        Icon(
          Icons.add,
          color: MyColors.Yellow,
          size: 28,
        ),
      ],
    );
  }

  Widget _buildLocationRow() {
    return Row(
      children: [
        Icon(Icons.star, color: MyColors.Yellow),
        SizedBox(width: 5),
        Text(
          "4.5 (30)",
          style: GoogleFonts.montserrat(fontSize: 15, color: MyColors.white),
        ),
        SizedBox(width: 10),
        Flexible(
          child: Text(
            "North Nazimabad Block M, Karachi",
            style: GoogleFonts.montserrat(fontSize: 15, color: MyColors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(color: MyColors.DarkLighter, thickness: 1);
  }

  Widget _buildPricingSection() {
    return Column(
      children: [
        _buildInfoRow("Pricing:", "Rs. 200,000 - 700,000", fontSize: 21),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: _buildInfoRow("Basic Price:", "200,000"),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: MyColors.Yellow,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20), // Adjusted space here
          child: Text(
            "Qasr-e-Noor is a premier marriage hall located in the heart of Karachi, offering an elegant and spacious venue for weddings, receptions, and other special events. The hall is designed to accommodate both large and intimate gatherings, with luxurious interiors, state-of-the-art facilities, and exceptional services to make your event unforgettable.",
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: MyColors.white,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      children: [
        _buildInfoRow("Venue Type", "Banquet"),
        _buildInfoRow("Catering", "Internal & External"),
        _buildInfoRow("Guests", "200 - 500 Persons"),
        _buildInfoRow("Staff", "Male"),
      ],
    );
  }

  Widget _buildAddOnsSection() {
    return Column(
      children: [
        _buildInfoRow("Decorations", "Rs. 30,000"),
        _buildInfoRow("Female Staff", "Rs. 10,000"),
        _buildInfoRow("Extra Staff", "Rs. 100/Person"),
      ],
    );
  }

  Widget _buildPackagesSection() {
    return Column(
      children: [
        Text(
          "Packages",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: MyColors.Yellow,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: PackageBox(packagename: 'Standard Package', packageprice: '', packagedetails: ''),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: PackageBox(packagename: 'Premium Package', packageprice: '', packagedetails: ''),
        ),
      ],
    );
  }

Widget _buildReviewsSection() {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Reviews",
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: MyColors.Yellow,
            ),
          ),
          Icon(Icons.arrow_right, color: MyColors.white),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            Icon(Icons.star, color: MyColors.Yellow),
            SizedBox(width: 5),
            Text(
              "4.5 (30)",
              style: GoogleFonts.montserrat(fontSize: 15, color: MyColors.white),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        child: Column(
          children: [
            // First line: 5, 4, 3 stars
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildInfoRow("5 Stars", "21", fontSize: 14),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: _buildInfoRow("4 Stars", "10", fontSize: 14),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: _buildInfoRow("3 Stars", "8", fontSize: 14),
                ),
              ],
            ),
           
            Padding(
              padding: const EdgeInsets.only(top: 0.3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildInfoRow("2 Stars", "3", fontSize: 14),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: _buildInfoRow("1 Star", "2", fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}


  Widget _buildInfoRow(String title, String value, {double fontSize = 16}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              color: MyColors.Yellow,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              color: MyColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
