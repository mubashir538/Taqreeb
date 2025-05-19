import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/services/validations.dart';

class BusinessSignupProvider with ChangeNotifier {
  TextEditingController cnicController = TextEditingController();
  TextEditingController profileNameController = TextEditingController();
  FocusNode cnicFocusNode = FocusNode();
  FocusNode profileNameFocusNode = FocusNode();

  // Check if the user has previously attempted signup
  Future<void> checkPreviousSignup(BuildContext context) async {
    if (await MyStorage.exists(MyTokens.bscnic) &&
        await MyStorage.exists(MyTokens.bsusername) &&
        await MyStorage.exists(MyTokens.bsname)) {
      _showWarningDialog(context);
    }
  }

  // Show warning dialog for fresh start or continue
  void _showWarningDialog(BuildContext context) {
    WarningDialog(
      title: 'Fresh Start',
      message:
          'We noticed that you had lately attempted to do Business Signup in the app. Do you want to continue where you left or want a Fresh Start?',
      actions: [
        ColoredButton(
          text: 'Fresh Start',
          onPressed: () {
            _clearStorage();
            Navigator.pop(context);
          },
        ),
        ColoredButton(
          text: 'Continue',
          onPressed: () async {
            if (await MyStorage.exists(MyTokens.bsdescription)) {
              context.pushNamedTransition(
                  routeName: '/ProfilePictureUpload',
                  type: PageTransitionType.rightToLeftWithFade,
                  duration: Duration(milliseconds: 300),
                  arguments: {'type': 'Business'});
            } else if (await MyStorage.exists(MyTokens.bsfront)) {
              context.pushNamedTransition(
                  routeName: '/BusinessSignup_Description',
                  type: PageTransitionType.rightToLeftWithFade,
                  duration: Duration(milliseconds: 300));
            } else {
              context.pushNamedTransition(
                  routeName: '/BusinessSignup_CNICUpload',
                  type: PageTransitionType.rightToLeftWithFade,
                  duration: Duration(milliseconds: 300));
            }
          },
        ),
      ],
    ).showDialogBox(context);
  }

  // Clear storage tokens
  void _clearStorage() {
    MyStorage.deleteToken(MyTokens.bscnic);
    MyStorage.deleteToken(MyTokens.bsname);
    MyStorage.deleteToken(MyTokens.bsusername);
    MyStorage.deleteToken(MyTokens.bsfront);
    MyStorage.deleteToken(MyTokens.bsback);
    MyStorage.deleteToken(MyTokens.bsdescription);
  }

  // Validate and save CNIC and profile name
  void validateAndSave(BuildContext context) {
    if (cnicController.text.isEmpty || profileNameController.text.isEmpty) {
      MyScaffold(text: "Please fill all the details").show(context);
    } else if (Validations.validateCNIC(cnicController.text) != 'Ok') {
      MyScaffold(text: Validations.validateCNIC(cnicController.text))
          .show(context);
    } else {
      MyStorage.saveToken(cnicController.text, MyTokens.bscnic);
      MyStorage.saveToken(profileNameController.text, MyTokens.bsname);
      context.pushNamedTransition(
          routeName: '/BusinessSignup_CNICUpload',
          type: PageTransitionType.rightToLeftWithFade,
          duration: Duration(milliseconds: 300));
    }
  }
}
