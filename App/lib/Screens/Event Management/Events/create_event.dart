import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_color_picker.dart';
import 'package:taqreeb/Components/Inputs/c_input_description.dart';
import 'package:taqreeb/Components/Inputs/c_input_dropdown.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/header_secondary.dart';
import 'package:taqreeb/Screens/Temp/For%20Fyp2/Create%20AI%20Package/Components/Date%20Question.dart';
import 'package:taqreeb/Screens/Temp/For%20Fyp2/Create%20AI%20Package/Components/question%20group.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/images.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  TextEditingController themeColor = TextEditingController();
  TextEditingController eventNameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  TextEditingController guestMinController = TextEditingController();
  TextEditingController guestMaxController = TextEditingController();
  FocusNode themeColorFocus = FocusNode();
  FocusNode eventNameFocus = FocusNode();
  FocusNode typeFocus = FocusNode();
  FocusNode dateFocus = FocusNode();
  FocusNode locationFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  FocusNode budgetFocus = FocusNode();
  FocusNode guestMinFocus = FocusNode();
  FocusNode guestMaxFocus = FocusNode();

  String token = '';
  Map<String, dynamic> types = {};
  bool isLoading = true;
  String eventid = "";
  Map<String, dynamic> Event = {};
  bool edit = false;
  bool ischange = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    if (args.isNotEmpty) {
      setState(() {
        eventid = args;
        edit = true;
      });
    }
    if (!ischange) {
      fetchData();
    }
  }

  void fetchData() async {
    if (edit) {
      ApiCall.fetchAPI('eventdetails/$eventid', onSuccess: (token, data) {
        if (mounted) {
          setState(() {
            Event = data;
            eventNameController.text = this.Event['EventDetail']['name'];
            typeController.text = this.Event['EventDetail']['type'];
            dateController.text = this.Event['EventDetail']['date'];
            locationController.text = this.Event['EventDetail']['location'];
            descriptionController.text =
                this.Event['EventDetail']['description'];
            budgetController.text =
                this.Event['EventDetail']['budget'].toString();
            themeColor.text = this.Event['EventDetail']['themeColor'];
            guestMaxController.text =
                this.Event['EventDetail']['guestsmax'].toString();
            guestMinController.text =
                this.Event['EventDetail']['guestsmin'].toString();
            ApiCall.fetchAPI('getEventTypes/', onSuccess: (token, data) {
              this.token = token;
              types = types;
              isLoading = false;
              ischange = true;
            }, context: mounted ? context : null);
          });
        }
      }, context: mounted ? context : null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Headersecondary(
                  heading: edit ? "Edit Event" : "Create Event",
                  para: "Plan your event effortlessly!",
                  image: MyImages.SingupPng,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: Screen.width(context) * 0.05),
                  child: Column(
                    children: [
                      QuestionGroup(questions: [
                        MyTextBox(
                          focusNode: eventNameFocus,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(typeFocus);
                          },
                          hint: "Event Name",
                          valueController: eventNameController,
                        ),
                        ResponsiveDropdown(
                            focusNode: typeFocus,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(dateFocus);
                            },
                            items: isLoading
                                ? []
                                : types['eventTypes']
                                    .map((val) => val['name'].toString())
                                    .cast<String>()
                                    .toList(),
                            labelText: 'Event Type',
                            onChanged: (value) {
                              setState(() {
                                typeController.text = value;
                              });
                            }),
                        DateQuestion(
                          focusNode: dateFocus,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(locationFocus);
                          },
                          question: '',
                          valuecontroller: dateController,
                        ),
                        MyTextBox(
                          focusNode: locationFocus,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(themeColorFocus);
                          },
                          hint: "Location",
                          valueController: locationController,
                        ),
                        ColorPickerTextBox(
                          focusNode: themeColorFocus,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(descriptionFocus);
                          },
                          hint: "Theme Color",
                          valueController: themeColor,
                        )
                      ], Heading: "Basic Info"),
                      QuestionGroup(questions: [
                        DescriptionBox(
                          focusNode: descriptionFocus,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(guestMinFocus);
                          },
                          valueController: descriptionController,
                          onChanged: (value) {},
                        )
                      ], Heading: "Describe Your Event"),
                      QuestionGroup(questions: [
                        MyTextBox(
                          focusNode: guestMinFocus,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(guestMaxFocus);
                          },
                          hint: "Minimum Guests",
                          isNum: true,
                          valueController: guestMinController,
                        ),
                        MyTextBox(
                          focusNode: guestMaxFocus,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(budgetFocus);
                          },
                          hint: "Screen.max(context) Guests",
                          isNum: true,
                          valueController: guestMaxController,
                        ),
                      ], Heading: "Guest Info"),
                      QuestionGroup(questions: [
                        MyTextBox(
                          focusNode: budgetFocus,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                          },
                          hint: "Enter Budget",
                          isNum: true,
                          isPrice: true,
                          valueController: budgetController,
                        ),
                      ], Heading: "Budget")
                    ],
                  ),
                ),
                ColoredButton(
                  text: edit ? "Edit Event" : "Create Event",
                  onPressed: () async {
                    if (eventNameController.text.isEmpty ||
                        typeController.text.isEmpty ||
                        dateController.text.isEmpty ||
                        locationController.text.isEmpty ||
                        descriptionController.text.isEmpty ||
                        budgetController.text.isEmpty) {
                      MyScaffold(text: 'Please fill all the fields')
                          .show(context);
                      return;
                    }
                    final userId =
                        await MyStorage.getToken(MyTokens.userId) ?? "";
                    final response = await MyApi.postRequest(
                        endpoint: edit ? 'EditEvent/' : 'CreateEvent/',
                        headers: {
                          'Authorization': 'Bearer $token'
                        },
                        body: {
                          'userId': userId,
                          'Event Name': eventNameController.text,
                          'Event Type': typeController.text,
                          'Date': dateController.text,
                          'Location': locationController.text,
                          'description': descriptionController.text,
                          'Theme': themeColor.text,
                          'Budget': budgetController.text,
                          'EventId': eventid,
                          'guestmin': guestMinController.text,
                          'guestmax': guestMaxController.text
                        });
                    if (response['status'] == 'error') {
                      MyScaffold(
                              text:
                                  'Something Went Wrong! Please Try Again Later!')
                          .show(context);
                      return;
                    }
                    if (response['status'] == 'success') {
                      MyScaffold(
                              text: edit
                                  ? 'Event Updated Successfully'
                                  : 'Event Created Successfully')
                          .show(context);
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/YourEvents', ModalRoute.withName('/'));
                    } else {
                      MyScaffold(
                              text: edit
                                  ? 'Error Updating Event'
                                  : 'Error Creating Event')
                          .show(context);
                    }
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Header(),
          ),
        ],
      ),
    );
  }
}
