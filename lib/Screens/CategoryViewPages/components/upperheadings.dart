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
      this.type = false,
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

  Future<void> saveField(String field, String value) async {
    if (widget.type) return;

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
              isEditingName && !widget.type
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
                              if (!widget.type)
                                GestureDetector(
                                  onTap: () {
                                    // Custom behavior for the add button
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: MyColors.Yellow,
                                    size: maximumDimension * 0.05,
                                  ),
                                ),
                            ],
                          ),
                          !widget.type
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
              isEditingLocation && !widget.type
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
