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
  bool isCollapsed = true;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    void ChangeCollapse() {
      setState(() {
        isCollapsed = !isCollapsed;
      });
    }

    return InkWell(
      onTap: () => ChangeCollapse(),
      child: Container(
          margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.01),
          width: screenWidth * 0.9,
          height: isCollapsed ? screenHeight * 0.07 : null,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: MyColors.DarkLighter,
              boxShadow: [BoxShadow(color: Colors.black, blurRadius: 5)]),
          child: Column(
              mainAxisAlignment: isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: MaximumThing * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.packagename,
                          style: GoogleFonts.montserrat(
                              fontSize: MaximumThing * 0.02,
                              fontWeight: FontWeight.w500,
                              color: MyColors.white)),
                      InkWell(
                        onTap: () => ChangeCollapse(),
                        child: Transform.rotate(
                          angle: 90 * 3.14 / 180,
                          child: Icon(
                            isCollapsed
                                ? Icons.chevron_right
                                : Icons.chevron_left,
                            color: MyColors.white,
                            size: MaximumThing * 0.05,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                isCollapsed
                    ? Container()
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.all(MaximumThing * 0.02),
                            child: Text(widget.packagedetails,
                                style: GoogleFonts.montserrat(
                                    fontSize: MaximumThing * 0.015,
                                    fontWeight: FontWeight.w300,
                                    color: MyColors.white)),
                          ),
                          Container(
                            margin: EdgeInsets.all(MaximumThing * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(widget.packageprice,
                                    style: GoogleFonts.montserrat(
                                        fontSize: MaximumThing * 0.02,
                                        fontWeight: FontWeight.w600,
                                        color: MyColors.Yellow)),
                              ],
                            ),
                          )
                        ],
                      )
              ])),
    );
  }
}
