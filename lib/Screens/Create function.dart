import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/Selection%20Dialog.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/images.dart';

class CreateFunction extends StatelessWidget {
  const CreateFunction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
              heading: 'Create Funtion',
              image: MyImages.Function,
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                MyTextBox(hint: 'Funtion Name'),
                MyTextBox(hint: 'Budget'),
                MyTextBox(hint: "Event Type"),
                Row(
                  children: [
                    SizedBox(
                      width: 190,
                    ),
                    SelectionDialog(),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                ColoredButton(text: 'Add Funtion'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
