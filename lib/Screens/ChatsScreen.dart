import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:taqreeb/Components/Message%20Chats.dart';
import 'package:taqreeb/Components/Search%20Box.dart';
import 'package:taqreeb/Components/header.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    TextEditingController controller = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Header(
            heading: "Chats",
            para:
                "This password should br different  from the previous password",
          ),
          Container(
            margin: EdgeInsets.only(top: screenHeight * 0.03),
            child: SearchBox(
              controller: controller,
              width: screenWidth * 0.9,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 8,
            itemBuilder: (context, index) {
              return MessageChatButton(
                  onpressed: () {
                    Navigator.pushNamed(context, '/ChatBox');
                  },
                  name: "Haziq",
                  message: "Assalam-u-alikum",
                  newMessage: 3,
                  time: '11:30 AM');
            },
          ),
        ]),
      ),
    );
  }
}
