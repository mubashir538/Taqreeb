import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/images.dart';

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

  String token = '';
  Map<String, dynamic> types = {};
  bool isLoading = true;
  String functionId = "";
  int EventId = 0;
  Map<String, dynamic> Function = {};
  bool edit = false;
  @override
  void initState() {
    super.initState();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
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
    final token = await MyStorage.getToken('accessToken') ?? "";
    final types = await MyApi.getRequest(endpoint: 'getEventTypes/');

    final FunctiontDetails;
    if (edit) {
      FunctiontDetails =
          await MyApi.getRequest(endpoint: 'YourEvents/${functionId}');
    } else {
      FunctiontDetails = "";
    }
    setState(() {
      if (edit) {
        this.Function = FunctiontDetails ?? {};
        if (this.Function != {}) {
          nameController.text = this.Function['Fuctions']['name'];
          typeController.text = this.Function['Fuctions']['type'];
          _dateController.text = this.Function['Fuctions']['date'];
          budgetController.text = this.Function['Fuctions']['budget'];
          guestMaxController.text = this.Function['Fuctions']['guestsmax'];
          guestMinController.text = this.Function['Fuctions']['guestsmin'];
          this.EventId =
              int.parse(this.Function['Fuctions']['eventId'].toString());
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
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: screenHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Header(
                    heading: 'Create Funtion',
                    image: MyImages.Function,
                  ),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  MyTextBox(
                    hint: 'Funtion Name',
                    valueController: nameController,
                  ),
                  MyTextBox(
                    hint: 'Budget',
                    valueController: budgetController,
                  ),
                  MyTextBox(
                    hint: "Event Type",
                    valueController: typeController,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.01),
                    height: screenHeight * 0.06,
                    width: screenWidth * 0.9,
                    decoration: BoxDecoration(
                      color: MyColors.DarkLighter,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: Offset(2, 2))
                      ],
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: TextField(
                        readOnly: true,
                        textAlignVertical: TextAlignVertical.center,
                        controller: _dateController,
                        style: GoogleFonts.montserrat(
                          fontSize: MaximumThing * 0.018,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.date_range_rounded),
                          hintText: 'Select Date',
                          hintStyle: GoogleFonts.montserrat(
                            color: MyColors.white.withOpacity(0.6),
                            fontSize: MaximumThing * 0.015,
                          ),
                          border: InputBorder.none,
                        ),
                        onTap: () => _selectDate(context),
                      ),
                    ),
                  )
                ],
              ),
              ColoredButton(
                text: 'Add Function',
                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      typeController.text.isEmpty ||
                      _dateController.text.isEmpty ||
                      budgetController.text.isEmpty ||
                      guestMaxController.text.isEmpty ||
                      guestMinController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please fill all the fields"),
                    ));
                    return;
                  }
                  final response = await MyApi.postRequest(
                      endpoint: 'createfunction/',
                      body: {
                        'Function Name': nameController.text,
                        'Date': typeController.text,
                        'Type': _dateController.text,
                        'Budget': budgetController.text,
                        'guest min': guestMinController.text,
                        'guest max': guestMaxController.text,
                        'Event Id': this.EventId
                      });
                  final responseBody = await response.stream.bytesToString();
                  final Map<String, dynamic> jsonResponse =
                      jsonDecode(responseBody);
                  if (jsonResponse['status'] != 'success') {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Function Added Successfully')));
                    Navigator.pushNamed(context, '/YourEvents');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error Creating Function')));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (pickedDate != null) {
      setState(() {
        _dateController.text = pickedDate.toString().split(" ")[0];
      });
    }
  }
}
