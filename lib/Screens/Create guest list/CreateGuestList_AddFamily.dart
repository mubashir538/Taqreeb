import 'package:flutter/material.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Components/Border%20Button.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/guests.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';

class CreateGuestList_AddFamily extends StatefulWidget {
  const CreateGuestList_AddFamily({super.key});

  @override
  State<CreateGuestList_AddFamily> createState() =>
      _CreateGuestList_AddFamilyState();
}

class _CreateGuestList_AddFamilyState extends State<CreateGuestList_AddFamily> {
  List<Map<String, String>> guestList = [];

  TextEditingController familyNamecontroller = TextEditingController();
  TextEditingController memberscontroller = TextEditingController();
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

  void removeFamily(index) {
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
              heading: 'Add Family',
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            MyTextBox(
              hint: 'Family Name',
              valueController: familyNamecontroller,
            ),
            MyTextBox(
              hint: 'No. of Members',
              valueController: memberscontroller,
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
                      removeFamily(index);
                    },
                    mywidth: screenWidth * 0.8,
                    name: guestList[index]['name'] ?? '',
                    contact: guestList[index]['members'] ?? '',
                  );
                },
                itemCount: guestList.length,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            ColoredButton(
              text: 'Add Family',
              width: screenWidth * 0.7,
              onPressed: () {
                setState(() {
                  guestList.add({
                    'name': familyNamecontroller.text,
                    'members': memberscontroller.text
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
                    'guesttype': 'Family',
                    'FamilyName': guestList[i]['name'],
                    'member': guestList[i]['members']
                  });
                  if (response['status'] == 'success') {
                    print('Family Added');
                  } else {
                    print('Family Not Added');
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
