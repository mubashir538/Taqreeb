import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/c_package_box.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/color.dart';

class AddcategoryPackages extends StatefulWidget {
  const AddcategoryPackages({super.key});

  @override
  State<AddcategoryPackages> createState() => _AddcategoryPackagesState();
}

class _AddcategoryPackagesState extends State<AddcategoryPackages> {
  Map<String, dynamic> args = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    this.args = args;
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
  }

  @override
  Widget build(BuildContext context) {
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minHeight: Screen.height(context)),
              width: Screen.width(context),
              child: Column(
                children: [
                  SizedBox(
                      height: (Screen.height(context) * 0.03) + _headerHeight),
                  Container(
                    margin: EdgeInsets.all(Screen.max(context) * 0.01),
                    child: Text(
                      "Packages",
                      style: GoogleFonts.montserrat(
                        fontSize: Screen.max(context) * 0.025,
                        fontWeight: FontWeight.w600,
                        color: MyColors.Yellow,
                      ),
                    ),
                  ),
                  args['packages'] != null
                      ? Column(
                          children: [
                            ...args['packages'].map<Widget>((package) {
                              return PackageBox(
                                  packagedetails: package['details'],
                                  packageprice: package['price'],
                                  packagename: package['name']);
                            }).toList(),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: Screen.height(context) * 0.02,
            left: Screen.width(context) * 0.25,
            right: Screen.width(context) * 0.25,
            child: ColoredButton(
                text: 'Continue',
                width: Screen.width(context) * 0.5,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/AddCategory_AddImage',
                    arguments: args,
                  );
                }),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Service Packages',
              para: 'Add packages for your service',
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.Yellow,
        onPressed: () {
          if (args['packages'] == null) {
            args.addAll({'packages': []});
          }
          Navigator.pushNamed(
            context,
            '/AddCategory_AddPackage',
            arguments: args,
          );
        },
        child: Icon(
          Icons.add,
          color: MyColors.Dark,
          size: Screen.max(context) * 0.04,
        ),
      ),
    );
  }
}
