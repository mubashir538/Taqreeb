import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class PackageBox extends StatefulWidget {
  final String packagename, packageprice, packagedetails;
  const PackageBox(
      {super.key,
      required this.packagedetails,
      required this.packageprice,
      required this.packagename});
  @override
  State<PackageBox> createState() => _PackageBoxState();
}

class _PackageBoxState extends State<PackageBox> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    bool isCollapsed = true;
    void ChangeCollapse() {
      setState(() {
        isCollapsed = !isCollapsed;
      });
    }

    // bool isCollapsed = false;
    return Container(
        width: screenWidth * 0.9,
        height: isCollapsed ? screenHeight * 0.1 : null,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: MyColors.DarkLighter,
            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 5)]),
        child: Column(children: [
          Row(
            children: [
              Text(widget.packagename,
                  style: GoogleFonts.montserrat(
                      fontSize: MaximumThing * 0.025,
                      fontWeight: FontWeight.w500,
                      color: MyColors.white)),
              InkWell(
                onTap: () => ChangeCollapse(),
                child: Transform.rotate(
                  angle: 90 * 3.14 / 180,
                  child: Icon(
                    isCollapsed ? Icons.chevron_left : Icons.chevron_right,
                    color: MyColors.white,
                  ),
                ),
              )
            ],
          ),
          Text(widget.packagedetails,
              style: GoogleFonts.montserrat(
                  fontSize: MaximumThing * 0.02,
                  fontWeight: FontWeight.w300,
                  color: MyColors.white)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(widget.packageprice,
                  style: GoogleFonts.montserrat(
                      fontSize: MaximumThing * 0.03,
                      fontWeight: FontWeight.w600,
                      color: MyColors.Yellow)),
            ],
          )
        ]));
  }
}
