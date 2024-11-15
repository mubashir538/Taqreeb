import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Checklist%20Items%20Adder.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';

class BusinessProfileInfo extends StatelessWidget {
  BusinessProfileInfo({super.key});
  List<String> items = ["Venue", "Catering", "Photography"];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    TextStyle style = GoogleFonts.montserrat(
      fontSize: MaximumThing * 0.018,
      fontWeight: FontWeight.w300,
      color: MyColors.white,
    );

    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Header(
            heading: "Account Info",
          ),
          SizedBox(
            height: screenHeight * 0.04,
          ),
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"),
          ),
          SizedBox(
            height: MaximumThing * 0.02,
          ),
          Text(
            "Qureshi Caterers",
            style: GoogleFonts.montserrat(
                color: MyColors.white,
                fontWeight: FontWeight.w500,
                fontSize: MaximumThing * 0.03),
          ),
          Text("Catering and Decorators", style: style),
          MyDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Text(
              "Qureshi Caterers is a renowned catering service offering a diverse range of delicious and high-quality culinary options for all types of events. From weddings and corporate functions to intimate gatherings, Qureshi Caterers delivers exceptional food crafted by expert chefs, ensuring every dish reflects a perfect blend of flavor and presentation. With a strong emphasis on fresh ingredients and attention to detail, the service is known for its ability to customize menus to suit various tastes and preferences. Whether you're hosting a large banquet or a small event, Qureshi Caterers guarantees an unforgettable dining experience.",
              style: style,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
              height: screenHeight * 0.04, child: Center(child: MyDivider())),
          Container(
            padding: EdgeInsets.all(MaximumThing * 0.03),
            child: Column(
              children: [
                Row(children: [
                  Icon(Icons.location_on_outlined),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    "Karachi, Pakistan",
                    style: style,
                  )
                ]),
                SizedBox(
                  height: screenHeight * 0.015,
                ),
                Row(children: [
                  Icon(Icons.mail, color: MyColors.white),
                  SizedBox(width: screenWidth * 0.02),
                  Text("qureshi@gmail.com", style: style)
                ]),
                SizedBox(
                  height: screenHeight * 0.015,
                ),
                Row(children: [
                  Icon(
                    Icons.phone,
                    color: MyColors.white,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text("+92 323 2730519", style: style)
                ]),
              ],
            ),
          ),
          SizedBox(
              height: screenHeight * 0.02, child: Center(child: MyDivider())),
          Container(
            margin: EdgeInsets.only(
                top: MaximumThing * 0.03, left: MaximumThing * 0.03),
            child: Row(
              children: [
                Text(
                  "Category",
                  style: GoogleFonts.montserrat(
                      color: MyColors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: MaximumThing * 0.02),
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.1,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ChecklistItemsAdder(text: items[index]);
              },
              scrollDirection: Axis.horizontal,
            ),
          ),
          SizedBox(
            height: screenHeight * 0.05,
          )
        ],
      )),
    );
  }
}
