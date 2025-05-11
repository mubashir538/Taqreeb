import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/utils/color.dart';

class PackageBox extends StatelessWidget {
  final String packageName;
  final String packageDetails;
  final String packagePrice;
  final String imageUrl;
  final String packageId;
  final VoidCallback onPressed;

  const PackageBox({
    super.key,
    required this.packageName,
    required this.packageDetails,
    required this.packagePrice,
    required this.imageUrl,
    required this.packageId,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: Screen.width(context) * 0.9,
        margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
        decoration: BoxDecoration(
          color: MyColors.ligthDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: MyColors.whiteDarker, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image on the left
            Container(
              width: Screen.width(context) * 0.35,
              height: Screen.width(context) * 0.4,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Content on the right
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(Screen.max(context) * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Package Name
                    Text(
                      packageName,
                      style: GoogleFonts.roboto(
                        fontSize: Screen.max(context) * 0.02,
                        fontWeight: FontWeight.w600,
                        color: MyColors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Screen.max(context) * 0.01),

                    // Package Details
                    Text(
                      packageDetails,
                      style: GoogleFonts.roboto(
                        fontSize: Screen.max(context) * 0.015,
                        fontWeight: FontWeight.w400,
                        color: MyColors.whiteDarker,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Screen.max(context) * 0.02),

                    // Price only (no Add to Cart button)
                    Text(
                      packagePrice,
                      style: GoogleFonts.roboto(
                        fontSize: Screen.max(context) * 0.02,
                        fontWeight: FontWeight.w600,
                        color: MyColors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
