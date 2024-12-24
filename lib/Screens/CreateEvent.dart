import 'package:flutter/material.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/colorPicker.dart';
import 'package:taqreeb/Components/dropdown.dart';
import 'package:taqreeb/Screens/Create%20AI%20Package/Components/Date%20Question.dart';
import 'package:taqreeb/Screens/Create%20AI%20Package/Components/question%20group.dart';
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

  String token = '';
  Map<String, dynamic> types = {};
  bool isLoading = true;
  String eventid = "";
  Map<String, dynamic> Event = {};
  bool edit = false;

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
    fetchData();
  }

  void fetchData() async {
    final token = await MyStorage.getToken('accessToken') ?? "";
    final types = await MyApi.getRequest(endpoint: 'getEventTypes/');
    final EventDetails;
    if (edit) {
      EventDetails =
          await MyApi.getRequest(endpoint: 'eventdetails/${eventid}');
    } else {
      EventDetails = "";
    }
    print(EventDetails);
    setState(() {
      if (edit) {
        print('Edit Screen');
        this.Event = EventDetails ?? {};
        if (this.Event != {}) {
          eventNameController.text = this.Event['EventDetail']['name'];
          typeController.text = this.Event['EventDetail']['type'];
          dateController.text = this.Event['EventDetail']['date'];
          locationController.text = this.Event['EventDetail']['location'];
          descriptionController.text = this.Event['EventDetail']['description'];
          budgetController.text =
              this.Event['EventDetail']['budget'].toString();
          themeColor.text = this.Event['EventDetail']['themeColor'];
          guestMaxController.text =
              this.Event['EventDetail']['guestsmax'].toString();
          guestMinController.text =
              this.Event['EventDetail']['guestsmin'].toString();
        }
      }
      this.token = token;
      this.types = types ?? {};
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // double MaximumThing =
    //     screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Header(
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
                      hint: "Event Name",
                      valueController: eventNameController,
                    ),
                    ResponsiveDropdown(
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
                      question: '',
                      valuecontroller: dateController,
                    ),
                    MyTextBox(
                      hint: "Location",
                      valueController: locationController,
                    ),
                    ColorPickerTextBox(
                      hint: "Theme Color",
                      valueController: themeColor,
                    )
                  ], Heading: "Basic Info"),
                  QuestionGroup(questions: [
                    SizedBox(
                      height: screenHeight * 0.2,
                      child: MyTextBox(
                        hint: "Enter Description",
                        valueController: descriptionController,
                      ),
                    ),
                  ], Heading: "Describe Your Event"),
                  QuestionGroup(questions: [
                    MyTextBox(
                      hint: "Minimum Guests",
                      valueController: guestMinController,
                    ),
                    MyTextBox(
                      hint: "Maximum Guests",
                      valueController: guestMaxController,
                    ),
                  ], Heading: "Guest Info"),
                  QuestionGroup(questions: [
                    MyTextBox(
                      hint: "Enter Budget",
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
                final userId = await MyStorage.getToken('userId');
                final response = await MyApi.postRequest(
                    endpoint: edit ? 'EditEvent/' : 'CreateEvent/',
                    body: {
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
                  Navigator.pushNamed(context, '/YourEvents');
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
    );
  }
}
