import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:taqreeb/Components/Colored%20Button.dart';


import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/text_box.dart';

import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';





class CreateGuestList2 extends StatelessWidget {
  const CreateGuestList2({super.key});

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
            MyTextBox(hint: 'Family Name'),
            SizedBox(height: 10,),
            MyTextBox(hint: 'Members'),
            
            SizedBox(
              width: 400
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
            SizedBox(height: 500,),
            ColoredButton(text: 'Add Family')
          ],
        ),
        
      ),
    );
  }
}
