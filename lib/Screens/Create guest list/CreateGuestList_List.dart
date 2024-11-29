import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Message%20Chats.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

class CreateGuestList_List extends StatelessWidget {
  const CreateGuestList_List({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: screenHeight),
          child: Column(
            children: [
              Header(
                heading: 'Guest List',
              ),
              SizedBox(
                width: screenWidth * 0.9,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return MessageChatButton(
                      onpressed: () {},
                      name: "Haziq",
                      message: "Assalam-u-alikum",
                      time: '',
                    );
                  },
                ),
              ),
              // Container(
              //   height: 71,
              //   width: 272,
              //   decoration: BoxDecoration(
              //     color: MyColors.DarkLighter,
              //     borderRadius: BorderRadius.only(
              //       topLeft: Radius.circular(16),
              //       topRight: Radius.circular(16),
              //       bottomLeft: Radius.circular(16),
              //     ),
              //   ),
              //   child: Row(
              //     children: [
              //       SizedBox(
              //         width: 10,
              //       ),
              //       ColoredButton(
              //         text: "Add Person",
              //         height: 28,
              //         width: 115,
              //       ),
              //       SizedBox(
              //         width: 20,
              //       ),
              //       ColoredButton(
              //         text: "Add Family",
              //         height: 28,
              //         width: 115,
              //       )
              //     ],
              //   ),
              // ),

              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: MaximumThing * 0.04,
                    horizontal: screenWidth * 0.02),
                width: screenWidth * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: MyColors.red,
                      child: Image.asset(
                        MyIcons.add,
                        color: MyColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
