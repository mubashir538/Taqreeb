import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/images.dart';

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
                        Navigator.pushReplacementNamed(
                            context, '/CreateGuestList_AddPerson',
                            arguments: args);
                      }),
                  ColoredButton(
                      text: 'Add Family',
                      width: width * 0.4,
                      textSize: maxThing * 0.015,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(
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
    double maxThing = Screen.width(context) > Screen.height(context)
        ? Screen.width(context)
        : Screen.height(context);
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Row(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minHeight: Screen.height(context)),
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
        onPressed: () => _showOptions(context, maxThing, Screen.width(context)),
        child: Icon(
          Icons.add,
          color: MyColors.Dark,
          size: maxThing * 0.04,
        ),
      ),
    );
  }
}
