import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class ProductInfo extends StatefulWidget {
  final double rating;
  final int reviews;

  const ProductInfo({Key? key, required this.rating, required this.reviews})
      : super(key: key);
  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  String formatNumber(int number) {
    String numberString = number.toString();
    String reversedString = numberString.split('').reversed.join('');

    String formattedReversedString = '';
    for (int i = 0; i < reversedString.length; i++) {
      if (i != 0 && i % 3 == 0) {
        formattedReversedString += ',';
      }
      formattedReversedString += reversedString[i];
    }

    String formattedString =
        formattedReversedString.split('').reversed.join('');

    return formattedString;
  }

  void main() {
    int number = 1000000;
    String formattedNumber = formatNumber(number);
    print(formattedNumber);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double max = screenWidth > screenHeight ? screenWidth : screenHeight;
    return Container(
      padding:
          EdgeInsets.only(top: max * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: max * 0.015),
                child: Text("${widget.rating}",
                    style: GoogleFonts.montserrat(
                        color: MyColors.white,
                        fontSize: max * 0.03,
                        fontWeight: FontWeight.w700)),
              ),
              for (int i = 0; i < int.parse(widget.rating.toString()[0]); i++)
                Icon(Icons.star_rounded,
                    color: MyColors.red, size: max * 0.025),
              if (widget.rating.toString().length != 1)
                Icon(Icons.star_half_rounded,
                    color: MyColors.red, size: max * 0.025),
              for (int i = 0;
                  i < (5 - int.parse(widget.rating.toString()[0]));
                  i++)
                Icon(Icons.star_border_rounded,
                    color: MyColors.red, size: max * 0.025),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: max * 0.015),
                child: Text("(${formatNumber(widget.reviews)} reviews)",
                    style: GoogleFonts.montserrat(
                        color: MyColors.whiteDarker,
                        fontSize: max * 0.015,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
