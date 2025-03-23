import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Screens/Temp/For%20Fyp2/Create%20AI%20Package/Components/Date%20Question.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_dropdown.dart';
import '../../../core/utils/images.dart';

class CreateFunction extends StatefulWidget {
  const CreateFunction({super.key});

  @override
  State<CreateFunction> createState() => _CreateFunctionState();
}

class _CreateFunctionState extends State<CreateFunction> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController guestMaxController = TextEditingController();
  TextEditingController guestMinController = TextEditingController();
  FocusNode datafocus = FocusNode();
  FocusNode namefocus = FocusNode();
  FocusNode typefocus = FocusNode();
  FocusNode budgetfocus = FocusNode();
  FocusNode guestmaxfocus = FocusNode();
  FocusNode guestminfocus = FocusNode();

  String token = '';
  Map<String, dynamic> types = {};
  bool isLoading = true;
  String functionId = "";
  int eventtypeid = 0;
  int EventId = 0;
  Map<String, dynamic> Function = {};
  Map<String, dynamic> args = {};
  GlobalKey headerKey = GlobalKey();
  bool edit = false;
  bool changed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    this.args = args;
    setState(() {
      if (args['functionId'] != null) {
        this.functionId = args['functionId'];
        edit = true;
      } else {
        this.EventId = int.parse(args['eventId'].toString());
      }
    });
    fetchData();
  }

  void fetchData() async {
    await ApiCall.fetchAPI('getEventTypes/', onSuccess: (token, data) {
      for (int i = 0; i < data['eventTypes'].length; i++) {
        if (data['eventTypes'][i]['name'] == args['type']) {
          eventtypeid = data['eventTypes'][i]['id'];
        }
      }
    }, context: mounted ? context : null);

    await ApiCall.fetchAPI('getFunctionTypes/$eventtypeid',
        onSuccess: (token, data) {}, context: mounted ? context : null);
    if (edit) {
      await ApiCall.fetchAPI('ViewFunction/$functionId',
          onSuccess: (token, data) {
        if (mounted) {
          setState(() {
            Function = data;
            if ((Function != {} && !changed)) {
              nameController.text = Function['Fuctions']['name'];
              typeController.text = Function['Fuctions']['type'];
              _dateController.text = Function['Fuctions']['date'];
              budgetController.text = Function['Fuctions']['budget'].toString();
              guestMaxController.text =
                  Function['Fuctions']['guestsmax'].toString();
              guestMinController.text =
                  Function['Fuctions']['guestsmin'].toString();
              EventId =
                  int.parse(this.Function['Fuctions']['eventId'].toString());
              changed = true;
            }
            this.token = token;
            types = types;
            isLoading = false;
          });
        }
      }, context: mounted ? context : null);
    }
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
              constraints: BoxConstraints(minHeight: Screen.height(context)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: UI_Management.headerHeight),
                  Column(
                    children: [
                      SizedBox(
                        height: Screen.height(context) * 0.04,
                      ),
                      MyTextBox(
                        focusNode: namefocus,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(budgetfocus);
                        },
                        hint: 'Funtion Name',
                        valueController: nameController,
                      ),
                      MyTextBox(
                        focusNode: budgetfocus,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(typefocus);
                        },
                        hint: 'Budget',
                        isNum: true,
                        isPrice: true,
                        valueController: budgetController,
                      ),
                      ResponsiveDropdown(
                          focusNode: typefocus,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(guestminfocus);
                          },
                          items: isLoading
                              ? []
                              : types['functionTypes']
                                  .map((val) => val['name'].toString())
                                  .cast<String>()
                                  .toList(),
                          labelText: 'Function Type',
                          onChanged: (value) {
                            setState(() {
                              typeController.text = value;
                            });
                          }),
                      DateQuestion(
                        question: '',
                        valuecontroller: _dateController,
                        focusNode: datafocus,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(guestminfocus);
                        },
                      ),
                      MyTextBox(
                        focusNode: guestminfocus,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(guestmaxfocus);
                        },
                        hint: 'Minimum Guests',
                        isNum: true,
                        valueController: guestMinController,
                      ),
                      MyTextBox(
                        focusNode: guestmaxfocus,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        hint: 'Screen.max(context) Guests',
                        isNum: true,
                        valueController: guestMaxController,
                      ),
                    ],
                  ),
                  ColoredButton(
                    text: edit ? 'Edit Function' : 'Add Function',
                    onPressed: () async {
                      if (nameController.text.isEmpty ||
                          typeController.text.isEmpty ||
                          _dateController.text.isEmpty ||
                          budgetController.text.isEmpty ||
                          guestMaxController.text.isEmpty ||
                          guestMinController.text.isEmpty) {
                        MyScaffold(text: 'Please fill all the fields')
                            .show(context);
                        return;
                      }
                      final response = await MyApi.postRequest(
                          endpoint: edit ? 'editfunction/' : 'createfunction/',
                          headers: {
                            'Authorization': 'Bearer $token'
                          },
                          body: {
                            'Function Name': nameController.text,
                            'Date': _dateController.text,
                            'Type': typeController.text,
                            'Budget': budgetController.text,
                            'guest min': guestMinController.text,
                            'guest max': guestMaxController.text,
                            'Function Id': this.functionId,
                            'Event Id': this.EventId
                          });
                      if (response['status'] == 'success') {
                        MyScaffold(
                                text: edit
                                    ? 'Function Updated Successfully'
                                    : 'Function Added Successfully')
                            .show(context);
                        edit
                            ? Navigator.pop(context)
                            : Navigator.pushNamed(context, '/YourEvents');
                      } else if (response['status'] == 'BudgetError') {
                        warningDialog(
                          message: 'Event Budget is Exceeding',
                          title: 'Budget Exceed',
                          actions: [ColoredButton(text: 'Ok')],
                        ).showDialogBox(context);
                        edit
                            ? Navigator.pop(context)
                            : Navigator.pushNamed(context, '/YourEvents');
                      } else {
                        MyScaffold(
                                text: edit
                                    ? 'Error Updating Function'
                                    : 'Error Creating Function')
                            .show(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
              heading: edit ? 'Edit Funtion' : 'Create Funtion',
              image: MyImages.Function,
            ),
          ),
        ],
      ),
    );
  }
}
