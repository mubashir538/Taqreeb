import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Cake%20Box.dart';
import 'package:taqreeb/Components/header.dart';

class BakerySweet_Products extends StatelessWidget {
  const BakerySweet_Products({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
              heading: "Cakes",
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 230,
                    childAspectRatio: 2),
                itemBuilder: (context, index) {
                  return CakeBox();
                },
                itemCount: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
