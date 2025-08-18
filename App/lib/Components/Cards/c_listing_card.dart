import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart'; // Assuming Mycolors is here

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final String venueName;
  final String location;
  final String rating;
  final bool isBusiness;
  final String type;
  final double myWidth;
  final String listingid;
  final String listingType;
  final bool isWishlisted;

  const ProductCard({
    required this.imageUrl,
    required this.venueName,
    required this.location,
    required this.rating,
    required this.type,
    required this.listingid,
    required this.listingType,
    this.myWidth = 0,
    this.isBusiness = false,
    this.isWishlisted = false,
    super.key,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool _isWishlisted;

  @override
  void initState() {
    super.initState();
    _isWishlisted = widget.isWishlisted;
  }

  void _toggleWishlist() {
    setState(() {
      _isWishlisted = !_isWishlisted;
    });
    // Here you would typically call an API to update the wishlist status
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    return InkWell(
      onTap: _navigateToDetail,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.02),
        width:
            widget.myWidth == 0 ? Screen.width(context) * 0.7 : widget.myWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: colors.dark.withAlpha(51),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: colors.whiteDarker,
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: Screen.height(context) * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Wishlist button
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: _toggleWishlist,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: colors.dark.withAlpha(26),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isWishlisted
                              ? FontAwesomeIcons.heart
                              : Icons.favorite_border,
                          color:
                              _isWishlisted ? colors.red : colors.whiteDarker,
                          size: Screen.max(context) * 0.025,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Screen.width(context) * 0.04,
                vertical: Screen.height(context) * 0.015,
              ),
              decoration: BoxDecoration(
                color: colors.lightDark,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.venueName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: Screen.max(context) * 0.022,
                      fontWeight: FontWeight.w600,
                      color: colors.white,
                    ),
                  ),
                  SizedBox(height: Screen.height(context) * 0.005),
                  Text(
                    widget.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: Screen.max(context) * 0.016,
                      fontWeight: FontWeight.w400,
                      color: colors.white.withAlpha(204),
                    ),
                  ),
                  SizedBox(height: Screen.height(context) * 0.01),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.star,
                        color: colors.yellow,
                        size: Screen.max(context) * 0.02,
                      ),
                      SizedBox(width: Screen.width(context) * 0.01),
                      Text(
                        widget.rating,
                        style: GoogleFonts.poppins(
                          fontSize: Screen.max(context) * 0.018,
                          fontWeight: FontWeight.w500,
                          color: colors.white,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        widget.type.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: Screen.max(context) * 0.014,
                          fontWeight: FontWeight.w500,
                          color: colors.white.withAlpha(204),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail() {
    String path = '';
    final listingType = widget.listingType.toLowerCase().replaceAll(' ', '');

    switch (listingType) {
      case 'venue':
        path = '/CategoryView_Venue';
        break;
      case 'graphicdesigner':
        path = '/CategoryView_GraphicDesigner';
        break;
      case 'videoeditor':
        path = '/CategoryView_VideoEditor';
        break;
      case 'bakerandsweet':
        path = '/CategoryView_BakerySweet';
        break;
      case 'salon':
        path = '/CategoryView_Salon';
        break;
      case 'parlour':
        path = '/CategoryView_Parlour';
        break;
      case 'decorator':
        path = '/CategoryView_Decorator';
        break;
      case 'carrenter':
        path = '/CategoryView_CarRenter';
        break;
      case 'photographer':
        path = '/CategoryView_Photographer';
        break;
      case 'photographyplace':
        path = '/CategoryView_PhotographyPlace';
        break;
      case 'caterer':
        path = '/CategoryView_Caterers';
        break;
    }
    context.pushNamedTransition(
        routeName: path,
        type: PageTransitionType.bottomToTop,
        duration: Duration(milliseconds: 300),
        arguments: {
          'id': int.parse(widget.listingid),
          'isBusiness': widget.isBusiness,
        });
  }
}
