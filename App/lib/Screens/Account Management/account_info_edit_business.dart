import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/core/models/business_data_model.dart';
import 'package:taqreeb/core/providers/business_edit_info_view_model.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_description.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/utils/color.dart';

class BusinessInfoEdit extends StatefulWidget {
  const BusinessInfoEdit({super.key});

  @override
  State<BusinessInfoEdit> createState() => _BusinessInfoEditState();
}

class _BusinessInfoEditState extends State<BusinessInfoEdit> {
  GlobalKey headerKey = GlobalKey();
  late BusinessInfoEditViewModel viewModel;
  late BusinessData businessData;
  bool _initialLoadComplete = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = Provider.of<BusinessInfoEditViewModel>(context);
    businessData = Provider.of<BusinessData>(context);

    // Initialize with current data if not already loaded
    if (viewModel.nameController.text.isEmpty &&
        businessData.businessInfo.isNotEmpty) {
      viewModel.initializeWithBusinessData();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UI_Management.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          if (mounted) {
            setState(() {
              UI_Management.headerHeight = renderbox.size.height;
            });
          }
        },
      );

      final viewModel =
          Provider.of<BusinessInfoEditViewModel>(context, listen: false);
      final businessData = Provider.of<BusinessData>(context, listen: false);

      // Only fetch if we don't have data
      if (businessData.businessInfo.isEmpty) {
        await viewModel.fetchData(context);
      }
      if (mounted) {
        setState(() {
          _initialLoadComplete = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          Consumer2<BusinessInfoEditViewModel, BusinessData>(
            builder: (context, viewModel, businessData, child) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: UI_Management.headerHeight),
                    if (!_initialLoadComplete)
                      Center(
                          child:
                              CircularProgressIndicator(color: MyColors.white))
                    else
                      _buildContent(viewModel, businessData),
                  ],
                ),
              );
            },
          ),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
              heading: "Edit Your Business Info",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
      BusinessInfoEditViewModel viewModel, BusinessData businessData) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: Screen.max(context) * 0.04,
            horizontal: Screen.max(context) * 0.02,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: viewModel.selectedImage != null
                    ? FileImage(viewModel.selectedImage!)
                    : (businessData.profileImageUrl != null
                            ? NetworkImage(businessData.profileImageUrl!)
                            : AssetImage('assets/images/default_profile.png'))
                        as ImageProvider,
              ),
              Container(
                margin: EdgeInsets.only(left: Screen.max(context) * 0.02),
                child: InkWell(
                  onTap: () => viewModel.pickImage(context),
                  child: Text(
                    "Change Profile Picture",
                    style: GoogleFonts.montserrat(
                      decoration: TextDecoration.underline,
                      fontSize: Screen.max(context) * 0.015,
                      fontWeight: FontWeight.w400,
                      color: MyColors.Yellow,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            MyTextBox(
              focusNode: FocusNode(),
              onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
              hint: 'Business Name',
              valueController: viewModel.nameController,
            ),
            DescriptionBox(
              onChanged: (value) {},
              focusNode: FocusNode(),
              onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
              valueController: viewModel.descriptionController,
            ),
          ],
        ),
        SizedBox(
            height: Screen.height(context) * 0.1,
            child: Center(child: MyDivider())),
        ColoredButton(
          text: 'Save',
          onPressed: () {
            WarningDialog(
              title: 'Save Changes',
              message: 'Are you sure you want to save the changes?',
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await viewModel.uploadProfilePicture(context);
                  },
                  child: Text('Save'),
                ),
              ],
            ).showDialogBox(context);
          },
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
