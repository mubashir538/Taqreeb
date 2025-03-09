import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:url_launcher/url_launcher.dart';

class CategoryDetails extends StatefulWidget {
  final List<String> headings;
  final List<String> values;
  final Map<String, dynamic> listing;
  final bool type;

  const CategoryDetails({
    super.key,
    required this.listing,
    required this.headings,
    required this.values,
    this.type = false,
  });

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  List<TextEditingController> controllers = [];
  List<bool> isEditing = [];

  @override
  void initState() {
    super.initState();
    String mincontrol = '';
    bool guest = false;
    controllers = widget.values.map((value) {
      if (value.contains('-')) {
        final parts = value.split('-');
        mincontrol = parts[1].trim();
        guest = true;
        return TextEditingController(text: parts[0].trim());
      } else {
        return TextEditingController(text: value);
      }
    }).toList();
    if (guest) controllers.add(TextEditingController(text: mincontrol));
    isEditing = List<bool>.generate(widget.values.length, (_) => false);
    SetType();
    fetchListingDetails();
  }

  List<List<String>> dropdownChoices = [];
  bool isLoading = true;
  List<dynamic> choices = [];
  Future<void> fetchListingDetails() async {
    final response = await MyApi.getRequest(
        endpoint: 'getListingDetails/${widget.listing['Listing']['type']}',
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
        });

    if (response['fields'] != null) {
      setState(() {
        dropdownChoices = [];
        isEditing = [];

        for (var field in response['fields']) {
          choices.add(field['choices']?.isEmpty ?? true ? '' : '');
          dropdownChoices.add(field['choices']?.cast<String>() ?? []);
          isEditing.add(false);
        }
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveValue(int index) async {
    final response = await MyApi.postRequest(
      headers: {
        'Authorization':
            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
      },
      endpoint: 'businessowner/updateListings/',
      body: {
        'id': widget.listing['Listing']['id'].toString(),
        toLowerCaseNoSpaces(widget.headings[index]):
            widget.values[index].contains('-')
                ? controllers[index].text +
                    '-' +
                    controllers[controllers.length - 1].text
                : controllers[index].text,
      },
    );
    if (response['status'] == 'success') {
      setState(() {
        if (widget.values[index].contains('-')) {
          final guestMin = controllers[index].text.trim();
          final guestMax = controllers[controllers.length - 1].text.trim();
          widget.values[index] = '$guestMin-$guestMax';
        } else {
          widget.values[index] = controllers[index].text;
        }
        isEditing[index] = false;
        isEditGuestMax = false;
        isEditGuestMin = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('${widget.headings[index]} updated successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${widget.headings[index]} failed to Update Server Error!')),
      );
    }
  }

  bool type = false;
  bool isEditGuestMin = false, isEditGuestMax = false;
  Future<void> SetType() async {
    final value = await MyStorage.exists(MyTokens.isBusinessOwner) ||
        await MyStorage.exists(MyTokens.isFreelancer);
    setState(() {
      type = value;
    });
  }

  String toLowerCaseNoSpaces(String input) {
    return input.toLowerCase().replaceAll(' ', '');
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double maximumDimension =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    if (type) {
      return isLoading
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(MyColors.white),
            )
          : Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.02),
              child: Column(
                children: [
                  for (int i = 0; i < widget.headings.length; i++)
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: maximumDimension * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.values[i].contains('-') && type)
                            if (isEditGuestMin)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Guest Min',
                                        style: GoogleFonts.montserrat(
                                          fontSize: maximumDimension * 0.015,
                                          fontWeight: FontWeight.w500,
                                          color: MyColors.Yellow,
                                        ),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: screenWidth * 0.4,
                                        ),
                                        child: TextField(
                                          controller: controllers[i],
                                          style: GoogleFonts.montserrat(
                                            fontSize: maximumDimension * 0.015,
                                            color: MyColors.white,
                                          ),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'Enter Guest Min...',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ColoredButton(
                                          width: screenWidth * 0.4,
                                          textSize: maximumDimension * 0.015,
                                          text:
                                              isEditGuestMin ? "Save" : "Edit",
                                          onPressed: isEditGuestMin
                                              ? () => saveValue(i)
                                              : () => setState(
                                                  () => isEditing[i] = true),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Guest Max',
                                        style: GoogleFonts.montserrat(
                                          fontSize: maximumDimension * 0.015,
                                          fontWeight: FontWeight.w500,
                                          color: MyColors.Yellow,
                                        ),
                                      ),
                                      Text(
                                        widget.values[i].split('-')[1],
                                        style: GoogleFonts.montserrat(
                                          fontSize: maximumDimension * 0.015,
                                          fontWeight: FontWeight.w400,
                                          color: MyColors.white,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ColoredButton(
                                          width: screenWidth * 0.4,
                                          textSize: maximumDimension * 0.015,
                                          text:
                                              isEditGuestMax ? "Save" : "Edit",
                                          onPressed: isEditGuestMax
                                              ? () => saveValue(i)
                                              : () => setState(() {
                                                    isEditing[i] = true;
                                                    isEditGuestMax = true;
                                                  }),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            else if (isEditGuestMax)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Guest Min',
                                        style: GoogleFonts.montserrat(
                                          fontSize: maximumDimension * 0.015,
                                          fontWeight: FontWeight.w500,
                                          color: MyColors.Yellow,
                                        ),
                                      ),
                                      Text(
                                        widget.values[i].split('-')[0],
                                        style: GoogleFonts.montserrat(
                                          fontSize: maximumDimension * 0.015,
                                          fontWeight: FontWeight.w400,
                                          color: MyColors.white,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ColoredButton(
                                          width: screenWidth * 0.4,
                                          textSize: maximumDimension * 0.015,
                                          text:
                                              isEditGuestMin ? "Save" : "Edit",
                                          onPressed: isEditGuestMin
                                              ? () => saveValue(i)
                                              : () => setState(() {
                                                    isEditing[i] = true;
                                                    isEditGuestMin = true;
                                                  }),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Guest Max',
                                        style: GoogleFonts.montserrat(
                                          fontSize: maximumDimension * 0.015,
                                          fontWeight: FontWeight.w500,
                                          color: MyColors.Yellow,
                                        ),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: screenWidth * 0.4,
                                        ),
                                        child: TextField(
                                          controller: controllers[
                                              controllers.length - 1],
                                          style: GoogleFonts.montserrat(
                                            fontSize: maximumDimension * 0.015,
                                            color: MyColors.white,
                                          ),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'Enter Guest Max...',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ColoredButton(
                                          width: screenWidth * 0.4,
                                          textSize: maximumDimension * 0.015,
                                          text:
                                              isEditGuestMax ? "Save" : "Edit",
                                          onPressed: isEditGuestMax
                                              ? () => saveValue(i)
                                              : () => setState(
                                                  () => isEditing[i] = true),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            else
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Guest Min',
                                        style: GoogleFonts.montserrat(
                                          fontSize: maximumDimension * 0.015,
                                          fontWeight: FontWeight.w500,
                                          color: MyColors.Yellow,
                                        ),
                                      ),
                                      Text(
                                        widget.values[i].split('-')[0],
                                        style: GoogleFonts.montserrat(
                                          fontSize: maximumDimension * 0.015,
                                          fontWeight: FontWeight.w400,
                                          color: MyColors.white,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ColoredButton(
                                          width: screenWidth * 0.4,
                                          textSize: maximumDimension * 0.015,
                                          text: isEditing[i] ? "Save" : "Edit",
                                          onPressed: isEditing[i]
                                              ? () => saveValue(i)
                                              : () => setState(() {
                                                    isEditing[i] = true;
                                                    isEditGuestMin = true;
                                                  }),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Guest Max',
                                        style: GoogleFonts.montserrat(
                                          fontSize: maximumDimension * 0.015,
                                          fontWeight: FontWeight.w500,
                                          color: MyColors.Yellow,
                                        ),
                                      ),
                                      Text(
                                        widget.values[i].split('-')[1],
                                        style: GoogleFonts.montserrat(
                                          fontSize: maximumDimension * 0.015,
                                          fontWeight: FontWeight.w400,
                                          color: MyColors.white,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ColoredButton(
                                          width: screenWidth * 0.4,
                                          textSize: maximumDimension * 0.015,
                                          text: isEditing[i] ? "Save" : "Edit",
                                          onPressed: isEditing[i]
                                              ? () => saveValue(i)
                                              : () => setState(() {
                                                    isEditing[i] = true;
                                                    isEditGuestMax = true;
                                                  }),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.headings[i],
                                  style: GoogleFonts.montserrat(
                                    fontSize: maximumDimension * 0.015,
                                    fontWeight: FontWeight.w500,
                                    color: MyColors.Yellow,
                                  ),
                                ),
                                if (isEditing[i])
                                  if (dropdownChoices[i].isNotEmpty)
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText:
                                            'Select ${widget.headings[i]}...',
                                        hintStyle: GoogleFonts.montserrat(
                                            color: MyColors.whiteDarker),
                                      ),
                                      value: widget.values[i].isEmpty
                                          ? null
                                          : widget.values[i],
                                      items: dropdownChoices[i].map((choice) {
                                        return DropdownMenuItem<String>(
                                          value: choice,
                                          child: Text(
                                            choice,
                                            style: GoogleFonts.montserrat(
                                                color: MyColors.white,
                                                fontSize:
                                                    maximumDimension * 0.015,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          controllers[i].text = value ?? '';
                                        });
                                      },
                                    )
                                  else
                                    TextField(
                                      controller: controllers[i],
                                      style: GoogleFonts.montserrat(
                                        fontSize: maximumDimension * 0.015,
                                        color: MyColors.white,
                                      ),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText:
                                            'Enter ${widget.headings[i]}...',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                    )
                                else
                                  Text(
                                    widget.values[i],
                                    style: GoogleFonts.montserrat(
                                      fontSize: maximumDimension * 0.015,
                                      fontWeight: FontWeight.w400,
                                      color: MyColors.white,
                                    ),
                                  ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ColoredButton(
                                    text: isEditing[i] ? "Save" : "Edit",
                                    onPressed: isEditing[i]
                                        ? () => saveValue(i)
                                        : () =>
                                            setState(() => isEditing[i] = true),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  if (widget.headings.length != 0)
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
      return Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.02),
        child: Column(
          children: [
            for (int i = 0; i < widget.headings.length; i++)
              Container(
                margin: EdgeInsets.symmetric(vertical: maximumDimension * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.headings[i],
                      style: GoogleFonts.montserrat(
                        fontSize: maximumDimension * 0.015,
                        fontWeight: FontWeight.w500,
                        color: MyColors.Yellow,
                      ),
                    ),
                    widget.headings[i] == 'portfolio Link'
                        ? InkWell(
                            onTap: () async {
                              if (await canLaunchUrl(
                                  Uri.parse(widget.values[i]))) {
                                await launchUrl(
                                  Uri.parse(widget.values[i]),
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Can not Open Link')));
                              }
                            },
                            child: Icon(
                              Icons.link,
                              size: maximumDimension * 0.03,
                              color: MyColors.white,
                            ),
                          )
                        : Container(
                            width: screenWidth * 0.5,
                            child: Text(
                              widget.values[i],
                              maxLines: 3,
                              softWrap: true,
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                fontSize: maximumDimension * 0.015,
                                fontWeight: FontWeight.w400,
                                color: MyColors.white,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            if (widget.headings.length != 0)
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
    }
  }
}
