import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Cake%20Box.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
// import 'package:taqreeb/Components/text_box.dart';
// import 'package:taqreeb/theme/color.dart';
// import 'package:taqreeb/theme/icons.dart';

class BakeryAndSweets extends StatelessWidget {
  const BakeryAndSweets({super.key});

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
        // gri(
        //   children: [
        //     SizedBox(child: CakeBox()),
        //     SizedBox(width:60,),
        //     CakeBox()
        //   ],
        // )
      ),
    );
  }
}
