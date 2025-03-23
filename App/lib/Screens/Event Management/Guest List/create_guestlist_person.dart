import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_border_button.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Cards/c_guest_list_card.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/Components/global/header.dart';

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
  FocusNode personFocus = FocusNode();
  FocusNode contactFocus = FocusNode();
  GlobalKey headerKey = GlobalKey();

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => UI_Management.getHeaderHeight(
            headerKey: headerKey,
            callback: (renderbox) {
              changeHeight(renderbox);
            }));
  }

  void removePerson(index) {
    Future.delayed(Duration.zero, () {
      setState(() {
        guestList.removeAt(index);
      });
    });
  }

  void changeHeight(RenderBox renderbox) {
    setState(() {
      UI_Management.headerHeight = renderbox.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    UI_Management.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          changeHeight(renderbox);
        });
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: Screen.width(context),
              child: Column(
                children: [
                  SizedBox(
                    height: (Screen.height(context) * 0.05) +
                        UI_Management.headerHeight,
                  ),
                  MyTextBox(
                    focusNode: personFocus,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(contactFocus);
                    },
                    hint: 'Person Name',
                    valueController: personcontroller,
                  ),
                  MyTextBox(
                    focusNode: contactFocus,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                    },
                    hint: 'Contact Number',
                    isNum: true,
                    valueController: contactcontroller,
                  ),
                  SizedBox(
                    width: Screen.width(context) * 0.9,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Guests(
                          onpressed: () {},
                          ondelete: () {
                            removePerson(index);
                          },
                          mywidth: Screen.width(context) * 0.8,
                          name: guestList[index]['name'] ?? '',
                          contact: guestList[index]['contact'] ?? '',
                        );
                      },
                      itemCount: guestList.length,
                    ),
                  ),
                  SizedBox(
                    height: Screen.height(context) * 0.05,
                  ),
                  ColoredButton(
                    text: 'Add Person',
                    width: Screen.width(context) * 0.7,
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
                    width: Screen.width(context) * 0.7,
                    onPressed: () async {
                      for (int i = 0; i < guestList.length; i++) {
                        final token =
                            await MyStorage.getToken(MyTokens.accessToken) ??
                                "";

                        final response = await MyApi.postRequest(
                            headers: {'Authorization': 'Bearer $token'},
                            endpoint: 'add/guests/',
                            body: {
                              'eid': eventId,
                              'fid': isfunction ? functionid : 'None',
                              'guesttype': 'Person',
                              'PersonName': guestList[i]['name'],
                              'PersonContact': guestList[i]['contact']
                            });
                        if (response['status'] == 'success') {
                          MyScaffold(text: 'Person Added').show(context);
                        } else {
                          MyScaffold(text: 'Person Not Added').show(context);
                        }
                      }
                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/CreateGuestList_List',
                          ModalRoute.withName('//EventDetails'),
                          arguments: args);
                    },
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
              heading: 'Add Person',
            ),
          ),
        ],
      ),
    );
  }
}
