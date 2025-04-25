import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

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
    return Container(
      height: Screen.height(context) * 0.2,
      width: Screen.width(context) * 0.9,
      margin: EdgeInsets.symmetric(
          vertical: Screen.max(context) * 0.02,
          horizontal: Screen.max(context) * 0.01),
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
            padding: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
            child: Text(
              widget.name,
              style: GoogleFonts.montserrat(
                fontSize: Screen.max(context) * 0.02,
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
                    child: CachedNetworkImage(
                      imageUrl: "https://shorturl.at/9nzlw",
                      height: Screen.max(context) * 0.05,
                      width: Screen.max(context) * 0.05,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: GoogleFonts.montserrat(
                          fontSize: Screen.max(context) * 0.02,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Rs, ${widget.price}",
                        style: GoogleFonts.montserrat(
                          fontSize: Screen.max(context) * 0.015,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: Screen.height(context) * 0.04,
                    width: Screen.width(context) * 0.25,
                    decoration: BoxDecoration(
                        color: MyColors.dark,
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
                              color: Colors.white,
                              size: Screen.max(context) * 0.015),
                        ),
                        Text(
                          widget.quantity.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Screen.max(context) * 0.015),
                        ),
                        InkWell(
                            onTap: () => setState(() {
                                  widget.quantity++;
                                }),
                            child: Icon(Icons.add,
                                color: Colors.white,
                                size: Screen.max(context) * 0.015)),
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
