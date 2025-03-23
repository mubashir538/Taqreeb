// import 'package:flutter/material.dart';
// import 'package:taqreeb/Components/temp/Cart%20Item.dart';

// class Cart extends StatefulWidget {
//   const Cart({super.key});

//   @override
//   State<Cart> createState() => _CartState();
// }

// class _CartState extends State<Cart> {
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: MyColors.Dark,
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Container(
//               child: Column(
//                 children: [
//                   SizedBox(
//                     width: screenWidth * 0.9,
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: 5,
//                       itemBuilder: (context, index) {
//                         return CartItems(name: "Qasr e Noor", price: "500,000");
//                       },
//                     ),
//                   ),
//                   Container(
//                       margin:
//                           EdgeInsets.symmetric(vertical: screenHeight * 0.04),
//                       child: ColoredButton(text: 'Proceed'))
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             top: 0,
//             child: Header(
//               heading: 'Cart Items',
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
