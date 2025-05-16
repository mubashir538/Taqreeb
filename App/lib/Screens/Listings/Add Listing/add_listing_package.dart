import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/c_package_box.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/utils/color.dart';

class AddCategoryPackages extends StatefulWidget {
  const AddCategoryPackages({super.key});

  @override
  State<AddCategoryPackages> createState() => _AddCategoryPackagesState();
}

class _AddCategoryPackagesState extends State<AddCategoryPackages> {
  final GlobalKey _headerKey = GlobalKey();
  Map<String, dynamic> _args = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs != null) {
      _args = routeArgs as Map<String, dynamic>;
      _args['packages'] ??= []; // Initialize packages if null
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
    setState(() => UImanagement.headerHeight = renderbox.size.height);
  }

  void _navigateToAddPackage() {
    Navigator.pushNamed(
      context,
      '/AddCategory_AddPackage',
      arguments: _args,
    );
  }

  void _navigateToAddImage() {
    Navigator.pushNamed(
      context,
      '/AddCategoryProducts',
      arguments: _args,
    );
  }

  @override
  Widget build(BuildContext context) {
    UImanagement.getHeaderHeight(
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
        constraints: BoxConstraints(minHeight: Screen.height(context)),
        width: Screen.width(context),
        child: Column(
          children: [
            SizedBox(
              height:
                  (Screen.height(context) * 0.03) + UImanagement.headerHeight,
            ),
            _buildTitle(),
            _buildPackagesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      width: Screen.width(context) * 0.9,
      margin: EdgeInsets.all(Screen.max(context) * 0.01),
      child: Text(
        textAlign: TextAlign.start,
        "Packages",
        style: GoogleFonts.roboto(
          fontSize: Screen.max(context) * 0.025,
          fontWeight: FontWeight.w700,
          color: MyColors.red,
        ),
      ),
    );
  }

  Widget _buildPackagesList() {
    return _args['packages']?.isNotEmpty ?? false
        ? Column(
            children: _args['packages']
                .map<Widget>((package) => _buildPackageItem(package))
                .toList(),
          )
        : const SizedBox.shrink();
  }

  Widget _buildPackageItem(Map<String, dynamic> package) {
    return PackageBox(
      onPressed: () {},
      imageUrl: package['images'][0],
      packageDetails: package['details'],
      packagePrice: package['price'],
      packageName: package['name'],
    );
  }

  Widget _buildContinueButton() {
    return Positioned(
      bottom: Screen.height(context) * 0.02,
      left: Screen.width(context) * 0.25,
      right: Screen.width(context) * 0.25,
      child: ColoredButton(
        text: 'Continue',
        width: Screen.width(context) * 0.5,
        onPressed: _navigateToAddImage,
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 0,
      child: Header(
        key: _headerKey,
        heading: 'Service Packages',
        para: 'Add packages for your service',
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      margin: EdgeInsets.all(Screen.max(context) * 0.02),
      child: FloatingActionButton(
        backgroundColor: MyColors.red,
        shape: CircleBorder(),
        onPressed: _navigateToAddPackage,
        child: Icon(
          FontAwesomeIcons.plus,
          color: MyColors.white,
          size: Screen.max(context) * 0.03,
        ),
      ),
    );
  }
}
