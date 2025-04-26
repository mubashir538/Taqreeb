import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      UI_Management.getHeaderHeight(
        headerKey: _headerKey,
        callback: _updateHeaderHeight,
      );
    });
  }

  void _updateHeaderHeight(RenderBox renderbox) {
    setState(() {
      UI_Management.headerHeight = renderbox.size.height;
    });
  }

  void _navigateToAddAddon() {
    Navigator.pushNamed(
      context,
      '/AddCategory_Add_Addons',
      arguments: _args,
    );
  }

  void _navigateToPackages() {
    Navigator.pushNamed(
      context,
      '/AddCategory_Packages',
      arguments: _args,
    );
  }

  @override
  Widget build(BuildContext context) {
    UI_Management.getHeaderHeight(
      headerKey: _headerKey,
      callback: _updateHeaderHeight,
    );

    return Scaffold(
      backgroundColor: MyColors.dark,
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
            SizedBox(height: UI_Management.headerHeight),
            _buildTitle(),
            _buildAddonsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.all(Screen.max(context) * 0.01),
      child: Text(
        "Add-Ons",
        style: GoogleFonts.montserrat(
          fontSize: Screen.max(context) * 0.025,
          fontWeight: FontWeight.w600,
          color: MyColors.Yellow,
        ),
      ),
    );
  }

  Widget _buildAddonsList() {
    return Container(
      margin: EdgeInsets.all(Screen.width(context) * 0.01),
      width: Screen.width(context) * 0.9,
      padding: EdgeInsets.symmetric(
        horizontal: Screen.width(context) * 0.03,
        vertical: Screen.height(context) * 0.02,
      ),
      decoration: BoxDecoration(
        color: MyColors.DarkLighter,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(102),
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: _args['addons']?.isNotEmpty ?? false
          ? Column(
              children: _args['addons']
                  .map<Widget>((addon) => _buildAddonItem(addon))
                  .toList(),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildAddonItem(Map<String, dynamic> addon) {
    return Column(
      children: [
        Container(
          margin:
              EdgeInsets.symmetric(horizontal: Screen.width(context) * 0.02),
          child: Row(
            children: [
              SizedBox(height: Screen.max(context) * 0.01),
              Expanded(
                child: Text(
                  addon['name'],
                  style: GoogleFonts.montserrat(
                    fontSize: Screen.max(context) * 0.015,
                    fontWeight: FontWeight.w400,
                    color: MyColors.Yellow,
                  ),
                ),
              ),
              Text(
                addon['perhead'].toLowerCase() == 'yes'
                    ? '${addon['price']}/${addon['headtype']}'
                    : addon['price'],
                style: GoogleFonts.montserrat(
                  fontSize: Screen.max(context) * 0.015,
                  fontWeight: FontWeight.w400,
                  color: MyColors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Screen.max(context) * 0.01),
      ],
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
    return FloatingActionButton(
      backgroundColor: MyColors.Yellow,
      onPressed: _navigateToAddAddon,
      child: Icon(
        Icons.add,
        color: MyColors.dark,
        size: Screen.max(context) * 0.04,
      ),
    );
  }
}
