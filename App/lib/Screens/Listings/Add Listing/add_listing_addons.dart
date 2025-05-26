import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/utils/color.dart';

class AddCategoryAddons extends StatefulWidget {
  const AddCategoryAddons({super.key});

  @override
  State<AddCategoryAddons> createState() => _AddCategoryAddonsState();
}

class _AddCategoryAddonsState extends State<AddCategoryAddons> {
  final GlobalKey _headerKey = GlobalKey();
  Map<String, dynamic> _args = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs != null) {
      _args = routeArgs as Map<String, dynamic>;
      _args['addons'] ??= []; // Initialize addons if null
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UImanagement.getHeaderHeight(
        headerKey: _headerKey,
        callback: _updateHeaderHeight,
      );
    });
  }

  void _updateHeaderHeight(RenderBox renderbox) {
    setState(() {
      UImanagement.headerHeight = renderbox.size.height;
    });
  }

  void _navigateToAddAddon() {
    context.pushNamedTransition(
      routeName: '/AddCategory_Add_Addons',
      type: PageTransitionType.rightToLeftWithFade,
      duration: Duration(milliseconds: 300),
      arguments: _args,
    );
  }

  void _navigateToPackages() {
    context.pushNamedTransition(
      routeName: '/AddCategory_Packages',
      type: PageTransitionType.rightToLeftWithFade,
      duration: Duration(milliseconds: 300),
      arguments: _args,
    );
  }

  @override
  Widget build(BuildContext context) {
    UImanagement.getHeaderHeight(
      headerKey: _headerKey,
      callback: _updateHeaderHeight,
    );
    final colors = AppColors(context);

    return Scaffold(
      backgroundColor: colors.dark,
      body: Stack(
        children: [
          _buildContent(),
          _buildContinueButton(),
          _buildHeader(),
        ],
      ),
      floatingActionButton: _buildAddButton(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Container(
        width: Screen.width(context),
        margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.02),
        constraints: BoxConstraints(minHeight: Screen.height(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: UImanagement.headerHeight),
            _buildTitle(),
            _buildAddonsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final colors = AppColors(context);

    return Container(
      width: Screen.width(context) * 0.9,
      margin: EdgeInsets.all(Screen.max(context) * 0.01),
      child: Text(
        textAlign: TextAlign.start,
        "Add-Ons",
        style: GoogleFonts.roboto(
          fontSize: Screen.max(context) * 0.025,
          fontWeight: FontWeight.w700,
          color: colors.red,
        ),
      ),
    );
  }

  Widget _buildAddonsList() {
    final colors = AppColors(context);

    return Container(
      width: Screen.width(context) * 0.9,
      margin: EdgeInsets.all(Screen.max(context) * 0.01),
      padding: EdgeInsets.all(Screen.max(context) * 0.02),
      decoration: BoxDecoration(
        color: colors.darkLighter,
        borderRadius: BorderRadius.circular(20),
      ),
      child: _args['addons']?.isNotEmpty ?? false
          ? Wrap(
              spacing: Screen.width(context) * 0.02,
              runSpacing: Screen.max(context) * 0.015,
              children: _args['addons']
                  .map<Widget>((addon) => SizedBox(
                        width: (Screen.width(context) * 0.9 -
                                Screen.width(context) * 0.02) /
                            2, // Adjusted for spacing
                        child: _buildAddonItem(addon),
                      ))
                  .toList(),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildAddonItem(Map<String, dynamic> addon) {
    final colors = AppColors(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: Screen.width(context) * 0.01),
      padding: EdgeInsets.all(Screen.max(context) * 0.015),
      decoration: BoxDecoration(
        color: colors.darkLighter.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            addon['name'],
            style: GoogleFonts.roboto(
              fontSize: Screen.max(context) * 0.02,
              fontWeight: FontWeight.w600,
              color: colors.white,
            ),
          ),
          SizedBox(height: Screen.max(context) * 0.01),
          Text(
            'Rs. ${(addon['perhead'].toLowerCase() == 'yes' ? '${addon['price']}/${addon['headtype']}' : addon['price'])}',
            style: GoogleFonts.roboto(
              fontSize: Screen.max(context) * 0.015,
              fontWeight: FontWeight.w400,
              color: colors.whiteDarker,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return Positioned(
      bottom: Screen.max(context) * 0.02,
      left: Screen.width(context) * 0.25,
      right: Screen.width(context) * 0.25,
      child: ColoredButton(
        text: 'Continue',
        width: Screen.width(context) * 0.5,
        onPressed: _navigateToPackages,
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 0,
      child: Header(
        key: _headerKey,
        heading: 'Add AddOns',
        para: 'Add AddOns for your Service',
      ),
    );
  }

  Widget _buildAddButton() {
    final colors = AppColors(context);

    return Container(
      margin: EdgeInsets.all(Screen.max(context) * 0.02),
      child: FloatingActionButton(
        backgroundColor: colors.red,
        shape: CircleBorder(),
        onPressed: _navigateToAddAddon,
        child: Icon(
          FontAwesomeIcons.plus,
          color: colors.white,
          size: Screen.max(context) * 0.03,
        ),
      ),
    );
  }
}
