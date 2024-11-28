import 'package:flutter/material.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/Components/Colored Button.dart';

class CreateAIPackage extends StatefulWidget {
  @override
  _AIPackageScreenState createState() => _AIPackageScreenState();
}

class _AIPackageScreenState extends State<CreateAIPackage> {
  double _currentBudgetValue = 100000;
  double _currentGuestCount = 50;
  bool? _isFlexiblePricing;
  String? _venueType;
  String? _ambiance;
  bool _isPhotographySelected = false;
  bool _isDecorationSelected = false;
  bool _isMusicSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(
                  heading: "",
                  para: "",
                  image: '',
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "Create your AI Package",
                    style: TextStyle(color: MyColors.Yellow, fontSize: 25),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Event Details",
                  style: TextStyle(color: MyColors.Yellow, fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  "What type of event you are planning?",
                  style: TextStyle(color: MyColors.white, fontSize: 18),
                ),
                SizedBox(height: 10),
                MyTextBox(hint: "Type your answer here"),
                SizedBox(height: 10),
                MyDivider(),
                Text("How many guests are you expecting?",
                    style: TextStyle(color: Colors.white)),
                Column(
                  children: [
                    Slider(
                      value: _currentGuestCount,
                      min: 50,
                      max: 500,
                      divisions: 8,
                      onChanged: (double newValue) {
                        setState(() {
                          _currentGuestCount = newValue;
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
                          Text('50', style: TextStyle(color: Colors.white)),
                          Text('500', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
                Text("What is the date of the event?",
                    style: TextStyle(color: Colors.white)),
                SizedBox(height: 20),
                Text(
                  "Budget",
                  style: TextStyle(color: MyColors.Yellow, fontSize: 18),
                ),
                SizedBox(height: 10),
                Text("What is your overall budget for this event?",
                    style: TextStyle(color: Colors.white)),
                Column(
                  children: [
                    Slider(
                      value: _currentBudgetValue,
                      min: 100000,
                      max: 500000,
                      divisions: 8,
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
                              style: TextStyle(color: Colors.white)),
                          Text('500,000',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
                Text("Are you open to flexible pricing options?",
                    style: TextStyle(color: Colors.white)),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title:
                            Text("Yes", style: TextStyle(color: Colors.white)),
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
                        title:
                            Text("No", style: TextStyle(color: Colors.white)),
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
                  style: TextStyle(
                      color: MyColors.Yellow,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "In which city or area would you like to hold the event?",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                MyTextBox(hint: "Type your answer here"),
                SizedBox(height: 20),
                Text(
                  "What type of venue do you prefer?",
                  style: TextStyle(color: Colors.white),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text("Indoor",
                            style: TextStyle(color: Colors.white)),
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
                            style: TextStyle(color: Colors.white)),
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
                            style: TextStyle(color: Colors.white)),
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
                  style: TextStyle(color: Colors.white),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text("Casual",
                            style: TextStyle(color: Colors.white)),
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
                            style: TextStyle(color: Colors.white)),
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
                            style: TextStyle(color: Colors.white)),
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
                  style: TextStyle(
                      color: MyColors.Yellow,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "Do you need any additional services?",
                  style: TextStyle(color: Colors.white),
                ),
                Column(
                  children: [
                    CheckboxListTile(
                      title: Text("Photography",
                          style: TextStyle(color: Colors.white)),
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
                          style: TextStyle(color: Colors.white)),
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
                      title:
                          Text("Music", style: TextStyle(color: Colors.white)),
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
                  style: TextStyle(color: Colors.white),
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
        ),
      ),
    );
  }
}
