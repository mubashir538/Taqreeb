import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Cart%20Item.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Header(
                heading: 'Cart Items',
              ),
              SizedBox(
                width: screenWidth * 0.9,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return CartItems(name: "Qasr e Noor", price: "500,000");
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: screenHeight * 0.04),
                  child: ColoredButton(text: 'Proceed'))
            ],
          ),
        ),
      ),
    );
  }
}
