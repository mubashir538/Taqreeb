import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            color: MyColors.darkLighter,
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
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minHeight: Screen.height(context)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Header(
                    heading: 'Create Guest List',
                    image: MyImages.guestList,
                  ),
                  Container(
                      margin: EdgeInsets.all(maxThing * 0.02),
                      height: Screen.height(context) * 0.5,
                      child: Center(
                        child: Text(
                          'No Guests Added yet',
                          style: GoogleFonts.roboto(
                              color: MyColors.white, fontSize: maxThing * 0.02),
                        ),
                      )),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: maxThing * 0.02,
            right: maxThing * 0.02,
            child: GestureDetector(
              onTap: () =>
                  _showOptions(context, maxThing, Screen.width(context)),
              child: Container(
                padding: EdgeInsets.all(maxThing * 0.02),
                decoration: BoxDecoration(
                  color: MyColors.red,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(maxThing * 0.05),
                    topRight: Radius.circular(maxThing * 0.05),
                    bottomLeft: Radius.circular(maxThing * 0.05),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: MyColors.white,
                      size: maxThing * 0.035,
                    ),
                    SizedBox(
                      width: Screen.max(context) * 0.01,
                    ),
                    Text(
                      'Add First Guest',
                      style: GoogleFonts.roboto(
                          color: MyColors.white, fontSize: maxThing * 0.015),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
