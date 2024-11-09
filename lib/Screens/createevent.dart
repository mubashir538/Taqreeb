import 'package:flutter/material.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  double _currentBudgetValue = 100000; // Initial value for the slider

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                heading: "Create Event",
                para: "Plan your event effortlessly!",
                image: 'assets/images/signuppng.svg',
              ),
              SizedBox(height: 20),
              MyTextBox(hint: "Event Name"),
              SizedBox(height: 10),
              MyTextBox(hint: "Event Type"),
              SizedBox(height: 10),
              MyTextBox(hint: "Set Date"),
              SizedBox(height: 10),
              MyTextBox(hint: "Location"),
              SizedBox(height: 20),
              Text(
                'Describe Your Event',
                style: TextStyle(
                  color: MyColors.Yellow,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 150.0,
                child: MyTextBox(
                  hint: "Enter Description",
                ),
              ),
              SizedBox(height: 40),
              Text(
                "Guest List",
                style: TextStyle(color: MyColors.Yellow, fontSize: 16),
              ),
              SizedBox(height: 10),
              MyTextBox(hint: "Name"),
              SizedBox(height: 10),
              MyTextBox(hint: "Contact"),
              Align(
                alignment: Alignment.centerRight,
                child: SvgPicture.asset(
                  'assets/icons/add.svg',
                  color: MyColors.white,
                  width: 24.0,
                  height: 24.0,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Budget",
                style: TextStyle(color: MyColors.Yellow, fontSize: 16),
              ),
              SizedBox(height: 10),
              MyTextBox(hint: "Enter Budget"),
              SizedBox(height: 20),
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
                        Text(
                          '100,000',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '500,000',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ColoredButton(
                text: "Create Event",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
