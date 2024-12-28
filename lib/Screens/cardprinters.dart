import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/slidingrow.dart';

class cardprinter extends StatefulWidget {
  const cardprinter({super.key});

  @override
  State<cardprinter> createState() => _cardprinterState();
}

class _cardprinterState extends State<cardprinter> {
  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
  }

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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(heading: "Taqreeb", para: ""),

            // Main Heading
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Text(
                "Card Printers",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MyColors.Yellow,
                ),
              ),
            ),

            // Featured Images
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildFeaturedImage(
                      'https://i2.wp.com/cdn.geckoandfly.com/wp-content/uploads/2019/12/wedding-invitation-template-21.jpg',
                      screenWidth * 0.3),
                  buildFeaturedImage(
                      'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/modern-wedding-invitation-card-2024-design-template-8968c363de9edc3c5ba5ededf79cdba0_screen.jpg?ts=1705863640',
                      screenWidth * 0.3),
                  buildFeaturedImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3iv-B50L35g90tsd-EU6_hVy6tzzsANQZqsrGtysexhEJ08k9VmGHYOnn1N2PfGEZkdE&usqp=CAU',
                      screenWidth * 0.3),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Sliding Rows
            SlidingRow(
              title: "Wedding Invitations",
              images: [
                'https://image.wedmegood.com/e-invite-images/1eccdb95-4528-4176-a276-9e845179daff-NAIN-PANDEY--Card-8_%281%29.JPEG',
                'https://marketplace.canva.com/EAF59To9EnM/1/0/1135w/canva-green-%26-gold-watercolor-wedding-party-virtual-invitation-%28portrait%29-IBw-744iAHM.jpg',
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqJB3Qhjguh_zbYkCipCfVUfWOJh9yllj6Zg&s',
                'https://marketplace.canva.com/EAGGNZcgEvo/1/0/1135w/canva-green-simple-wedding-invitation-card-s0mY81hn8AE.jpg',
              ],
            ),
            SlidingRow(
              title: "Birthday Invitations",
              images: [
                'https://marketplace.canva.com/EAF_1-xa7mA/1/0/1135w/canva-pink-and-white-watercolor-birthday-party-invitation-vGbKGZCCJUo.jpg',
                'https://d3jmn01ri1fzgl.cloudfront.net/photoadking/webp_thumbnail/prim-and-vivid-violet-boy-birthday-invitation-template-ttcq34f307b44c.webp',
                'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/fairy-birthday-invitation-design-template-f8777a843daae2d93f086e4d7162e33b_screen.jpg?ts=1698714026',
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQDIctLMO6JAtvp4vmE9McO282BeesaROyLrA&s'
              ],
            ),
            SlidingRow(
              title: "Corporate Invitations",
              images: [
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ5fMA8t12r8AFBQ9LjeGIl6rTtgNHVc_NTKw&s',
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgFZNyHz-lllhfZCb_bbnkICPDIinMcBInkg&s',
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkrU4ReWVtwx3c2DDwiYf0Et2GTR0394fCiw&s',
                'https://cdn.venngage.com/template/thumbnail/310/5a5b0c5c-f09f-43b3-b65f-b9ff742b603c.webp',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFeaturedImage(String imageUrl, double width) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        width: width,
        height: width * 1.3,
        fit: BoxFit.cover,
      ),
    );
  }
}
