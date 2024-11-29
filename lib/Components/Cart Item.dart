import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

// ignore: must_be_immutable
class CartItems extends StatefulWidget {
  CartItems(
      {super.key, required this.name, required this.price, this.quantity = 1});
  final String name;
  final String price;
  int quantity;

  @override
  State<CartItems> createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Container(
      height: screenHeight * 0.2,
      width: screenWidth * 0.9,
      margin: EdgeInsets.symmetric(
          vertical: MaximumThing * 0.02, horizontal: MaximumThing * 0.01),
      decoration: BoxDecoration(
          color: MyColors.DarkLighter,
          border: Border.all(
            color: MyColors.white,
          ),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: MaximumThing * 0.01),
            child: Text(
              widget.name,
              style: GoogleFonts.montserrat(
                fontSize: MaximumThing * 0.02,
                color: MyColors.Yellow,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Divider(),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      "https://shorturl.at/9nzlw",
                      height: MaximumThing * 0.05,
                      width: MaximumThing * 0.05,
                      ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: GoogleFonts.montserrat(
                          fontSize: MaximumThing * 0.02,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Rs, ${widget.price}",
                        style: GoogleFonts.montserrat(
                          fontSize: MaximumThing * 0.015,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: screenHeight * 0.04,
                    width: screenWidth * 0.25,
                    decoration: BoxDecoration(
                        color: MyColors.Dark,
                        border: Border.all(
                          color: MyColors.white,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () => setState(() {
                            widget.quantity == 1 ? null : widget.quantity--;
                          }),
                          child: Icon(Icons.remove,
                              color: Colors.white, size: MaximumThing * 0.015),
                        ),
                        Text(
                          widget.quantity.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: MaximumThing * 0.015),
                        ),
                        InkWell(
                            onTap: () => setState(() {
                                  widget.quantity++;
                                }),
                            child: Icon(Icons.add,
                                color: Colors.white,
                                size: MaximumThing * 0.015)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
