import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/tokens.dart';
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
  FocusNode cnicFocusNode = FocusNode();
  FocusNode profileNameFocusNode = FocusNode();
  FocusNode usernameFocusNode = FocusNode();

  bool isLoading = true;
  List<String> usernames = [];
  String usernameValidationMessage = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      check(context);
      _getHeaderHeight();
    });
    fetchdata();
    usernameController.addListener(() {
      validateUsername();
    });
  }


  @override
  void dispose() {
    // Dispose controllers and focus nodes
    cnicController.dispose();
    profileNameController.dispose();
    usernameController.dispose();
    cnicFocusNode.dispose();
    profileNameFocusNode.dispose();
    usernameFocusNode.dispose();
    super.dispose();
  }

  void validateUsername() {
    final enteredUsername = usernameController.text.trim();
    if (enteredUsername.isNotEmpty && usernames.contains(enteredUsername)) {
      setState(() {
        usernameValidationMessage = 'This username is already used.';
      });
    } else {
      setState(() {
        usernameValidationMessage = ''; // Clear message if valid
      });
    }
  }

  void fetchdata() async {
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";

    final fetchusernames = await MyApi.getRequest(
      endpoint: 'getUsernames/business/',
      headers: {'Authorization': 'Bearer $token'},
      //  headers: {
      //   'Authorization': 'Bearer $token',
      // }
    );
    setState(() {
      this.usernames =
          fetchusernames['businessUsernames'].cast<String>().toList() ??
              []; // Ensure no null data
      isLoading = false; // Data has been fetched, so stop loading
    });
  }

  void check(BuildContext context) async {
    if (await MyStorage.exists(MyTokens.bscnic) &&
        await MyStorage.exists(MyTokens.bsusername) &&
        await MyStorage.exists(MyTokens.bsname)) {
      warningDialog(
        title: 'Fresh Start',
        message:
            'We noticed that you had lately attempted to do Business Signup in the app Do you want to continue where you left or want a Fresh Start?',
        actions: [
          ColoredButton(
            text: 'Fresh Start',
            onPressed: () {
              MyStorage.deleteToken(MyTokens.bscnic);
              MyStorage.deleteToken(MyTokens.bsname);
              MyStorage.deleteToken(MyTokens.bsusername);
              MyStorage.deleteToken(MyTokens.bsfront);
              MyStorage.deleteToken(MyTokens.bsback);
              MyStorage.deleteToken(MyTokens.bsdescription);

              Navigator.pop(context);
            },
          ),
          ColoredButton(
            text: 'Continue',
            onPressed: () async {
              if (await MyStorage.exists(MyTokens.bsdescription)) {
                Navigator.pushNamed(context, '/ProfilePictureUpload',
                    arguments: {'type': 'Business'});
              } else if (await MyStorage.exists(MyTokens.bsfront)) {
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

  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  void _getHeaderHeight() {
    final RenderObject? renderBox =
        _headerKey.currentContext?.findRenderObject();

    if (renderBox is RenderBox) {
      setState(() {
        _headerHeight = renderBox.size.height;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    _getHeaderHeight();

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: (screenHeight * 0.05) + _headerHeight,
                ),
                MyTextBox(
                 
                  
                  hint: 'CNIC',
                  focusNode: cnicFocusNode,
                  isNum: true,
                  valueController: cnicController,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(profileNameFocusNode);
                  },
                ),
                MyTextBox(
                  hint: 'Profile Name',
                  focusNode: profileNameFocusNode,
                  valueController: profileNameController,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(usernameFocusNode);
                  },
                ),
                MyTextBox(
                  hint: 'Username',
                  focusNode: usernameFocusNode,
                  onFieldSubmitted: (_) {},
                  valueController: usernameController,
                ),
                if (usernameValidationMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      usernameValidationMessage,
                      style: GoogleFonts.montserrat(
                        color: MyColors.red,
                        fontSize: MaximumThing * 0.015,
                      ),
                    ),
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
                        message: Validations.validateUsername(
                            usernameController.text),
                        title: "Invalid Details",
                      ).showDialogBox(context);
                    } else {
                      MyStorage.saveToken(cnicController.text, MyTokens.bscnic);
                      MyStorage.saveToken(profileNameController.text, MyTokens.bsname);
                      MyStorage.saveToken(
                          usernameController.text, MyTokens.bsusername);
                      Navigator.pushNamed(
                          context, '/BusinessSignup_CNICUpload');
                    }
                  },
                  text: 'Continue',
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Sign Up',
              para:
                  'Unlock Success with Just One Click - Join Our Community Today!',
              image: MyImages.BusinessSignup,
            ),
          ),
        ],
      ),
    );
  }
}
