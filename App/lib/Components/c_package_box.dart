import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

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
              boxShadow: [BoxShadow(color: Colors.black, blurRadius: 5)]),
          child: Column(
              mainAxisAlignment: isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: Screen.max(context) * 0.02),
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
                            isCollapsed
                                ? Icons.chevron_right
                                : Icons.chevron_left,
                            color: MyColors.white,
                            size: Screen.max(context) * 0.05,
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
                            margin: EdgeInsets.all(Screen.max(context) * 0.02),
                            child: Text(widget.packagedetails,
                                style: GoogleFonts.montserrat(
                                    fontSize: Screen.max(context) * 0.015,
                                    fontWeight: FontWeight.w300,
                                    color: MyColors.white)),
                          ),
                          Container(
                            margin: EdgeInsets.all(Screen.max(context) * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(widget.packageprice,
                                    style: GoogleFonts.montserrat(
                                        fontSize: Screen.max(context) * 0.02,
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
