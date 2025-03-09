import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/Components/Border%20Button.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/Screens/For%20Fyp2/Create%20AI%20Package/Components/radio%20button%20question.dart';
import 'package:taqreeb/theme/color.dart';

class CategoryAddons extends StatefulWidget {
  final Map<String, dynamic> listing;

  const CategoryAddons({super.key, required this.listing});

  @override
  State<CategoryAddons> createState() => _CategoryAddonsState();
}

class _CategoryAddonsState extends State<CategoryAddons> {
  late List<TextEditingController> headingControllers;
  late List<TextEditingController> valueControllers;
  late List<bool> isEditingHeading;
  late List<bool> isEditingValue;
  bool type = false;
  Future<void> SetType() async {
    final value = await MyStorage.exists(MyTokens.isBusinessOwner) ||
        await MyStorage.exists(MyTokens.isFreelancer);
    setState(() {
      type = value;
    });
  }

  @override
  void initState() {
    super.initState();
    headingControllers = [];
    valueControllers = [];
    for (int i = 0; i < widget.listing['Addons'].length; i++) {
      headingControllers.add(
          TextEditingController(text: widget.listing['Addons'][i]['name']));
      valueControllers.add(TextEditingController(
          text: widget.listing['Addons'][i]['price'].toString()));
    }
    isEditingHeading =
        List<bool>.generate(widget.listing['Addons'].length, (_) => false);
    isEditingValue =
        List<bool>.generate(widget.listing['Addons'].length, (_) => false);
    SetType();
  }

  void saveAddon(int index) async {
    final response = await MyApi.postRequest(
      headers: {
        'Authorization':
            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
      },
      endpoint: 'businessowner/updateListings/',
      body: {
        'id': widget.listing['Listing']['id'].toString(),
        'idv': widget.listing['Addons'][index]['id'].toString(),
        'operation': 'edit',
        'value': 'addon',
        'namev': headingControllers[index].text,
        'pricev': valueControllers[index].text
      },
    );
    if (response['status'] == 'success') {
      setState(() {
        widget.listing['Addons'][index]['name'] =
            headingControllers[index].text;
        widget.listing['Addons'][index]['price'] = valueControllers[index].text;
        isEditingHeading[index] = false;
        isEditingValue[index] = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Addon Updated Successfully!',
            style: GoogleFonts.montserrat(
                fontSize: 14,
                color: MyColors.white,
                fontWeight: FontWeight.w400)),
        backgroundColor: MyColors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Something Went Wrong!',
            style: GoogleFonts.montserrat(
                fontSize: 14,
                color: MyColors.white,
                fontWeight: FontWeight.w400)),
        backgroundColor: MyColors.red,
      ));
    }
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  void addAddon(double screenWidth, double maximum) {
    TextEditingController nameController = new TextEditingController();
    TextEditingController perheadController = new TextEditingController();
    TextEditingController headtypeController = new TextEditingController();
    TextEditingController priceController = new TextEditingController();
    FocusNode nameFocus = new FocusNode();
    FocusNode priceFocus = new FocusNode();
    FocusNode perheadFocus = new FocusNode();
    bool isPerhead = false;
    Map<String, dynamic> newItem = {};
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
          return AlertDialog(
            backgroundColor: MyColors.Dark,
            title: Text(
              'Add Add-Ons',
              style: GoogleFonts.montserrat(
                fontSize: maximum * 0.02,
                fontWeight: FontWeight.w600,
                color: MyColors.Yellow,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextBox(
                  focusNode: nameFocus,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(priceFocus);
                  },
                  hint: 'Name',
                  valueController: nameController,
                ),
                MyTextBox(
                  focusNode: priceFocus,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(perheadFocus);
                  },
                  hint: 'Price',
                  isNum: true,
                  isPrice: true,
                  valueController: priceController,
                ),
                RadioButtonQuestion(
                    options: ['Yes', 'No'],
                    question: '',
                    myValue: perheadController.text,
                    onChanged: (value) {
                      setDialogState(() {
                        perheadController.text = value.toString();
                        if (value == 'Yes') {
                          isPerhead = true;
                        } else {
                          isPerhead = false;
                        }
                      });
                    }),
                isPerhead
                    ? MyTextBox(
                        hint: 'PerHead Type',
                        valueController: headtypeController)
                    : Container(),
              ],
            ),
            actions: [
              BorderButton(
                text: 'Cancel',
                width: screenWidth * 0.3,
                textSize: maximum * 0.015,
                onPressed: () {
                  Navigator.of(context).pop(); 
                },
              ),
              ColoredButton(
                text: 'Add',
                width: screenWidth * 0.3,
                textSize: maximum * 0.015,
                onPressed: () async {
                  if (nameController.text.isNotEmpty &&
                      priceController.text.isNotEmpty) {
                    final response = await MyApi.postRequest(
                      headers: {
                        'Authorization':
                            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
                      },
                      endpoint: 'businessowner/updateListings/',
                      body: {
                        'id': widget.listing['Listing']['id'].toString(),
                        'operation': 'add',
                        'value': 'addon',
                        'namev': nameController.text,
                        'pricev': priceController.text,
                        'perheadv': isPerhead ? 'Yes' : 'No',
                        'headtypev': isPerhead ? headtypeController.text : '',
                      },
                    );

                    if (response['status'] == 'success') {
                      setState(() {
                        if (isPerhead && headtypeController.text.isNotEmpty) {
                          priceController.text = priceController.text +
                              '/' +
                              headtypeController.text;
                        }

                        newItem = {
                          'id': response['id'],
                          'name': nameController.text,
                          "price": priceController.text,
                          "isPer": isPerhead,
                          "perType": isPerhead ? headtypeController.text : '',
                          "listingId": widget.listing['Listing']['id'],
                        };
                        headingControllers.add(
                            TextEditingController(text: nameController.text));
                        valueControllers.add(
                            TextEditingController(text: priceController.text));
                        isEditingHeading.add(false);
                        isEditingValue.add(false);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Addon Added Successfully!',
                            style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: MyColors.white,
                                fontWeight: FontWeight.w400)),
                        backgroundColor: MyColors.red,
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Failed to Add Addon!',
                            style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: MyColors.white,
                                fontWeight: FontWeight.w400)),
                        backgroundColor: MyColors.red,
                      ));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please Fill All the Fields!',
                          style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: MyColors.white,
                              fontWeight: FontWeight.w400)),
                      backgroundColor: MyColors.red,
                    ));
                  }
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
      },
    ).then((result) {
      if (result != null) {
        setState(() {
          (widget.listing['Addons'] as List).add(newItem);
        });
      }
    });
  }

  void deleteAddon(int index) async {
    final response = await MyApi.postRequest(
      headers: {
        'Authorization':
            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
      },
      endpoint: 'businessowner/updateListings/',
      body: {
        'id': widget.listing['Listing']['id'].toString(),
        'idv': widget.listing['Addons'][index]['id'].toString(),
        'operation': 'delete',
        'value': 'addon',
      },
    );
    if (response['status'] == 'success') {
      setState(() {
        (widget.listing['Addons'] as List).removeAt(index);
        headingControllers.removeAt(index);
        valueControllers.removeAt(index);
        isEditingHeading.removeAt(index);
        isEditingValue.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Addon Deleted Successfully!',
            style: GoogleFonts.montserrat(
                fontSize: 14,
                color: MyColors.white,
                fontWeight: FontWeight.w400)),
        backgroundColor: MyColors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Something Went Wrong!',
            style: GoogleFonts.montserrat(
                fontSize: 14,
                color: MyColors.white,
                fontWeight: FontWeight.w400)),
        backgroundColor: MyColors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double maximumDimension =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    if (type) {
      return Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add-Ons',
              style: GoogleFonts.montserrat(
                fontSize: maximumDimension * 0.025,
                fontWeight: FontWeight.w600,
                color: MyColors.Yellow,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.02),
              child: Column(
                children: [
                  for (int i = 0; i < widget.listing['Addons'].length; i++)
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: maximumDimension * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add-On ${i + 1}',
                            style: GoogleFonts.montserrat(
                              fontSize: maximumDimension * 0.015,
                              fontWeight: FontWeight.w500,
                              color: MyColors.Yellow,
                            ),
                          ),
                          if (isEditingHeading[i])
                            TextField(
                              controller: headingControllers[i],
                              style: GoogleFonts.montserrat(
                                fontSize: maximumDimension * 0.015,
                                color: MyColors.white,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Addon Name',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            )
                          else
                            Text(
                              _capitalize(widget.listing['Addons'][i]['name']),
                              style: GoogleFonts.montserrat(
                                fontSize: maximumDimension * 0.015,
                                fontWeight: FontWeight.w400,
                                color: MyColors.white,
                              ),
                            ),
                          if (isEditingValue[i])
                            TextField(
                              controller: valueControllers[i],
                              style: GoogleFonts.montserrat(
                                fontSize: maximumDimension * 0.015,
                                color: MyColors.white,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Addon Price',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            )
                          else
                            Text(
                              widget.listing['Addons'][i]['isPer']
                                  ? widget.listing['Addons'][i]['price']
                                          .toString() +
                                      '/' +
                                      _capitalize(widget.listing['Addons'][i]
                                          ['perType'])
                                  : widget.listing['Addons'][i]['price']
                                      .toString(),
                              style: GoogleFonts.montserrat(
                                fontSize: maximumDimension * 0.015,
                                fontWeight: FontWeight.w400,
                                color: MyColors.white,
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ColoredButton(
                                text:
                                    isEditingHeading[i] ? 'Save' : 'Edit Name',
                                width: screenWidth * 0.25,
                                textSize: maximumDimension * 0.015,
                                onPressed: isEditingHeading[i]
                                    ? () => saveAddon(i)
                                    : () => setState(
                                        () => isEditingHeading[i] = true),
                              ),
                              SizedBox(width: maximumDimension * 0.02),
                              ColoredButton(
                                textSize: maximumDimension * 0.015,
                                width: screenWidth * 0.25,
                                text: isEditingValue[i] ? 'Save' : 'Edit Price',
                                onPressed: isEditingValue[i]
                                    ? () => saveAddon(i)
                                    : () => setState(
                                        () => isEditingValue[i] = true),
                              ),
                              SizedBox(width: maximumDimension * 0.02),
                              ColoredButton(
                                textSize: maximumDimension * 0.015,
                                width: screenWidth * 0.25,
                                text: 'Delete',
                                onPressed: () => deleteAddon(i),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ColoredButton(
                    text: 'Add New Add-On',
                    onPressed: () => addAddon(screenWidth, maximumDimension),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
              child: Center(
                  child: MyDivider(
                width: screenWidth * 0.85,
              )),
            ),
          ],
        ),
      );
    } else {
      return widget.listing['Addons'].length != 0
          ? Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add-Ons',
                    style: GoogleFonts.montserrat(
                      fontSize: maximumDimension * 0.025,
                      fontWeight: FontWeight.w600,
                      color: MyColors.Yellow,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: Column(
                      children: [
                        for (int i = 0;
                            i < widget.listing['Addons'].length;
                            i++)
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: maximumDimension * 0.01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.listing['Addons'][i]['name'],
                                  style: GoogleFonts.montserrat(
                                    fontSize: maximumDimension * 0.015,
                                    fontWeight: FontWeight.w500,
                                    color: MyColors.Yellow,
                                  ),
                                ),
                                Text(
                                  widget.listing['Addons'][i]['isPer']
                                      ? widget.listing['Addons'][i]['price']
                                              .toString() +
                                          '/' +
                                          _capitalize(widget.listing['Addons']
                                              [i]['perType'])
                                      : widget.listing['Addons'][i]['price']
                                          .toString(),
                                  style: GoogleFonts.montserrat(
                                    fontSize: maximumDimension * 0.015,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                    child: Center(
                        child: MyDivider(
                      width: screenWidth * 0.85,
                    )),
                  ),
                ],
              ),
            )
          : Container();
    }
  }
}
