import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/dropdown.dart';
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
  int eventtypeid = 0;
  int EventId = 0;
  // Map<String, dynamic> event = {};
  Map<String, dynamic> Function = {};
  Map<String, dynamic> args = {};
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
    final token = await MyStorage.getToken('accessToken') ?? "";
    final eventtypes = await MyApi.getRequest(endpoint: 'getEventTypes/');

    for (int i = 0; i < eventtypes['eventTypes'].length; i++) {
      if (eventtypes['eventTypes'][i]['name'] == args['type']) {
        eventtypeid = eventtypes['eventTypes'][i]['id'];
      }
    }
    final types = await MyApi.getRequest(
      endpoint: 'getFunctionTypes/$eventtypeid',
    );

    final FunctiontDetails;
    if (edit) {
      FunctiontDetails =
          await MyApi.getRequest(endpoint: 'ViewFunction/${functionId}');
    } else {
      FunctiontDetails = "";
    }
    setState(() {
      if (edit) {
        this.Function = FunctiontDetails ?? {};
        if (this.Function != {} && !changed) {
          nameController.text = this.Function['Fuctions']['name'];
          typeController.text = this.Function['Fuctions']['type'];
          _dateController.text = this.Function['Fuctions']['date'];
          budgetController.text =
              this.Function['Fuctions']['budget'].toString();
          guestMaxController.text =
              this.Function['Fuctions']['guestsmax'].toString();
          guestMinController.text =
              this.Function['Fuctions']['guestsmin'].toString();
          this.EventId =
              int.parse(this.Function['Fuctions']['eventId'].toString());
          changed = true;
        }
      }
      this.token = token;
      this.types = types ?? {};
      isLoading = false;
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: _headerHeight),
                  Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.04,
                      ),
                      MyTextBox(
                        hint: 'Funtion Name',
                        valueController: nameController,
                      ),
                      MyTextBox(
                        hint: 'Budget',
                        isNum: true,
                        isPrice: true,
                        valueController: budgetController,
                      ),
                      ResponsiveDropdown(
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
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: MaximumThing * 0.01),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05),
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
                      ),
                      MyTextBox(
                        hint: 'Minimum Guests',isNum: true,
                        valueController: guestMinController,
                      ),
                      MyTextBox(
                        hint: 'Maximum Guests',isNum: true,
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
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Please fill all the fields"),
                        ));
                        return;
                      }
                      print({
                        'Function Name': nameController.text,
                        'Date': _dateController.text,
                        'Type': typeController.text,
                        'Budget': budgetController.text,
                        'guest min': guestMinController.text,
                        'guest max': guestMaxController.text,
                        'Function Id': this.functionId
                      });
                      final response = await MyApi.postRequest(
                          endpoint: edit ? 'editfunction/' : 'createfunction/',
                          body: {
                            'Function Name': nameController.text,
                            'Date': _dateController.text,
                            'Type': typeController.text,
                            'Budget': budgetController.text,
                            'guest min': guestMinController.text,
                            'guest max': guestMaxController.text,
                            'Function Id': this.functionId
                          });
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(edit
                                ? 'Function Updated Successfully'
                                : 'Function Added Successfully')));
                        edit
                            ? Navigator.pop(context)
                            : Navigator.pushNamed(context, '/Event');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(edit
                                ? 'Error Updating Function'
                                : 'Error Creating Function')));
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
              key: _headerKey,
              heading: edit ? 'Edit Funtion' : 'Create Funtion',
              image: MyImages.Function,
            ),
          ),
        ],
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
