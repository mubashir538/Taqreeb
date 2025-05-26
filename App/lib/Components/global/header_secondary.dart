import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

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
    bool hasSomething = widget.heading.isNotEmpty ||
        widget.para.isNotEmpty ||
        widget.image.isNotEmpty;
    bool isSvg = false;
    if (widget.image.isNotEmpty) {
      isSvg = widget.image.substring(widget.image.length - 3) == 'svg'
          ? true
          : false;
    }
    final colors = AppColors(context);

    return Container(
      height: hasSomething ? null : Screen.height(context) * 0.1,
      width: Screen.width(context),
      decoration: BoxDecoration(
        color: colors.red,
        borderRadius: hasSomething
            ? BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))
            : BorderRadius.circular(0),
      ),
      child: Column(
        children: [
          SizedBox(height: Screen.height(context) * 0.1),
          widget.heading.isNotEmpty
              ? Column(children: [
                  SizedBox(height: Screen.height(context) * 0.02),
                  Text(
                    widget.heading,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: Screen.max(context) * 0.025,
                        fontWeight: FontWeight.w700,
                        color: colors.yellow),
                  ),
                  SizedBox(
                      height: widget.para.isNotEmpty || widget.image.isNotEmpty
                          ? Screen.height(context) * 0.01
                          : Screen.height(context) * 0.03),
                ])
              : Container(),
          widget.para.isNotEmpty
              ? Column(children: [
                  Padding(
                    padding: EdgeInsets.all(Screen.max(context) * 0.01),
                    child: Text(
                      widget.para,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          fontSize: Screen.max(context) * 0.015,
                          fontWeight: FontWeight.w400,
                          color: colors.white),
                    ),
                  ),
                  SizedBox(
                      height: widget.image.isNotEmpty
                          ? Screen.height(context) * 0.01
                          : Screen.height(context) * 0.03),
                ])
              : Container(),
          widget.image.isNotEmpty
              ? Column(
                  children: [
                    SizedBox(height: Screen.height(context) * 0.01),
                    SizedBox(
                      width: Screen.width(context) * 0.9, // your fixed width
                      height:
                          Screen.height(context) * 0.15, // your fixed height
                      child: isSvg
                          ? SvgPicture.asset(
                              widget.image,
                              fit: BoxFit
                                  .contain, // scales the SVG to fit within the box
                            )
                          : Image.asset(
                              widget.image,
                              fit: BoxFit
                                  .contain, // scales the raster image to fit within the box
                            ),
                    ),
                    SizedBox(height: Screen.height(context) * 0.03),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
