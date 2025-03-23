import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_border_button.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';


class UpperHeadings extends StatefulWidget {
  final Map listing;
  final int? listingId;
  final Map events;
  final DateTime? selectedDate;
  const UpperHeadings(
      {super.key,
      required this.listing,
      required this.listingId,
      required this.selectedDate,
      required this.events});

  @override
  State<UpperHeadings> createState() => _UpperHeadingsState();
}

class _UpperHeadingsState extends State<UpperHeadings> {
  bool isEditingName = false;
  bool isEditingLocation = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  Color selectedColor = MyColors.white;
  IconData selectedIcon = FontAwesomeIcons.heart;
  @override
  void initState() {
    super.initState();
    nameController.text = widget.listing['Listing']['name'] ?? '';
    locationController.text = widget.listing['Listing']['location'] ?? '';
    SetType();
  }

  void showHierarchicalOptions(
      BuildContext context, double maxThing, double width) {
    showModalBottomSheet(
      context: context,
      backgroundColor: MyColors.Dark,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(maxThing * 0.02),
          decoration: BoxDecoration(
            color: MyColors.Dark,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(maxThing * 0.05)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: maxThing * 0.02),
                child: Text(
                  "Choose for a Function",
                  style: GoogleFonts.montserrat(
                    fontSize: maxThing * 0.025,
                    fontWeight: FontWeight.w500,
                    color: MyColors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.events['Event']?.length ?? 0,
                  itemBuilder: (context, index) {
                    final event = widget.events['Event'][index];
                    return Container(
                      margin: EdgeInsets.only(bottom: maxThing * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: MyColors.red,
                        ),
                        color: MyColors.DarkLighter,
                      ),
                      child: ExpansionTile(
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: MyColors.red,
                        collapsedBackgroundColor: MyColors.DarkLighter,
                        title: Text(
                          event['name'],
                          style: GoogleFonts.montserrat(
                            fontSize: maxThing * 0.015,
                            fontWeight: FontWeight.w400,
                            color: MyColors.white,
                          ),
                        ),
                        children: [
                          ...event['functions'].map<Widget>((function) {
                            return ListTile(
                              title: Text(
                                function['name'],
                                style: GoogleFonts.montserrat(
                                  fontSize: maxThing * 0.015,
                                  color: MyColors.whiteDarker,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              onTap: () async {
                                final token = await MyStorage.getToken(
                                    MyTokens.accessToken);
                                final response = await MyApi.postRequest(
                                    headers: {'Authorization': 'Bearer $token'},
                                    endpoint: 'add/Bookcart/',
                                    body: {
                                      'fid': function['id'].toString(),
                                      'uid': await MyStorage.getToken(
                                              MyTokens.userId) ??
                                          "",
                                      'lid': widget.listingId.toString(),
                                      'type': 'Venue',
                                    });

                                if (response['status'] == 'success') {
                                  Navigator.pop(context);
                                } else if (response['status'] ==
                                    'BudgetError') {
                                  warningDialog(
                                    message: 'Event Budget is Exceeding',
                                    title: 'Budget Exceed',
                                    actions: [ColoredButton(text: 'Ok')],
                                  ).showDialogBox(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Something went wrong',
                                        style: GoogleFonts.montserrat(
                                          fontSize: maxThing * 0.015,
                                          color: MyColors.white,
                                        ),
                                      ),
                                      backgroundColor: MyColors.red,
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              },
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> saveField(String field, String value) async {
    try {
      final response = await MyApi.postRequest(
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
        },
        endpoint: 'businessowner/updateListings/',
        body: {
          'id': widget.listingId.toString(),
          field: value,
        },
      );

      if (response['status'] == 'success') {
        setState(() {
          widget.listing['Listing'][field] = value;

          if (field == 'name') isEditingName = false;
          if (field == 'location') isEditingLocation = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$field updated successfully!')),
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to update $field.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
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

  void wishlistSelection(double max) async {
    if (selectedColor == MyColors.red) {
      final response =
          await MyApi.postRequest(endpoint: 'wishlist/delete', body: {
        'userid': await MyStorage.getToken(MyTokens.userId),
        'listing': widget.listingId,
      }, headers: {
        'Authorization':
            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
      });

      if (response['status'] == 'success') {
        selectedColor = MyColors.white;
        selectedIcon = FontAwesomeIcons.heart;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: MyColors.red,
            content: Text(
              'Removed from wishlist!',
              style: GoogleFonts.montserrat(
                  color: MyColors.white,
                  fontSize: max * 0.015,
                  fontWeight: FontWeight.w500),
            ),
          ),
        );
      }
    } else {
      final response = await MyApi.postRequest(endpoint: 'wishlist/add', body: {
        'userid': await MyStorage.getToken(MyTokens.userId),
        'listing': widget.listingId,
      }, headers: {
        'Authorization':
            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
      });
      if (response['status'] == 'success') {
        selectedIcon = FontAwesomeIcons.solidHeart;
        selectedColor = MyColors.red;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: MyColors.red,
            content: Text(
              'Added to wishlist!',
              style: GoogleFonts.montserrat(
                  color: MyColors.white,
                  fontSize: max * 0.015,
                  fontWeight: FontWeight.w500),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double maximumDimension =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isEditingName && type
                  ? Flexible(
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            style: GoogleFonts.montserrat(
                              fontSize: maximumDimension * 0.025,
                              color: MyColors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Edit name',
                              hintStyle: GoogleFonts.montserrat(
                                color: MyColors.white.withOpacity(0.6),
                                fontSize: maximumDimension * 0.015,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          ColoredButton(
                            text: 'Save',
                            onPressed: () =>
                                saveField('name', nameController.text),
                          ),
                        ],
                      ),
                    )
                  : Flexible(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: screenWidth * 0.6,
                                child: Text(
                                  widget.listing['Listing']['name'],
                                  softWrap: true,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                    fontSize: maximumDimension * 0.025,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.white,
                                  ),
                                ),
                              ),
                              !type
                                  ? Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              wishlistSelection(
                                                  maximumDimension);
                                            });
                                          },
                                          child: Icon(
                                            selectedIcon,
                                            color: selectedColor,
                                            size: maximumDimension * 0.03,
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.01),
                                        GestureDetector(
                                          onTap: () {
                                            showHierarchicalOptions(context,
                                                maximumDimension, screenWidth);
                                          },
                                          child: Icon(
                                            Icons.add,
                                            color: MyColors.Yellow,
                                            size: maximumDimension * 0.05,
                                          ),
                                        ),
                                      ],
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        warningDialog(
                                          title: 'Delete',
                                          message:
                                              'Are yo sure You want to delete this Listing?',
                                          actions: [
                                            BorderButton(
                                              text: 'Cancel',
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              width: screenWidth * 0.3,
                                              textSize:
                                                  maximumDimension * 0.015,
                                            ),
                                            ColoredButton(
                                              text: 'Delete',
                                              onPressed: () async {
                                                final token =
                                                    await MyStorage.getToken(
                                                        MyTokens.accessToken);
                                                final response =
                                                    await MyApi.postRequest(
                                                        endpoint:
                                                            'businessowner/DeleteListings/',
                                                        body: {
                                                      'id': widget.listingId
                                                    },
                                                        headers: {
                                                      'Authorization':
                                                          'Bearer $token'
                                                    });
                                                String message;
                                                if (response['status'] ==
                                                    'success') {
                                                  message =
                                                      'Listing Deleted Successfully!';
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          '/YourListings',
                                                          ModalRoute.withName(
                                                              '/HomePage'));
                                                } else {
                                                  message =
                                                      'Something went Wrong!';
                                                  Navigator.of(context).pop();
                                                }
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  backgroundColor: MyColors.red,
                                                  content: Text(message,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize:
                                                            maximumDimension *
                                                                0.015,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: MyColors.white,
                                                      )),
                                                ));
                                              },
                                              width: screenWidth * 0.3,
                                              textSize:
                                                  maximumDimension * 0.015,
                                            ),
                                          ],
                                        ).showDialogBox(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              spreadRadius: 0.5,
                                              blurRadius: 3,
                                              blurStyle: BlurStyle.inner),
                                        ]),
                                        margin: EdgeInsets.all(
                                            maximumDimension * 0.02),
                                        child: Icon(
                                          Icons.delete,
                                          size: maximumDimension * 0.03,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          !type
                              ? Container()
                              : ColoredButton(
                                  text: 'Edit',
                                  onPressed: () => setState(() {
                                    isEditingName = true;
                                  }),
                                ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
        Container(
          width: screenWidth * 0.9,
          padding: EdgeInsets.only(top: screenHeight * 0.02),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isEditingLocation && type
                  ? Flexible(
                      child: Column(
                        children: [
                          TextField(
                            controller: locationController,
                            style: GoogleFonts.montserrat(
                              fontSize: maximumDimension * 0.015,
                              color: MyColors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Edit location...',
                              hintStyle: GoogleFonts.montserrat(
                                color: MyColors.white.withOpacity(0.6),
                                fontSize: maximumDimension * 0.015,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          ColoredButton(
                            text: 'Save',
                            onPressed: () =>
                                saveField('location', locationController.text),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      width: screenWidth * 0.9,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: MyColors.Yellow),
                              Text(
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 3,
                                "${widget.listing['reveiewData']['average']} (${widget.listing['reveiewData']['count']})",
                                style: GoogleFonts.montserrat(
                                  fontSize: maximumDimension * 0.015,
                                  color: MyColors.white,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: screenWidth * 0.6,
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  widget.listing['Listing']['location'],
                                  softWrap: true,
                                  style: GoogleFonts.montserrat(
                                    fontSize: maximumDimension * 0.015,
                                    color: MyColors.white,
                                  ),
                                ),
                              ),
                              if (type)
                                ColoredButton(
                                    text: 'Edit',
                                    width: screenWidth * 0.5,
                                    textSize: maximumDimension * 0.015,
                                    onPressed: () {
                                      setState(() {
                                        isEditingLocation = true;
                                      });
                                    }),
                            ],
                          ),
                          Icon(
                            Icons.location_on,
                            color: MyColors.white,
                            size: maximumDimension * 0.04,
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
