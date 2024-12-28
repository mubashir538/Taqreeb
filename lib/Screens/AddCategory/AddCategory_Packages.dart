import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/package%20box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

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
            child: Container(
              constraints: BoxConstraints(minHeight: screenHeight),
              width: screenWidth,
              child: Column(
                children: [
                  SizedBox(height: (screenHeight * 0.03) + _headerHeight),
                  Container(
                    margin: EdgeInsets.all(MaximumThing * 0.01),
                    child: Text(
                      "Packages",
                      style: GoogleFonts.montserrat(
                        fontSize: MaximumThing * 0.025,
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
            // top: screenHeight - (screenHeight * 0.02),
            bottom: screenHeight * 0.02,
            left: screenWidth * 0.25,
            right: screenWidth * 0.25,
            child: ColoredButton(
                text: 'Continue',
                width: screenWidth * 0.5,
                onPressed: () {
                  print(' args: ${args}');
                  Navigator.pushNamed(
                    context,
                    '/AddCategory_AddImage', // Replace with your target screen's route
                    arguments: args, // Passing the args map to the next screen
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
            print(args);
            args.addAll({'packages': []});
          }
          print(' args: ${args}');
          Navigator.pushNamed(
            context,
            '/AddCategory_AddPackage', // Replace with your target screen's route
            arguments: args, // Passing the args map to the next screen
          );
        },
        child: Icon(
          Icons.add,
          color: MyColors.Dark,
          size: MaximumThing * 0.04,
        ),
      ),
    );
  }
}
