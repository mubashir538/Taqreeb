import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/message.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/Components/Recieve%20Message.dart';
import 'package:taqreeb/Components/Send%20Message.dart';
import 'package:taqreeb/theme/color.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({super.key});

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    List<message> messages = [
      message(text: "Hi Haziq, How are You???", time: "12:01", isSent: true),
      message(
          text: "Bhai !!, Shaadi kr rha hoon, My Life Update 😊",
          time: "12:01",
          isSent: false),
      message(text: "Nhi Kro, Kb??", time: "12:02", isSent: true),
      message(
          text: "Next Month, Taqreeb pr hi update krunga aapko",
          time: "12:02",
          isSent: false),
      message(text: "Done Hogya!!", time: "12:03", isSent: true),
    ];
    return Scaffold(
      body: Column(children: [
        Header(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: MaximumThing * 0.03),
          height: screenHeight * 0.16,
          width: screenWidth,
          decoration: BoxDecoration(
            color: MyColors.red,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Haziq Taufeeq",
                    style: GoogleFonts.montserrat(
                      fontSize: MaximumThing * 0.025,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        weight: MaximumThing * 0.015,
                        color: MyColors.green,
                      ),
                      SizedBox(width: MaximumThing * 0.01),
                      Text("Online",
                          style: GoogleFonts.montserrat(
                            fontSize: MaximumThing * 0.015,
                            fontWeight: FontWeight.w400,
                          ))
                    ],
                  )
                ],
              ),
              CircleAvatar(
                radius: MaximumThing * 0.05,
                backgroundImage: NetworkImage(
                    "https://scontent.fkhi22-1.fna.fbcdn.net/v/t39.30808-6/462846583_3652200215061112_1789201124871518447_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=a5f93a&_nc_eui2=AeGpHXERbYJJSCtMY41W3zHD-B-YeID1F0j4H5h4gPUXSB1bFpiWGzL35-mKNMsaQ0fa70ajZFJykL6bI8r-wcla&_nc_ohc=RLHkVdtsB0YQ7kNvgGST43z&_nc_zt=23&_nc_ht=scontent.fkhi22-1.fna&_nc_gid=A46WfLMDHfcgmj5-t5Gjq1R&oh=00_AYCxK5-Nf7vLus_3G_WkcXAGjWTdEy9r9uZCeytGKArjqQ&oe=672A9643"),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) => messages[index].isSent
                ? SendMessage(
                    text: messages[index].text, time: messages[index].time)
                : RecieveMessage(
                    text: messages[index].text, time: messages[index].time),
            itemCount: 5,
          ),
        ),
        SizedBox(
          width: screenWidth * 0.9,
          height: screenHeight * 0.06,
          child: TextField(
              cursorColor: MyColors.white,
              style: GoogleFonts.montserrat(
                fontSize: MaximumThing * 0.015,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                  fillColor: MyColors.DarkLighter,
                  filled: true,
                  suffixIcon: Icon(
                    Icons.mic,
                    color: MyColors.white,
                  ),
                  prefixIcon: Icon(
                    Icons.attachment_rounded,
                    color: MyColors.Yellow,
                    size: MaximumThing * 0.03,
                  ),
                  hintText: "Type Message",
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: MaximumThing * 0.015,
                    fontWeight: FontWeight.w300,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: MyColors.white,
                        width: 0.1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(30),
                  ))),
        ),
        SizedBox(
          height: MaximumThing * 0.02,
        )
      ]),
    );
  }
}
