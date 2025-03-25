import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class Guests extends StatelessWidget {
  final String name;
  final String contact;
  final VoidCallback? onpressed;
  final VoidCallback? ondelete;
  final String image;
  final double mywidth;

  const Guests({
    this.image = '',
    this.mywidth = 0,
    required this.ondelete,
    required this.name,
    required this.onpressed,
    required this.contact,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onpressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
        padding: EdgeInsets.symmetric(
            horizontal: Screen.max(context) * 0.02,
            vertical: Screen.max(context) * 0.02),
        width: mywidth == 0 ? Screen.width(context) * 0.9 : mywidth,
        decoration: BoxDecoration(
          color: MyColors.DarkLighter,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: Screen.max(context) * 0.03),
              child: CircleAvatar(
                radius: Screen.max(context) * 0.03,
                backgroundColor: MyColors.red,
                child: image.isNotEmpty
                    ? Image.network(
                        image,
                        width: Screen.max(context) * 0.03,
                        height: Screen.max(context) * 0.03,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.person,
                        size: Screen.max(context) * 0.03,
                        color: Colors.white,
                      ),
              ),
            ),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Screen.max(context) * 0.007),
                    child: SizedBox(
                      width: mywidth == 0
                          ? Screen.width(context) * 0.6
                          : mywidth - Screen.max(context) * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.montserrat(
                              fontSize: Screen.max(context) * 0.02,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: ondelete,
                            child: Icon(
                              Icons.delete,
                              color: MyColors.white,
                              size: Screen.max(context) * 0.03,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    contact,
                    style: GoogleFonts.montserrat(
                      fontSize: Screen.max(context) * 0.015,
                      fontWeight: FontWeight.w400,
                      color: MyColors.whiteDarker,
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
}
