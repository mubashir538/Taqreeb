import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/colorPicker.dart';
import 'package:taqreeb/Components/description.dart';
import 'package:taqreeb/Components/dropdown.dart';
import 'package:taqreeb/Components/headerSecondary.dart';
import 'package:taqreeb/Screens/For%20Fyp2/Create%20AI%20Package/Components/Date%20Question.dart';
import 'package:taqreeb/Screens/For%20Fyp2/Create%20AI%20Package/Components/question%20group.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/images.dart';

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

  Timer? timer;
  void fetchData() async {
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
    final types = await MyApi.getRequest(
      endpoint: 'getEventTypes/',
      headers: {'Authorization': 'Bearer $token'},
    );
    final EventDetails;
    if (edit) {
      EventDetails = await MyApi.getRequest(
        endpoint: 'eventdetails/${eventid}',
        headers: {'Authorization': 'Bearer $token'},
      );
    } else {
      EventDetails = "";
    }

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (edit) {
            this.Event = EventDetails ?? {};
            if (this.Event != {} ||
                this.Event != {} ||
                this.Event['status'] != 'error') {
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
            }
          }
          if (Event == {} || Event['status'] == 'error') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Something Went Wrong!',
                  style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: MyColors.white,
                      fontWeight: FontWeight.w400)),
              backgroundColor: MyColors.red,
            ));
            return;
          } else {
            this.token = token;
            this.types = types ?? {};
            if (types == null || types['status'] == 'error') {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Something Went Wrong!',
                    style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: MyColors.white,
                        fontWeight: FontWeight.w400)),
                backgroundColor: MyColors.red,
              ));
              return;
            } else {
              isLoading = false;
              ischange = true;
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                          hint: "Maximum Guests",
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
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please fill all the fields"),
                      ));
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
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Something Went Wrong! Please Try Again Later!")));
                      return;
                    }
                    if (response['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: edit
                              ? Text('Event Updated Successfully')
                              : Text('Event Created Successfully')));
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/YourEvents', ModalRoute.withName('/'));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(edit
                              ? 'Error Updating Event'
                              : 'Error Creating Event')));
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
