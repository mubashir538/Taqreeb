import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Components/Border%20Button.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/Message%20Chats.dart';
import 'package:taqreeb/Components/guests.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';

class CreateGuestList_AddPerson extends StatefulWidget {
  const CreateGuestList_AddPerson({super.key});

  @override
  State<CreateGuestList_AddPerson> createState() =>
      _CreateGuestList_AddPersonState();
}

class _CreateGuestList_AddPersonState extends State<CreateGuestList_AddPerson> {
  List<Map<String, String>> guestList = [];

  TextEditingController personcontroller = TextEditingController();
  TextEditingController contactcontroller = TextEditingController();
  bool isfunction = false;
  int functionid = 0;
  int eventId = 0;
  Map<String, dynamic> args = {};
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    this.args = args;
    setState(() {
      if (args['functionid'] != null) {
        isfunction = true;
        functionid = args['functionid'];
      }
      eventId = args['eventId'];
    });
  }

  void removePerson(index) {
    Future.delayed(Duration.zero, () {
      setState(() {
        guestList.removeAt(index);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              heading: 'Add Person',
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            MyTextBox(
              hint: 'Person Name',
              valueController: personcontroller,
            ),
            MyTextBox(
              hint: 'Contact Number',
              valueController: contactcontroller,
            ),
            SizedBox(
              width: screenWidth * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Guests(
                    onpressed: () {},
                    ondelete: () {
                      removePerson(index);
                    },
                    mywidth: screenWidth * 0.8,
                    name: guestList[index]['name'] ?? '',
                    contact: guestList[index]['contact'] ?? '',
                  );
                },
                itemCount: guestList.length,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            ColoredButton(
              text: 'Add Person',
              width: screenWidth * 0.7,
              onPressed: () {
                setState(() {
                  guestList.add({
                    'name': personcontroller.text,
                    'contact': contactcontroller.text
                  });
                });
              },
            ),
            BorderButton(
              text: 'Done',
              width: screenWidth * 0.7,
              onPressed: () async {
                for (int i = 0; i < guestList.length; i++) {
                  final response =
                      await MyApi.postRequest(endpoint: 'add/guests/', body: {
                    'eid': eventId,
                    'fid': isfunction ? functionid : 'None',
                    'guesttype': 'Person',
                    'PersonName': guestList[i]['name'],
                    'PersonContact': guestList[i]['contact']
                  });
                  if (response['status'] == 'success') {
                    print('Person Added');
                  } else {
                    print('Person Not Added');
                  }
                }
                Navigator.pushReplacementNamed(context, '/CreateGuestList_List',
                    arguments: args);
              },
            )
          ],
        ),
      ),
    );
  }
}
