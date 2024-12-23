import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/dropdown.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/Screens/Create%20AI%20Package/Components/radio%20button%20question.dart';
import 'package:taqreeb/theme/color.dart';

class AddcategoryAddaddons extends StatefulWidget {
  AddcategoryAddaddons({super.key});

  @override
  State<AddcategoryAddaddons> createState() => _AddcategoryAddaddonsState();
}

class _AddcategoryAddaddonsState extends State<AddcategoryAddaddons> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController perheadController = TextEditingController();
  TextEditingController headtypeController = TextEditingController();
  bool isPerhead = false;
  Map<String, dynamic> args = {};
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    this.args = args;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              heading: 'Add AddOns',
            ),
            MyTextBox(
              hint: 'Name',
              valueController: nameController,
            ),
            MyTextBox(
              hint: 'Price',
              valueController: priceController,
            ),
            RadioButtonQuestion(
                options: ['Yes', 'No'],
                question: '',
                myValue: perheadController.text,
                onChanged: (value) {
                  setState(() {
                    perheadController.text = value.toString();
                    if (value == 'Yes') {
                      isPerhead = true;
                    } else {
                      isPerhead = false;
                    }
                  });
                }),
            isPerhead
                ? MyTextBox(
                    hint: 'Head Type', valueController: headtypeController)
                : Container(),
            SizedBox(
              height: screenHeight * 0.1,
              child: Center(child: MyDivider()),
            ),
            ColoredButton(
                text: 'Add',
                onPressed: () {
                  if (nameController.text.isEmpty ||
                      priceController.text.isEmpty ||
                      perheadController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please fill all the fields'),
                        backgroundColor: MyColors.DarkLighter));
                    return;
                  }
                  if (isPerhead && headtypeController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please fill all the fields'),
                        backgroundColor: MyColors.DarkLighter));
                    return;
                  }
                  args['addons'].add({
                    'name': nameController.text,
                    'price': priceController.text,
                    'perhead': perheadController.text,
                    'headtype': headtypeController.text
                  });

                  Navigator.popAndPushNamed(context, '/AddCategory_Addons',
                      arguments: args);
                })
          ],
        ),
      ),
    );
  }
}
