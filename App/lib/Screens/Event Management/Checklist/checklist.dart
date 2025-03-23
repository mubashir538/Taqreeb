import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/header_secondary.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/images.dart';

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

  void fetchData() async {
    ApiCall.fetchAPI(
        isfunction
            ? 'show/checklist/$eventId/$functionid'
            : 'show/checklist/$eventId', onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          list = data;
          this.token = token;
        });
        if (list['checklist'] != null) {
          checklistItems = (list['checklist'] as List)
              .map((e) => e as Map<String, dynamic>)
              .toList();
        }
        isLoading = false;
      }

      changedfirst = true;
    }, context: mounted ? context : null);
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
    double maxthing = Screen.width(context) > Screen.height(context)
        ? Screen.width(context)
        : Screen.height(context);

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
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minHeight: Screen.height(context)),
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
                                    horizontal: Screen.max(context) * 0.02,
                                    vertical: Screen.max(context) * 0.01),
                                padding: EdgeInsets.symmetric(
                                    vertical: Screen.max(context) * 0.007,
                                    horizontal: Screen.max(context) * 0.02),
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
                    SizedBox(height: Screen.max(context) * 0.02),
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
                          MyScaffold(
                                  text: flag
                                      ? 'Failed to save checklist'
                                      : 'Checklist Saved successfully')
                              .show(context);
                          Navigator.of(context).pop();
                        },
                        width: Screen.width(context) * 0.5),
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
