import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_border_button.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_description.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/c_package_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class CategoryPackages extends StatefulWidget {
  final Map listing;
  final bool type;

  const CategoryPackages({super.key, required this.listing, this.type = false});

  @override
  State<CategoryPackages> createState() => _CategoryPackagesState();
}

class _CategoryPackagesState extends State<CategoryPackages> {
  late TextEditingController nameController;
  late TextEditingController detailsController;
  late TextEditingController priceController;

  int? editingIndex;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    detailsController = TextEditingController();
    priceController = TextEditingController();
    SetType();
  }

  void showPackagePopup({int? index}) {
    FocusNode nameFocus = new FocusNode();
    FocusNode detailsFocus = new FocusNode();
    FocusNode priceFocus = new FocusNode();
    if (index != null) {
      var package = widget.listing['Package'][index];
      nameController.text = package['name'];
      detailsController.text = package['description'];
      priceController.text = package['price'].toString();
    } else {
      nameController.clear();
      detailsController.clear();
      priceController.clear();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: MyColors.Dark,
          title: Text(
            'Add Package',
            style: GoogleFonts.montserrat(
              fontSize: Screen.max(context) * 0.02,
              fontWeight: FontWeight.w600,
              color: MyColors.Yellow,
            ),
          ),
          content: Container(
            width: Screen.width(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextBox(
                  focusNode: nameFocus,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(detailsFocus);
                  },
                  hint: 'Name',
                  valueController: nameController,
                ),
                DescriptionBox(
                  valueController: detailsController,
                  focusNode: detailsFocus,
                  onChanged: (value) {},
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(priceFocus);
                  },
                ),
                MyTextBox(
                  focusNode: priceFocus,
                  onFieldSubmitted: (_) {
                    priceFocus.unfocus();
                  },
                  hint: 'Price',
                  isNum: true,
                  isPrice: true,
                  valueController: priceController,
                ),
              ],
            ),
          ),
          actions: [
            BorderButton(
              text: 'Cancel',
              width: Screen.width(context) * 0.3,
              textSize: Screen.max(context) * 0.015,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ColoredButton(
                text: 'Add',
                width: Screen.width(context) * 0.3,
                textSize: Screen.max(context) * 0.015,
                onPressed: () async {
                  if (index == null) {
                    final response = await MyApi.postRequest(
                      headers: {
                        'Authorization':
                            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
                      },
                      endpoint: 'businessowner/updateListings/',
                      body: {
                        'id': widget.listing['Listing']['id'].toString(),
                        'operation': 'add',
                        'value': 'package',
                        'namev': nameController.text,
                        'pricev': priceController.text,
                        'descv': detailsController.text,
                      },
                    );

                    if (response['status'] == 'success') {
                      setState(() {
                        (widget.listing['Package'] as List).add({
                          'id': response['id'],
                          'name': nameController.text,
                          'description': detailsController.text,
                          'price': priceController.text,
                        });
                      });
                      MyScaffold(text: 'Package Added Successfully!')
                          .show(context);
                    } else {
                      MyScaffold(text: 'Something Went Wrong!').show(context);
                    }
                  } else {
                    final response = await MyApi.postRequest(
                      headers: {
                        'Authorization':
                            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
                      },
                      endpoint: 'businessowner/updateListings/',
                      body: {
                        'id': widget.listing['Listing']['id'].toString(),
                        'operation': 'edit',
                        'value': 'package',
                        'idv': widget.listing['Package'][index]['id'],
                        'namev': nameController.text,
                        'pricev': priceController.text,
                        'descv': detailsController.text,
                      },
                    );

                    if (response['status'] == 'success') {
                      setState(() {
                        widget.listing['Package'][index] = {
                          'name': nameController.text,
                          'description': detailsController.text,
                          'price': priceController.text,
                        };
                      });
                      MyScaffold(text: 'Package Updated Successfully!')
                          .show(context);
                    } else {
                      MyScaffold(text: 'Something Went Wrong!').show(context);
                    }
                  }

                  setState(() {
                    if (index != null) {
                      widget.listing['Package'][index] = {
                        'name': nameController.text,
                        'description': detailsController.text,
                        'price': priceController.text,
                      };
                    } else {
                      widget.listing['Package'].add({
                        'name': nameController.text,
                        'description': detailsController.text,
                        'price': priceController.text,
                      });
                    }
                  });
                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }

  void deletePackage(int index) async {
    final response = await MyApi.postRequest(
      headers: {
        'Authorization':
            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
      },
      endpoint: 'businessowner/updateListings/',
      body: {
        'id': widget.listing['Listing']['id'].toString(),
        'operation': 'delete',
        'value': 'package',
        'idv': widget.listing['Package'][index]['id']
      },
    );
    if (response['status'] == 'success') {
      setState(() {
        widget.listing['Package'].removeAt(index);
      });
      MyScaffold(text: 'Package Deleted Successfully!').show(context);
    } else {
      MyScaffold(text: 'Something Went Wrong!').show(context);
    }
  }

  bool type = false;
  Future<void> SetType() async {
    final value = await MyStorage.exists(MyTokens.isBusinessOwner) ||
        await MyStorage.exists(MyTokens.isFreelancer);
    setState(() {
      type = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (type) {
      return Padding(
        padding: EdgeInsets.only(top: Screen.height(context) * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Packages',
              style: GoogleFonts.montserrat(
                fontSize: Screen.max(context) * 0.025,
                fontWeight: FontWeight.w600,
                color: MyColors.Yellow,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Screen.height(context) * 0.02),
              child: Column(
                children: widget.listing['Package'].map<Widget>((package) {
                  int index = widget.listing['Package'].indexOf(package);
                  return Container(
                    margin: EdgeInsets.symmetric(
                        vertical: Screen.max(context) * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon:
                                      Icon(Icons.edit, color: MyColors.Yellow),
                                  onPressed: () => showPackagePopup(
                                    index: index,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: MyColors.red),
                                  onPressed: () => deletePackage(index),
                                ),
                              ],
                            ),
                            PackageBox(
                              packagedetails: package['description'],
                              packageprice: package['price'].toString(),
                              packagename: package['name'],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: MyColors.Yellow),
              onPressed: () => showPackagePopup(),
            ),
            SizedBox(
              height: Screen.height(context) * 0.05,
              child: Center(
                  child: MyDivider(
                width: Screen.width(context) * 0.85,
              )),
            ),
          ],
        ),
      );
    } else {
      return widget.listing['Package'].length != 0
          ? Padding(
              padding: EdgeInsets.only(top: Screen.height(context) * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Packages',
                    style: GoogleFonts.montserrat(
                      fontSize: Screen.max(context) * 0.025,
                      fontWeight: FontWeight.w600,
                      color: MyColors.Yellow,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: Screen.height(context) * 0.02),
                    child: Column(
                      children:
                          widget.listing['Package'].map<Widget>((package) {
                        return PackageBox(
                          packagedetails: package['description'],
                          packageprice: package['price'].toString(),
                          packagename: package['name'],
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: Screen.height(context) * 0.05,
                    child: Center(
                        child: MyDivider(
                      width: Screen.width(context) * 0.85,
                    )),
                  ),
                ],
              ),
            )
          : Container();
    }
  }
}
