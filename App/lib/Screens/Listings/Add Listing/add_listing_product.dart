import 'dart:io';

import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/utils/color.dart';

class ProductBox extends StatelessWidget {
  final String productName;
  final String productDescription;
  final String productPrice;
  final String? productImage;

  const ProductBox({
    super.key,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    this.productImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Screen.max(context) * 0.03,
        vertical: Screen.max(context) * 0.01,
      ),
      padding: EdgeInsets.all(Screen.max(context) * 0.02),
      decoration: BoxDecoration(
        color: MyColors.DarkLighter,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (productImage != null)
            Container(
              width: Screen.max(context) * 0.15,
              height: Screen.max(context) * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: FileImage(File(productImage!)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          SizedBox(width: Screen.max(context) * 0.02),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Screen.max(context) * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Screen.max(context) * 0.01),
                Text(
                  productDescription,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: Screen.max(context) * 0.018,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Screen.max(context) * 0.01),
                Text(
                  productPrice,
                  style: TextStyle(
                    color: MyColors.Yellow,
                    fontSize: Screen.max(context) * 0.022,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
