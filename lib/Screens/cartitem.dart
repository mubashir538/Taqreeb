import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:taqreeb/Components/Cart%20Item.dart';
// import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';

// import 'package:taqreeb/Components/text_box.dart';
// import 'package:taqreeb/theme/color.dart';
// import 'package:taqreeb/theme/icons.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
              heading: 'Cart Items',
            ),
            SizedBox(height: 20,),
            CartItems(),
            SizedBox(height: 20,),
            CartItems(),
            SizedBox(height: 20,),
            CartItems(),
            SizedBox(height: 20,),
            CartItems(),
            SizedBox(height: 20,),
            CartItems(),
            

          ],
        ),
      ),
    );
  }
}