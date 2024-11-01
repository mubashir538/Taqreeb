import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/Message%20Chats.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';


 

class CreateGuestList4 extends StatelessWidget {
  const CreateGuestList4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          
          children: [
            Header(
              heading: 'Guest List',
            ),
            SizedBox(height: 20,),
  SizedBox(height: 20,),
  MessageChatButton(name: "Haziq", message: "Assalam-u-alikum",time: '',),
            SizedBox(height: 10,),
     MessageChatButton(name: "Haziq", message: "Assalam-u-alikum",time: '',),         
           SizedBox(height: 10,),
     MessageChatButton(name: "Haziq", message: "Assalam-u-alikum",time: '',),
     SizedBox(height: 10,),
     MessageChatButton(name: "Haziq", message: "Assalam-u-alikum",time: '',),
     SizedBox(height: 10,),
     MessageChatButton(name: "Haziq", message: "Assalam-u-alikum",time: '',),
     SizedBox(height: 10,),
     MessageChatButton(name: "Haziq", message: "Assalam-u-alikum",time: '',),
     SizedBox(height: 10,),
     MessageChatButton(name: "Haziq", message: "Assalam-u-alikum",time: '',),
     SizedBox(height: 10,),
     MessageChatButton(name: "Haziq", message: "Assalam-u-alikum",time: '',),
     
SizedBox(height: 50,),
    Container(
                
                height: 71,
                width: 272,
                decoration: BoxDecoration(
                  color: MyColors.DarkLighter,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),                                       
                    bottomLeft: Radius.circular(16),
                    
                  ),
                  
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10,),
                    ColoredButton(text: "Add Person",
                    height: 28, width: 115,),
                    SizedBox(width: 20,),
                     ColoredButton(text: "Add Family",
                    height: 28, width: 115,)
                  ],
                ),
              ),
     
     SizedBox(height: 10,),
            SizedBox(
              width: 300
              ,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset(MyIcons.add,
                  color: MyColors.white,
                  ),
                ],
              ),
            ),
            
 
          ],
        ),
        
      ),
    );
  }
}