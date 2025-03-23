import 'package:flutter/material.dart';
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
  FocusNode familyNameFocus = FocusNode();
  FocusNode membersFocus = FocusNode();
  bool isfunction = false;
  int functionid = 0;
  int eventId = 0;
  Map<String, dynamic> args = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
  }

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

  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  void _getHeaderHeight() {
    final RenderObject? renderBox =
        _headerKey.currentContext?.findRenderObject();

    if (renderBox is RenderBox) {
      setState(() {
        _headerHeight = renderBox.size.height;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _getHeaderHeight();
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
                    height: (Screen.height(context) * 0.05) + _headerHeight,
                  ),
                  MyTextBox(
                    focusNode: familyNameFocus,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(membersFocus);
                    },
                    hint: 'Family Name',
                    valueController: familyNamecontroller,
                  ),
                  MyTextBox(
                    focusNode: membersFocus,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                    },
                    hint: 'No. of Members',
                    isNum: true,
                    valueController: memberscontroller,
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
                            removeFamily(index);
                          },
                          mywidth: Screen.width(context) * 0.8,
                          name: guestList[index]['name'] ?? '',
                          contact: guestList[index]['members'] ?? '',
                        );
                      },
                      itemCount: guestList.length,
                    ),
                  ),
                  SizedBox(
                    height: Screen.height(context) * 0.05,
                  ),
                  ColoredButton(
                    text: 'Add Family',
                    width: Screen.width(context) * 0.7,
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
                    width: Screen.width(context) * 0.7,
                    onPressed: () async {
                      final token =
                          await MyStorage.getToken(MyTokens.accessToken) ?? "";
                      for (int i = 0; i < guestList.length; i++) {
                        final response = await MyApi.postRequest(
                            headers: {'Authorization': 'Bearer $token'},
                            endpoint: 'add/guests/',
                            body: {
                              'eid': eventId,
                              'fid': isfunction ? functionid : 'None',
                              'guesttype': 'Family',
                              'FamilyName': guestList[i]['name'],
                              'member': guestList[i]['members']
                            });
                        if (response['status'] == 'success') {
                          MyScaffold(text: 'Family Added').show(context);
                        } else {
                          MyScaffold(text: 'Family not Added').show(context);
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
              key: _headerKey,
              heading: 'Add Family',
            ),
          ),
        ],
      ),
    );
  }
}
