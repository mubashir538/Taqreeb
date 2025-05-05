import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_description.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class FreelancerSignupDescriptionViewModel with ChangeNotifier {
  int _charactersLeft = 1100;
  final TextEditingController _descriptionController = TextEditingController();

  int get charactersLeft => _charactersLeft;
  TextEditingController get descriptionController => _descriptionController;

  void updateCharactersLeft(String value) {
    _charactersLeft = 1100 - value.length;
    notifyListeners();
  }

  bool validateDescription() {
    if (_descriptionController.text.isEmpty) {
      return false;
    } else if (_descriptionController.text.length > 1100) {
      return false;
    } else if (_descriptionController.text.length < 50) {
      return false;
    }
    return true;
  }

  void saveDescription(BuildContext context) {
    if (!validateDescription()) {
      MyScaffold(
        text: _descriptionController.text.isEmpty
            ? 'Please Enter a Description'
            : _descriptionController.text.length > 1100
                ? 'Description should be less than 1100 characters'
                : 'Description should be more than 50 characters',
      ).show(context);
      return;
    }

    MyStorage.saveToken(_descriptionController.text, MyTokens.fsdescription);
    Navigator.pushNamed(
      context,
      '/ProfilePictureUpload',
      arguments: {'type': 'Freelancer'},
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}

class FreelancerSignupDescription extends StatefulWidget {
  const FreelancerSignupDescription({super.key});

  @override
  State<FreelancerSignupDescription> createState() =>
      FreelancerSignupDescriptionState();
}

class FreelancerSignupDescriptionState
    extends State<FreelancerSignupDescription> {
  GlobalKey headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UImanagement.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          setState(() {
            UImanagement.headerHeight = renderbox.size.height;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<FreelancerSignupDescriptionViewModel>(context);

    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: Screen.width(context),
              child: Column(
                children: [
                  SizedBox(
                    height: (Screen.max(context) * 0.05) +
                        UImanagement.headerHeight,
                  ),
                  DescriptionBox(
                    valueController: viewModel.descriptionController,
                    onChanged: (value) {
                      viewModel.updateCharactersLeft(value);
                    },
                  ),
                  SizedBox(
                    width: Screen.width(context) * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${viewModel.charactersLeft.toString()} characters left",
                          style: GoogleFonts.montserrat(
                            color: MyColors.white,
                            fontSize: Screen.max(context) * 0.018,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Screen.height(context) * 0.05,
                    child: MyDivider(),
                  ),
                  ColoredButton(
                    text: "Continue",
                    onPressed: () {
                      viewModel.saveDescription(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
              heading: "Create A Description",
              para:
                  "Your Description Creates a Great Impact on the customers and can help your get more clients ",
            ),
          ),
        ],
      ),
    );
  }
}
