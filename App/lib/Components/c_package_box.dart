import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/services/cart_service.dart'; // Import your CartService
import 'package:taqreeb/core/services/flutter_storage.dart'; // For getting token

class PackageBox extends StatefulWidget {
  final String packagename, packageprice, packagedetails;
  final String packageId; // Add package ID for cart operations
  final List<String> imageUrls;

  const PackageBox({
    super.key,
    required this.packagedetails,
    required this.packageprice,
    required this.packagename,
    required this.imageUrls,
    required this.packageId, // Add this required parameter
  });

  @override
  State<PackageBox> createState() => _PackageBoxState();
}

class _PackageBoxState extends State<PackageBox> {
  bool isCollapsed = true;
  int _currentImageIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  bool _isAddingToCart = false;

  Future<void> _addToCart() async {
    if (_isAddingToCart) return;

    setState(() {
      _isAddingToCart = true;
    });

    try {
      final token = await MyStorage.getToken(MyTokens.accessToken);
      if (token == null) {
        // Handle case when user is not logged in
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please login to add items to cart')),
          );
          Navigator.pushNamed(context, '/Login');
        }
        return;
      }

      await CartService.addToCart(
        token: token,
        itemType: 'package',
        itemId: widget.packageId,
        quantity: 1,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Package added to cart')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add to cart: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void changeCollapse() {
      setState(() {
        isCollapsed = !isCollapsed;
      });
    }

    return InkWell(
      onTap: () => changeCollapse(),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
        width: Screen.width(context) * 0.9,
        height: isCollapsed ? Screen.height(context) * 0.07 : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: MyColors.DarkLighter,
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 5)],
        ),
        child: Column(
          mainAxisAlignment:
              isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Container(
              margin:
                  EdgeInsets.symmetric(horizontal: Screen.max(context) * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.packagename,
                      style: GoogleFonts.montserrat(
                          fontSize: Screen.max(context) * 0.02,
                          fontWeight: FontWeight.w500,
                          color: MyColors.white)),
                  InkWell(
                    onTap: () => changeCollapse(),
                    child: Transform.rotate(
                      angle: 90 * 3.14 / 180,
                      child: Icon(
                        isCollapsed ? Icons.chevron_right : Icons.chevron_left,
                        color: MyColors.white,
                        size: Screen.max(context) * 0.05,
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (!isCollapsed) ...[
              SizedBox(height: Screen.max(context) * 0.02),
              // Image Carousel
              Container(
                height: Screen.height(context) * 0.2,
                margin: EdgeInsets.symmetric(
                    horizontal: Screen.max(context) * 0.02),
                child: Stack(
                  children: [
                    CarouselSlider(
                      carouselController: _carouselController,
                      options: CarouselOptions(
                        height: Screen.height(context) * 0.2,
                        viewportFraction: 1.0,
                        autoPlay: false,
                        enlargeCenterPage: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                      ),
                      items: widget.imageUrls.map((url) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(url),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    // Image indicator
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.imageUrls.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () =>
                                _carouselController.animateToPage(entry.key),
                            child: Container(
                              width: 8.0,
                              height: 8.0,
                              margin: EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentImageIndex == entry.key
                                    ? MyColors.Yellow
                                    : Colors.white.withOpacity(0.4),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Screen.max(context) * 0.02),
              // Package details
              Container(
                margin: EdgeInsets.all(Screen.max(context) * 0.02),
                child: Text(widget.packagedetails,
                    style: GoogleFonts.montserrat(
                        fontSize: Screen.max(context) * 0.015,
                        fontWeight: FontWeight.w300,
                        color: MyColors.white)),
              ),
              // Package price and Add to Cart button
              Container(
                margin: EdgeInsets.all(Screen.max(context) * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.packageprice,
                        style: GoogleFonts.montserrat(
                            fontSize: Screen.max(context) * 0.02,
                            fontWeight: FontWeight.w600,
                            color: MyColors.Yellow)),
                    SizedBox(
                      width: Screen.width(context) * 0.3,
                      child: ColoredButton(
                        text: _isAddingToCart ? 'Adding...' : 'Add to Cart',
                        onPressed: _isAddingToCart ? null : _addToCart,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
