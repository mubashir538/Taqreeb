// import 'package:flutter/material.dart';
// import 'package:taqreeb/Components/Cake%20Box.dart';
// // import 'package:flutter_svg/flutter_svg.dart';
// import 'package:taqreeb/Components/Cart%20Item.dart';
// // import 'package:taqreeb/Components/Colored%20Button.dart';
// import 'package:taqreeb/Components/header.dart';
// // import 'package:taqreeb/Components/text_box.dart';
// // import 'package:taqreeb/theme/color.dart';
// // import 'package:taqreeb/theme/icons.dart';

// class BakeryAndSweets extends StatelessWidget {
//   const BakeryAndSweets({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Column(
//           children: [
//             Header(
//               heading: "Cakes",
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 230,
//                     childAspectRatio: 2),
//                 itemBuilder: (context, index) {
//                   return CakeBox();
//                 },
//                 itemCount: 4,
//               ),
//             ),
//           ],
//         ),
//         // gri(
//         //   children: [
//         //     SizedBox(child: CakeBox()),
//         //     SizedBox(width:60,),
//         //     CakeBox()
//         //   ],
//         // )
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Cake%20Box.dart';
import 'package:taqreeb/Components/Cart%20Item.dart';
import 'package:taqreeb/Components/header.dart';

class BakeryAndSweets extends StatelessWidget {
  const BakeryAndSweets({super.key});

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery to get the screen size
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine number of columns based on screen size
    int crossAxisCount = 2; // Default for mobile
    if (screenWidth > 600 && screenWidth <= 1024) {
      crossAxisCount = 3; // For tablets
    } else if (screenWidth > 1024) {
      crossAxisCount = 4; // For desktop and laptops
    }

    // Adjusting spacing and aspect ratio based on screen size
    double crossAxisSpacing = 10;
    double mainAxisSpacing = 20;
    double aspectRatio = 1.0;

    if (screenWidth > 1024) {
      // Larger screens, bigger spacing and aspect ratio
      crossAxisSpacing = 15;
      mainAxisSpacing = 30;
      aspectRatio = 1.2;
    }

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
                  crossAxisCount: crossAxisCount, 
                  crossAxisSpacing: crossAxisSpacing,
                  mainAxisSpacing: mainAxisSpacing,
                  childAspectRatio: aspectRatio,
                ),
                itemBuilder: (context, index) {
                  return CakeBox();
                },
                itemCount: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
