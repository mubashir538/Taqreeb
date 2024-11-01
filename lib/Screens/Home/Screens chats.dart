import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taqreeb/Components/Border%20Button.dart';
import 'package:taqreeb/Components/Cake%20Box.dart';
import 'package:taqreeb/Components/Cart%20Item.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/Message%20Chats,dart';
import 'package:taqreeb/Components/OTP%20Boxes.dart';
import 'package:taqreeb/Components/Selection%20Dialog.dart';
import 'package:taqreeb/Components/abc.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/navbar.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/images.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
Header(
  
  heading: "Chats",
  
  para: "This password should br different  from the previous password",
  
),
 SizedBox(height: 30,),
 MessageChatButton(name: "Haziq", message: "Assalam-u-alikum", time: '11:30 AM'),
  SizedBox(height: 20,),
 MessageChatButton(name: "Haziq", message: "Assalam-u-alikum", time: '11:30 AM'),
  SizedBox(height: 20,),
 MessageChatButton(name: "Haziq", message: "Assalam-u-alikum", time: '11:30 AM'),
  SizedBox(height: 20,),
 MessageChatButton(name: "Haziq", message: "Assalam-u-alikum", time: '11:30 AM'),
  SizedBox(height: 20,),
 MessageChatButton(name: "Haziq", message: "Assalam-u-alikum", time: '11:30 AM'),
  SizedBox(height: 20,),
 MessageChatButton(name: "Haziq", message: "Assalam-u-alikum", time: '11:30 AM'),
  SizedBox(height: 20,),
 MessageChatButton(name: "Haziq", message: "Assalam-u-alikum", time: '11:30 AM'),

  SizedBox(height: 80,),
Navbar(),
]
        ),        
      ),
    );
  }
}