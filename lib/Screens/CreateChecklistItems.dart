import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/Components/headerSecondary.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/theme/images.dart';

class CreateChecklistItems extends StatefulWidget {
  const CreateChecklistItems({Key? key}) : super(key: key);

  @override
  State<CreateChecklistItems> createState() => _CreateChecklistItemsState();
}

class _CreateChecklistItemsState extends State<CreateChecklistItems> {
  List<Map<String, dynamic>> checklistItems = [];
  List<Map<String, dynamic>> newitems = [];
  List<Map<String, dynamic>> changedFields = [];
  String token = '';
  final TextEditingController _textController = TextEditingController();

  bool isfunction = false;
  int functionid = 0;
  int eventId = 0;
  Map<String, dynamic> list = {};
  bool isLoading = true;
  bool changedfirst = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    setState(() {
      if (args['functionid'] != null) {
        isfunction = true;
        functionid = args['functionid'];
      }
      eventId = args['eventId'];
    });
    if (!changedfirst) {
      fetchData();
    }
  }

  Timer? timer;

  void fetchData() async {
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
    final fetchedlist = await MyApi.getRequest(
      endpoint: isfunction
          ? 'show/checklist/$eventId/$functionid'
          : 'show/checklist/$eventId',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (mounted) {
      setState(() {
        this.token = token;
        this.list = fetchedlist ?? {};
        if (list.isEmpty || list['status'] == 'error') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Something Went Wrong!',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: MyColors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            backgroundColor: MyColors.red,
          ));
          return;
        }
        if (list['checklist'] != null) {
          checklistItems = (list['checklist'] as List)
              .map((e) => e as Map<String, dynamic>)
              .toList();
        }
        isLoading = false;
      });
    }
    changedfirst = true;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _addChecklistItem(String text) {
    setState(() {
      checklistItems.add({"description": text, "isChecked": false});
      newitems.add({"description": text, "isChecked": false});
    });
    _textController.clear();
  }

  void _toggleChecklistItem(int index) {
    setState(() {
      checklistItems[index]["isChecked"] = !checklistItems[index]["isChecked"];

      bool isNewItem = newitems.any((item) =>
          item["description"] == checklistItems[index]["description"]);

      if (!isNewItem) {
        bool isAlreadyChanged = changedFields.any((item) =>
            item["description"] == checklistItems[index]["description"]);

        if (!isAlreadyChanged) {
          changedFields.add({
            "id": checklistItems[index]["id"],
            "description": checklistItems[index]["description"],
            "isChecked": checklistItems[index]["isChecked"],
          });
        } else {
          changedFields = changedFields.map((item) {
            if (item["description"] == checklistItems[index]["description"]) {
              return {
                "description": item["description"],
                "isChecked": checklistItems[index]["isChecked"],
              };
            }
            return item;
          }).toList();
        }
      } else {
        int newIndex = newitems.indexWhere((item) =>
            item["description"] == checklistItems[index]["description"]);
        newitems[newIndex]["isChecked"] = checklistItems[index]["isChecked"];
      }
    });
  }

  void _showAddItemDialog() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double maxthing = screenWidth > screenHeight ? screenWidth : screenHeight;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MyColors.Dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          "Add Checklist Item",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: MyTextBox(
            hint: 'Enter Checklist Item', valueController: _textController),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: GoogleFonts.montserrat(
                  color: MyColors.red,
                  fontSize: maxthing * 0.015,
                  fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () {
              if (_textController.text.trim().isNotEmpty) {
                _addChecklistItem(_textController.text.trim());
                Navigator.of(context).pop();
              }
            },
            child: Text(
              "Add",
              style: GoogleFonts.montserrat(
                  fontSize: maxthing * 0.015,
                  color: MyColors.red,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Headersecondary(
                      heading: "Create CheckList",
                      para: "From to-do to done one check at a time!",
                      image: MyImages.CheckList,
                    ),
                    isLoading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(MyColors.white),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: checklistItems.length,
                            itemBuilder: (context, index) {
                              final item = checklistItems[index];
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: MaximumThing * 0.02,
                                    vertical: MaximumThing * 0.01),
                                padding: EdgeInsets.symmetric(
                                    vertical: MaximumThing * 0.007,
                                    horizontal: MaximumThing * 0.02),
                                decoration: BoxDecoration(
                                  color: MyColors.DarkLighter,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: MyColors.red,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: item["isChecked"],
                                      onChanged: (value) {
                                        _toggleChecklistItem(index);
                                      },
                                      activeColor: MyColors.red,
                                    ),
                                    Text(
                                      item["description"],
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        decoration: item["isChecked"]
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                    SizedBox(height: MaximumThing * 0.02),
                  ]),
                  Center(
                    child: ColoredButton(
                        text: 'Save',
                        onPressed: () async {
                          bool flag = false;
                          for (var item in changedFields) {
                            final response = await MyApi.postRequest(
                                endpoint: 'update/checklist',
                                headers: {
                                  'Authorization': 'Bearer $token'
                                },
                                body: {
                                  'id': item["id"],
                                  'item': item["description"],
                                  'ischecked': item["isChecked"],
                                });
                            if (response['status'] != 'success') {
                              flag = true;
                              break;
                            }
                          }
                          for (var item in newitems) {
                            final response = await MyApi.postRequest(
                              endpoint: 'add/checklist',
                              headers: {'Authorization': 'Bearer $token'},
                              body: {
                                'functionId': isfunction ? functionid : "None",
                                'eventId': eventId,
                                'item': item["description"],
                                'ischecked': item["isChecked"],
                              },
                            );
                            if (!(response['status'] == 'success')) {
                              flag = true;
                              break;
                            }
                          }
                          SnackBar snackBar = SnackBar(
                            content: Text(flag
                                ? 'Failed to save checklist'
                                : 'Checklist Saved successfully'),
                            backgroundColor: MyColors.Dark,
                            duration: Duration(seconds: 2),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.of(context).pop();
                        },
                        width: screenWidth * 0.5),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: MyColors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
