import 'package:flutter/material.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/validations.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/Components/warningDialog.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/images.dart';

class BusinessSignup_BasicInfo extends StatefulWidget {
  const BusinessSignup_BasicInfo({super.key});

  @override
  State<BusinessSignup_BasicInfo> createState() =>
      _BusinessSignup_BasicInfoState();
}

class _BusinessSignup_BasicInfoState extends State<BusinessSignup_BasicInfo> {
  TextEditingController cnicController = TextEditingController();
  TextEditingController profileNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      check(context);
    });
  }

  void check(BuildContext context) async {
    if (await MyStorage.exists('bscnic') &&
        await MyStorage.exists('bsusername') &&
        await MyStorage.exists('bsname')) {
      warningDialog(
        title: 'Fresh Start',
        message:
            'We noticed that you had lately attempted to do Business Signup in the app Do you want to continue where you left or want a Fresh Start?',
        actions: [
          ColoredButton(
            text: 'Fresh Start',
            onPressed: () {
              MyStorage.deleteToken('bscnic');
              MyStorage.deleteToken('bsname');
              MyStorage.deleteToken('bsusername');
              MyStorage.deleteToken('bsfront');
              MyStorage.deleteToken('bsback');
              MyStorage.deleteToken('bsdescription');

              Navigator.pop(context);
            },
          ),
          ColoredButton(
            text: 'Continue',
            onPressed: () async {
              if (await MyStorage.exists('bsdescription')) {
                Navigator.pushNamed(context, '/ProfilePictureUpload',
                    arguments: {'type': 'Business'});
              } else if (await MyStorage.exists('bsfront')) {
                Navigator.pushNamed(context, '/BusinessSignup_Description');
              } else {
                Navigator.pushNamed(context, '/BusinessSignup_CNICUpload');
              }
            },
          )
        ],
      ).showDialogBox(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Header(
              heading: 'Sign Up',
              para:
                  'Unlock Success with Just One Click - Join Our Community Today!',
              image: MyImages.BusinessSignup,
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            MyTextBox(
              hint: 'CNIC',
              valueController: cnicController,
            ),
            MyTextBox(
              hint: 'Profile Name',
              valueController: profileNameController,
            ),
            MyTextBox(
              hint: 'Username',
              valueController: usernameController,
            ),
            SizedBox(
              height: screenHeight * 0.1,
              child: Center(child: MyDivider()),
            ),
            ColoredButton(
              onPressed: () {
                if (cnicController.text.isEmpty ||
                    profileNameController.text.isEmpty ||
                    usernameController.text.isEmpty) {
                  warningDialog(
                    message: "Please fill all the details",
                    title: "Invalid Details",
                  ).showDialogBox(context);
                } else if (Validations.validateCNIC(cnicController.text) !=
                    'Ok') {
                  warningDialog(
                    message: Validations.validateCNIC(cnicController.text),
                    title: "Invalid Details",
                  ).showDialogBox(context);
                } else if (Validations.validateUsername(
                        usernameController.text) !=
                    'Ok') {
                  warningDialog(
                    message:
                        Validations.validateUsername(usernameController.text),
                    title: "Invalid Details",
                  ).showDialogBox(context);
                } else {
                  MyStorage.saveToken(cnicController.text, "bscnic");
                  MyStorage.saveToken(profileNameController.text, "bsname");
                  MyStorage.saveToken(usernameController.text, "bsusername");
                  Navigator.pushNamed(context, '/BusinessSignup_CNICUpload');
                }
              },
              text: 'Continue',
            ),
          ],
        ),
      ),
    );
  }
}
