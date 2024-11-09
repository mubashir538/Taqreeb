import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';

class Decorators extends StatelessWidget {
  const Decorators({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Header(),
              Image.network(
                "https://tse4.mm.bing.net/th?id=OIP.oVavDFpwxBLLYaybiekhtgHaD4&pid=Api&P=0&h=220",
                fit: BoxFit.cover,
                width: double.infinity,
              ),

              //darklighter container
              Container(
                height: 700,
                width: 428,
                decoration: BoxDecoration(
                    color: MyColors.DarkLighter,
                    borderRadius: BorderRadius.circular(19)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 10,
                    ),
                    Text(
                      "Events by Harbor",
                      style: GoogleFonts.montserrat(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.add),
                      ],
                    ),

                    //texting
                    Icon(
                      Icons.star,
                      color: MyColors.Yellow,
                    ),
                    Text(
                      "4.5(30)",
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                        color: MyColors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    //divider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyDivider(width: screenWidth * 0.6),
                        const SizedBox(height: 10),
                      ],
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pricing",
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w200,
                            color: MyColors.white,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rs. 99,000 - 100000",
                              style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w200,
                                  color: MyColors.white),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
