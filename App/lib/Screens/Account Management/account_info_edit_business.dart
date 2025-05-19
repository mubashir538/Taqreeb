import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/core/models/business_data_model.dart';
import 'package:taqreeb/core/providers/business_edit_info_view_model.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_description.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
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
      UImanagement.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          if (mounted) {
            setState(() {
              UImanagement.headerHeight = renderbox.size.height;
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
                    SizedBox(height: UImanagement.headerHeight),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () => viewModel.pickImage(context),
                    child: CircleAvatar(
                      radius: Screen.max(context) * 0.1,
                      backgroundImage: viewModel.selectedImage != null
                          ? FileImage(viewModel.selectedImage!)
                          : (businessData.profileImageUrl != null
                                  ? NetworkImage(businessData.profileImageUrl!)
                                  : AssetImage(
                                      'assets/images/default_profile.png'))
                              as ImageProvider,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => viewModel.pickImage(context),
                      child: Container(
                        padding: EdgeInsets.all(Screen.max(context) * 0.02),
                        decoration: BoxDecoration(
                          color: MyColors.whiteDarker,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          FontAwesomeIcons.pen,
                          size: Screen.max(context) * 0.025,
                          color: MyColors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          children: [
            MyTextBox(
              prefixIcon: FontAwesomeIcons.building,
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
          height: Screen.max(context) * 0.02,
        ),
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
