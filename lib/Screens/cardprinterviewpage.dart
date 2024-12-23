import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/Border Button.dart';

class Cardprinterviewpage extends StatelessWidget {
  const Cardprinterviewpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: Text(
                "Wedding Invitations",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MyColors.Yellow,
                ),
              ),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.02),
                child: ClipRRect(
                  child: Image.network(
                    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/wedding-invitation-template-free-download-design-6aa5ded3ee3006ce7b66e61d9bd09686_screen.jpg?ts=1649939251',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("Card Description:"),
                  sectionText(
                    "A beautifully designed wedding invitation featuring a soft blue floral theme and a modern illustration of the bride and groom. Perfect for formal events like Walima, it blends elegance with tradition, presenting all details clearly and stylishly.",
                  ),
                  const SizedBox(height: 16),
                  Divider(color: MyColors.white.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  sectionTitle("Card Details:"),
                  buildBulletPointDetails([
                    "Size: 5x7 inches",
                    "Paper Type: Premium matte finish",
                    "Design: Soft blue floral theme with bride and groom illustration",
                    "Ideal for: Traditional and formal wedding ceremonies",
                    "Customization: Text and design options available on request",
                  ]),
                  const SizedBox(height: 16),
                  Divider(color: MyColors.white.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  sectionTitle("Pricing:"),
                  buildBulletPointDetails([
                    "Base Price: Rs. 50 per card",
                    "Bulk Discounts: 10% off for orders of 100 or more",
                    "Customization Fees: Additional Rs. 15 per design change",
                    "Delivery Charges: Rs. 500 within city limits",
                  ]),
                  const SizedBox(height: 16),
                  Divider(color: MyColors.white.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  sectionTitle("Vendor Info:"),
                  buildBulletPointDetails([
                    "Vendor Name: Elegant Invites Co.",
                    "Specialization: Elegant, customized wedding invitations",
                    "Experience: Known for blending modern and traditional designs",
                    "Contact: 0344-1234567 | elegantinvites@example.com",
                  ]),
                  const SizedBox(height: 16),
                  Center(
                    child: BorderButton(
                      text: "Purchase Card",
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: MyColors.Yellow,
      ),
    );
  }

  Widget sectionText(String text) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: MyColors.white,
      ),
    );
  }

  Widget buildBulletPointDetails(List<String> details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: details.map((detail) {
        final splitDetail = detail.split(":");
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "• ",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: MyColors.white,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${splitDetail[0]}: ",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: MyColors.white,
                      ),
                    ),
                    TextSpan(
                      text: splitDetail.sublist(1).join(":").trim(),
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: MyColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
