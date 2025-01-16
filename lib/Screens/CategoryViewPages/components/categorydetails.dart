import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';

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
    controllers = widget.values.map((value) {
      if (value.contains('-')) {
        final parts = value.split('-');
        controllers
            .add(TextEditingController(text: parts[0].trim())); // guestMin
        controllers
            .add(TextEditingController(text: parts[1].trim())); // guestMax
        return TextEditingController(
            text: parts[0].trim()); // Placeholder, won't be used
      } else {
        return TextEditingController(text: value);
      }
    }).toList();
    print(controllers);
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
          choices.add(field['choices']?.isEmpty ?? true
              ? ''
              : ''); // Use blank if no value is available
          dropdownChoices.add(field['choices']?.cast<String>() ?? []);
          isEditing.add(false);
        }
        isLoading = false; // Stop loading once data is fetched
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Handle error - Show a message or take action
    }
  }

  Future<void> saveValue(int index) async {
    setState(() {
      if (widget.values[index].contains('-')) {
        final guestMin = controllers[index * 2].text.trim();
        final guestMax = controllers[index * 2 + 1].text.trim();
        widget.values[index] = '$guestMin-$guestMax';
      } else {
        widget.values[index] = controllers[index].text;
      }
      isEditing[index] = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('${widget.headings[index]} updated successfully!')),
    );
  }

  bool type = false;
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
                          if (widget.values[i].contains('-'))
                            if (isEditing[i])
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
                                      TextField(
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
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ColoredButton(
                                          width: screenWidth * 0.4,
                                          textSize: maximumDimension * 0.015,
                                          text: isEditing[i] ? "Save" : "Edit",
                                          onPressed: isEditing[i]
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
                                      TextField(
                                        controller: controllers[i + 1],
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
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ColoredButton(
                                          width: screenWidth * 0.4,
                                          textSize: maximumDimension * 0.015,
                                          text: isEditing[i] ? "Save" : "Edit",
                                          onPressed: isEditing[i]
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
                                          text: isEditing[i] ? "Save" : "Edit",
                                          onPressed: isEditing[i]
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
                                          widget.values[i] = value ?? '';
                                        });
                                      },
                                    )
                                  // else if (widget.values[i].contains('-'))
                                  //   Row(
                                  //     children: [
                                  //       Expanded(
                                  //         child: TextField(
                                  //           controller:
                                  //               controllers[i], // guestMin
                                  //           keyboardType: TextInputType.number,
                                  //           style: GoogleFonts.montserrat(
                                  //             fontSize:
                                  //                 maximumDimension * 0.015,
                                  //             color: MyColors.white,
                                  //           ),
                                  //           decoration: InputDecoration(
                                  //             border: OutlineInputBorder(),
                                  //             hintText: 'Guest Min',
                                  //             hintStyle:
                                  //                 TextStyle(color: Colors.grey),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //       SizedBox(width: 8.0),
                                  //       Expanded(
                                  //         child: TextField(
                                  //           controller:
                                  //               controllers[i + 1], // guestMax
                                  //           keyboardType: TextInputType.number,
                                  //           style: GoogleFonts.montserrat(
                                  //             fontSize:
                                  //                 maximumDimension * 0.015,
                                  //             color: MyColors.white,
                                  //           ),
                                  //           decoration: InputDecoration(
                                  //             border: OutlineInputBorder(),
                                  //             hintText: 'Guest Max',
                                  //             hintStyle:
                                  //                 TextStyle(color: Colors.grey),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   )
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
                    Container(
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
