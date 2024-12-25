import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Cake%20Box.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/color.dart';

class BakerySweet_Products extends StatefulWidget {
  const BakerySweet_Products({super.key});

  @override
  State<BakerySweet_Products> createState() => _BakerySweet_ProductsState();
}

class _BakerySweet_ProductsState extends State<BakerySweet_Products> {
  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  void _getHeaderHeight() {
    final RenderBox renderBox =
        _headerKey.currentContext?.findRenderObject() as RenderBox;
    setState(() {
      _headerHeight = renderBox.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Container(
        child: Column(
          children: [
            Header(
              key: _headerKey,
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
