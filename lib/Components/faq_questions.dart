// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:taqreeb/theme/color.dart';

// class FAQQuestion extends StatelessWidget {
//   final String question;
//   final String answer;
//   final bool isExpanded;
//   final VoidCallback onToggle;


//   const FAQQuestion({super.key, 
//     Key? key,
//     required this.question,
//     required this.answer,

//     required this.isExpanded,
//     required this.onToggle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onToggle,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: MyColors.DarkLighter,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     question,
//                     style: GoogleFonts.montserrat(
//                       color: MyColors.Yellow,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Icon(
//                   isExpanded
//                       ? Icons.keyboard_arrow_up
//                       : Icons.keyboard_arrow_down,
//                   color: Colors.white,
//                 ),
//               ],
//             ),
//             if (isExpanded)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Text(
//                   answer,
//                   style: GoogleFonts.montserrat(
//                     color: MyColors.white,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
