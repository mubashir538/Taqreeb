import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/theme/color.dart';

class UpperHeadings extends StatefulWidget {
  final Map listing;
  final bool type;
  final int? listingId;
  final Map events;
  final DateTime? selectedDate;
  const UpperHeadings(
      {super.key,
      required this.listing,
      required this.type,
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

  @override
  void initState() {
    super.initState();
    nameController.text = widget.listing['Listing']['name'] ?? '';
    locationController.text = widget.listing['Listing']['location'] ?? '';
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
                                final response = await MyApi.postRequest(
                                    headers: {
                                      'Authorization':
                                          'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
                                    },
                                    endpoint: 'add/Bookcart/',
                                    body: {
                                      'fid': function['id'].toString(),
                                      'uid': await MyStorage.getToken(
                                              MyTokens.userId) ??
                                          "",
                                      'lid': widget.listingId.toString(),
                                      'widget.type': 'Venue',
                                      'slot': widget.selectedDate.toString(),
                                    });

                                if (response['status'] == 'success') {
                                  Navigator.pop(context);
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
        endpoint: '/update-listing', // Replace with your actual endpoint
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
              isEditingName
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
                              Text(
                                widget.listing['Listing']['name'],
                                softWrap: true,
                                style: GoogleFonts.montserrat(
                                  fontSize: maximumDimension * 0.025,
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.white,
                                ),
                              ),
                              GestureDetector(
                                onTap: widget.type
                                    ? () {}
                                    : () {
                                        showHierarchicalOptions(context,
                                            maximumDimension, screenWidth);
                                      },
                                child: Icon(
                                  widget.type ? Icons.delete : Icons.add,
                                  color: MyColors.Yellow,
                                  size: widget.type
                                      ? maximumDimension * 0.03
                                      : maximumDimension * 0.05,
                                ),
                              ),
                            ],
                          ),
                          ColoredButton(
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
              isEditingLocation
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
                    child: Column(
                      
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: maximumDimension * 0.01),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.star, color: MyColors.Yellow),
                                    Text(
                                      "${widget.listing['reveiewData']['average'].toString()} (${widget.listing['reveiewData']['count'].toString()})",
                                      style: GoogleFonts.montserrat(
                                          fontSize: maximumDimension * 0.015,
                                          color: MyColors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                widget.listing['Listing']['location'],
                                softWrap: true,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.montserrat(
                                    fontSize: maximumDimension * 0.015,
                                    color: MyColors.white),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: maximumDimension * 0.01),
                                child: Icon(
                                  Icons.location_on,
                                  color: MyColors.white,
                                  size: maximumDimension * 0.04,
                                ),
                              )
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     Text(
                          //       widget.listing['Listing']['location'],
                          //       softWrap: true,
                          //       textAlign: TextAlign.start,
                          //       style: GoogleFonts.montserrat(
                          //         fontSize: maximumDimension * 0.015,
                          //         color: MyColors.white,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        
                          ColoredButton(
                            text: 'Edit',
                            onPressed: () => setState(() {
                              isEditingLocation = true;
                            }),
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
