import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class Headersecondary extends StatefulWidget {
  const Headersecondary({
    super.key,
    this.heading = '',
    this.para = '',
    this.image = '',
  });
  final String heading;
  final String para;
  final String image;
  @override
  State<Headersecondary> createState() => _HeadersecondaryState();
}

class _HeadersecondaryState extends State<Headersecondary> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool hasSomething = widget.heading.isNotEmpty ||
        widget.para.isNotEmpty ||
        widget.image.isNotEmpty;
    bool isSvg = false;
    if (widget.image.isNotEmpty) {
      isSvg = widget.image.substring(widget.image.length - 3) == 'svg'
          ? true
          : false;
    }
    double MaximumThing;
    if (screenWidth > screenHeight) {
      MaximumThing = screenWidth;
    } else {
      MaximumThing = screenHeight;
    }

    return Container(
      height: hasSomething ? null : screenHeight * 0.1,
      width: screenWidth,
      decoration: BoxDecoration(
        color: MyColors.red,
        borderRadius: hasSomething
            ? BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))
            : BorderRadius.circular(0),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.1),
          widget.heading.isNotEmpty
              ? Column(children: [
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    widget.heading,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        fontSize: MaximumThing * 0.025,
                        fontWeight: FontWeight.w700,
                        color: MyColors.Yellow),
                  ),
                  SizedBox(
                      height: widget.para.isNotEmpty || widget.image.isNotEmpty
                          ? screenHeight * 0.01
                          : screenHeight * 0.03),
                ])
              : Container(),
          widget.para.isNotEmpty
              ? Column(children: [
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    widget.para,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        fontSize: MaximumThing * 0.013,
                        fontWeight: FontWeight.w400,
                        color: MyColors.white),
                  ),
                  SizedBox(
                      height: widget.image.isNotEmpty
                          ? screenHeight * 0.01
                          : screenHeight * 0.03),
                ])
              : Container(),
          widget.image.isNotEmpty
              ? Column(
                  children: [
                    SizedBox(height: screenHeight * 0.01),
                    SizedBox(height: screenHeight * 0.03),
                    isSvg
                        ? SvgPicture.asset(widget.image,
                            height: screenHeight * 0.2)
                        : Image.asset(widget.image, height: screenHeight * 0.2),
                    SizedBox(height: screenHeight * 0.03),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
