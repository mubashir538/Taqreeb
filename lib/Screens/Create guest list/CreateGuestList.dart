import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/images.dart';

class CreateGuestList extends StatefulWidget {
  const CreateGuestList({super.key});

  @override
  State<CreateGuestList> createState() => _CreateGuestListState();
}

class _CreateGuestListState extends State<CreateGuestList> {
  Map<String, dynamic> args = {};
  void _showOptions(BuildContext context, double maxThing, double width) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(maxThing * 0.02),
          decoration: BoxDecoration(
            color: MyColors.DarkLighter,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(maxThing * 0.05)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ColoredButton(
                      text: 'Add Person',
                      width: width * 0.4,
                      textSize: maxThing * 0.015,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, '/CreateGuestList_AddPerson',
                            arguments: args);
                      }),
                  ColoredButton(
                      text: 'Add Family',
                      width: width * 0.4,
                      textSize: maxThing * 0.015,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, '/CreateGuestList_AddFamily',
                            arguments: args);
                      }),
                ],
              ),
              SizedBox(height: maxThing * 0.03),
            ],
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    this.args = args;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double maxThing = screenWidth > screenHeight ? screenWidth : screenHeight;
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Row(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Header(
                    heading: 'Create Guest List',
                    image: MyImages.GuestList,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.Yellow,
        onPressed: () => _showOptions(context, maxThing, screenWidth),
        child: Icon(
          Icons.add,
          color: MyColors.Dark,
          size: maxThing * 0.04,
        ),
      ),
    );
  }
}
