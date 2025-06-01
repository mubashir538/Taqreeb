import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/cart_service.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';

class PackageDetailsPopup extends StatefulWidget {
  final String packageId;
  final String packageName;
  final String packageDetails;
  final String packagePrice;
  final List<String> imageUrls;
  final VoidCallback onClose;
  final VoidCallback? onAddToCart;

  const PackageDetailsPopup({
    super.key,
    required this.packageId,
    required this.packageName,
    required this.packageDetails,
    required this.packagePrice,
    required this.imageUrls,
    required this.onClose,
    this.onAddToCart,
  });

  @override
  State<PackageDetailsPopup> createState() => _PackageDetailsPopupState();
}

class _PackageDetailsPopupState extends State<PackageDetailsPopup> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handleAddToCart() async {
    if (_isAddingToCart) return;

    setState(() {
      _isAddingToCart = true;
    });

    try {
      final token = await MyStorage.getToken(MyTokens.accessToken);
      await CartService.addToCart(
        token: token!,
        itemType: 'package',
        itemId: widget.packageId,
      );

      if (widget.onAddToCart != null) {
        widget.onAddToCart!();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Package added to cart')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to cart: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isAddingToCart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: colors.dark,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.packageName,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: colors.white),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Screen.height(context) * 0.3,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: widget.imageUrls.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(widget.imageUrls[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                  if (widget.imageUrls.length > 1)
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.imageUrls.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index
                                  ? colors.white
                                  : colors.white.withAlpha(128),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Details',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.packageDetails,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: colors.whiteDarker,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.packagePrice,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.yellow,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.red,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isAddingToCart ? null : _handleAddToCart,
                child: _isAddingToCart
                    ? CircularProgressIndicator(color: colors.white)
                    : Text(
                        'Add to Cart',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PackageBox extends StatelessWidget {
  final String packageName;
  final String packageDetails;
  final String packagePrice;
  final String imageUrl;
  final String packageId;
  final VoidCallback onPressed;
  final bool showPopupOnTap;
  final List<String>? popupImages;

  const PackageBox({
    super.key,
    required this.packageName,
    required this.packageDetails,
    required this.packagePrice,
    required this.imageUrl,
    this.packageId = "0",
    required this.onPressed,
    this.showPopupOnTap = true,
    this.popupImages,
  });

  void _showPackageDetails(BuildContext context) {
    if (!showPopupOnTap) {
      onPressed();
      return;
    }

    showDialog(
      context: context,
      builder: (context) => PackageDetailsPopup(
        packageId: packageId,
        packageName: packageName,
        packageDetails: packageDetails,
        packagePrice: packagePrice,
        imageUrls: popupImages ?? [imageUrl],
        onClose: () => Navigator.of(context).pop(),
        onAddToCart: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    return InkWell(
      onTap: () => _showPackageDetails(context),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: Screen.width(context) * 0.9,
        height: Screen.height(context) * 0.2,
        margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
        decoration: BoxDecoration(
          color: colors.lightDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.whiteDarker, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: Screen.width(context) * 0.35,
              height: Screen.width(context) * 0.4,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: Screen.height(context) * 0.2,
                child: Padding(
                  padding: EdgeInsets.all(Screen.max(context) * 0.02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        packageName,
                        style: GoogleFonts.roboto(
                          fontSize: Screen.max(context) * 0.02,
                          fontWeight: FontWeight.w600,
                          color: colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: Screen.max(context) * 0.01),
                      Text(
                        packageDetails,
                        style: GoogleFonts.roboto(
                          fontSize: Screen.max(context) * 0.015,
                          fontWeight: FontWeight.w400,
                          color: colors.whiteDarker,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: Screen.max(context) * 0.02),
                      Text(
                        packagePrice,
                        style: GoogleFonts.roboto(
                          fontSize: Screen.max(context) * 0.02,
                          fontWeight: FontWeight.w600,
                          color: colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
