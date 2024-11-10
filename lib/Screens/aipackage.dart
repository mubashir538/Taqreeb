import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/Components/Colored Button.dart';

class AIPackageScreen extends StatefulWidget {
  @override
  _AIPackageScreenState createState() => _AIPackageScreenState();
}

class _AIPackageScreenState extends State<AIPackageScreen> {
  TextEditingController _dateController = TextEditingController();
  double _currentBudgetValue = 100000;
  double _currentGuestCount = 100;
  bool? _isFlexiblePricing;
  String? _venueType;
  String? _ambiance;
  bool _isPhotographySelected = false;
  bool _isDecorationSelected = false;
  bool _isMusicSelected = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),
            Center(
              child: Container(
                margin: EdgeInsets.only(
                    top: MaximumThing * 0.05, bottom: MaximumThing * 0.03),
                child: Text(
                  "Create your AI Package",
                  style: GoogleFonts.montserrat(
                      color: MyColors.Yellow,
                      fontWeight: FontWeight.w600,
                      fontSize: MaximumThing * 0.03),
                ),
              ),
            ),

            // Heading
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MaximumThing * 0.02,
                  vertical: MaximumThing * 0.02),
              child: Text(
                "Event Details",
                style: GoogleFonts.montserrat(
                    color: MyColors.Yellow,
                    fontWeight: FontWeight.w500,
                    fontSize: MaximumThing * 0.02),
              ),
            ),

            // Normal Question
            NormalQuestion(MaximumThing: MaximumThing),
            SizedBox(
              height: screenHeight * 0.04,
              child: Center(child: MyDivider()),
            ),

            // Slider Question
            Container(
              margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: MaximumThing * 0.02),
                    child: Text("How many guests are you expecting?",
                        style: GoogleFonts.montserrat(
                            color: MyColors.white,
                            fontSize: MaximumThing * 0.018)),
                  ),
                  Slider(
                    value: _currentGuestCount,
                    min: 50,
                    max: 1000,
                    divisions: 19,
                    label: _currentGuestCount.round().toString(),
                    onChanged: (double newValue) {
                      setState(() {
                        _currentGuestCount = newValue;
                      });
                    },
                    activeColor: MyColors.red,
                    inactiveColor: MyColors.whiteDarker,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: MaximumThing * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('50',
                            style: GoogleFonts.montserrat(color: Colors.white)),
                        Text('1000',
                            style: GoogleFonts.montserrat(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Date Question

            Padding(
              padding: EdgeInsets.symmetric(horizontal: MaximumThing * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("What is the date of the event?",
                      style: GoogleFonts.montserrat(
                          color: MyColors.white,
                          fontSize: MaximumThing * 0.018)),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
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
                  )
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MaximumThing * 0.02,
                  vertical: MaximumThing * 0.02),
              child: Text(
                "Budget",
                style: GoogleFonts.montserrat(
                    color: MyColors.Yellow,
                    fontWeight: FontWeight.w500,
                    fontSize: MaximumThing * 0.02),
              ),
            ),

            SizedBox(height: 10),
            Text("What is your overall budget for this event?",
                style: GoogleFonts.montserrat(color: Colors.white)),
            Column(
              children: [
                Slider(
                  value: _currentBudgetValue,
                  min: 100000,
                  max: 500000,
                  divisions: 9,
                  onChanged: (double newValue) {
                    setState(() {
                      _currentBudgetValue = newValue;
                    });
                  },
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('100,000',
                          style: GoogleFonts.montserrat(color: Colors.white)),
                      Text('500,000',
                          style: GoogleFonts.montserrat(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            Text("Are you open to flexible pricing options?",
                style: GoogleFonts.montserrat(color: Colors.white)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: Text("Yes",
                        style: GoogleFonts.montserrat(color: Colors.white)),
                    value: true,
                    groupValue: _isFlexiblePricing,
                    onChanged: (bool? value) {
                      setState(() {
                        _isFlexiblePricing = value;
                      });
                    },
                    activeColor: MyColors.Yellow,
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: Text("No",
                        style: GoogleFonts.montserrat(color: Colors.white)),
                    value: false,
                    groupValue: _isFlexiblePricing,
                    onChanged: (bool? value) {
                      setState(() {
                        _isFlexiblePricing = value;
                      });
                    },
                    activeColor: MyColors.Yellow,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Location Preferences:",
              style: GoogleFonts.montserrat(
                  color: MyColors.Yellow,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "In which city or area would you like to hold the event?",
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
            SizedBox(height: 10),
            MyTextBox(hint: "Type your answer here"),
            SizedBox(height: 20),
            Text(
              "What type of venue do you prefer?",
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text("Indoor",
                        style: GoogleFonts.montserrat(color: Colors.white)),
                    value: "Indoor",
                    groupValue: _venueType,
                    onChanged: (String? value) {
                      setState(() {
                        _venueType = value;
                      });
                    },
                    activeColor: MyColors.Yellow,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text("Outdoor",
                        style: GoogleFonts.montserrat(color: Colors.white)),
                    value: "Outdoor",
                    groupValue: _venueType,
                    onChanged: (String? value) {
                      setState(() {
                        _venueType = value;
                      });
                    },
                    activeColor: MyColors.Yellow,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text("Mixed",
                        style: GoogleFonts.montserrat(color: Colors.white)),
                    value: "Mixed",
                    groupValue: _venueType,
                    onChanged: (String? value) {
                      setState(() {
                        _venueType = value;
                      });
                    },
                    activeColor: MyColors.Yellow,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "What kind of ambiance are you looking for?",
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text("Casual",
                        style: GoogleFonts.montserrat(color: Colors.white)),
                    value: "Casual",
                    groupValue: _ambiance,
                    onChanged: (String? value) {
                      setState(() {
                        _ambiance = value;
                      });
                    },
                    activeColor: MyColors.Yellow,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text("Formal",
                        style: GoogleFonts.montserrat(color: Colors.white)),
                    value: "Formal",
                    groupValue: _ambiance,
                    onChanged: (String? value) {
                      setState(() {
                        _ambiance = value;
                      });
                    },
                    activeColor: MyColors.Yellow,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text("Themed",
                        style: GoogleFonts.montserrat(color: Colors.white)),
                    value: "Themed",
                    groupValue: _ambiance,
                    onChanged: (String? value) {
                      setState(() {
                        _ambiance = value;
                      });
                    },
                    activeColor: MyColors.Yellow,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Entertainment & Extras:",
              style: GoogleFonts.montserrat(
                  color: MyColors.Yellow,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Do you need any additional services?",
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
            Column(
              children: [
                CheckboxListTile(
                  title: Text("Photography",
                      style: GoogleFonts.montserrat(color: Colors.white)),
                  value: _isPhotographySelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _isPhotographySelected = value ?? false;
                    });
                  },
                  activeColor: MyColors.Yellow,
                  checkColor: Colors.black,
                ),
                CheckboxListTile(
                  title: Text("Decoration",
                      style: GoogleFonts.montserrat(color: Colors.white)),
                  value: _isDecorationSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _isDecorationSelected = value ?? false;
                    });
                  },
                  activeColor: MyColors.Yellow,
                  checkColor: Colors.black,
                ),
                CheckboxListTile(
                  title: Text("Music",
                      style: GoogleFonts.montserrat(color: Colors.white)),
                  value: _isMusicSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _isMusicSelected = value ?? false;
                    });
                  },
                  activeColor: MyColors.Yellow,
                  checkColor: Colors.black,
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Would you like a theme for the event?",
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
            SizedBox(height: 10),
            MyTextBox(hint: "Type your answer here"),
            SizedBox(height: 20),
            ColoredButton(
              text: "Generate Packages",
            ),
          ],
        ),
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

class NormalQuestion extends StatelessWidget {
  const NormalQuestion({
    super.key,
    required this.MaximumThing,
  });

  final double MaximumThing;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MaximumThing * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: MaximumThing * 0.01),
            child: Text(
              "What type of event you are planning?",
              style: GoogleFonts.montserrat(
                  color: MyColors.white,
                  fontSize: MaximumThing * 0.018),
            ),
          ),
          MyTextBox(hint: "Type your answer here"),
        ],
      ),
    );
  }
}
