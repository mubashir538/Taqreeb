import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class MessageChatButton extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final Function onpressed;
  final String image;
  final int newMessage;
  final double mywidth;

  const MessageChatButton({
    this.newMessage = 0,
    this.image = '',
    this.mywidth = 0,
    required this.name,
    required this.onpressed,
    required this.message,
    required this.time,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return InkWell(
      onTap: () => onpressed(),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.01),
        padding: EdgeInsets.symmetric(
            horizontal: MaximumThing * 0.02, vertical: MaximumThing * 0.02),
        width: mywidth == 0 ? screenWidth * 0.9 : mywidth,
        decoration: BoxDecoration(
          color: MyColors.DarkLighter,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: MaximumThing * 0.03),
              child: CircleAvatar(
                radius: MaximumThing * 0.03,
                backgroundColor: MyColors.red,
                child: image.isNotEmpty
                    ? Image.network(
                        image,
                        width: MaximumThing * 0.03,
                        height: MaximumThing * 0.03,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.person,
                        size: MaximumThing * 0.03,
                        color: Colors.white,
                      ),
              ),
            ),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: MaximumThing * 0.007),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.montserrat(
                            fontSize: MaximumThing * 0.02,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        newMessage > 0
                            ? Text(
                                time,
                                style: GoogleFonts.montserrat(
                                  fontSize: MaximumThing * 0.015,
                                  fontWeight: FontWeight.w300,
                                  color: MyColors.whiteDarker,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        message,
                        style: GoogleFonts.montserrat(
                          fontSize: MaximumThing * 0.015,
                          fontWeight: FontWeight.w400,
                          color: MyColors.whiteDarker,
                        ),
                      ),
                      newMessage > 0
                          ? Container(
                              decoration: BoxDecoration(
                                color: MyColors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: MaximumThing * 0.03,
                              height: MaximumThing * 0.03,
                              child: Center(
                                child: Text(
                                  "5",
                                  style: GoogleFonts.montserrat(
                                    fontSize: MaximumThing * 0.015,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.white,
                                  ),
                                ),
                              ),
                            )
                          : Container()
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
}
