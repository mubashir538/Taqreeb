import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/dropdown.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';

class AddcategoryList extends StatefulWidget {
  const AddcategoryList({super.key});

  @override
  State<AddcategoryList> createState() => _AddcategoryListState();
}

class _AddcategoryListState extends State<AddcategoryList> {
  TextEditingController nameController = TextEditingController();
  int charactersleft = 1100;
  TextEditingController locationController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  String token = '';
  Map<String, dynamic> categories = {}; // Initialize as empty map
  bool isLoading = true; // Add a loading flag

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
    fetchCategories();
  }

  void fetchCategories() async {
    final token = await MyStorage.getToken('accessToken') ?? '';
    final categories = await MyApi.getRequest(
      endpoint: 'home/categories/',
      //  headers: {'Authorization': 'Bearer $token'}
    );
    setState(() {
      this.token = token;
      this.categories = categories ?? {}; // Ensure no null data
      isLoading = false; // Data has been fetched, so stop loading
    });
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
              children: [
                SizedBox(height: _headerHeight),
                MyTextBox(
                  hint: 'Name',
                  valueController: nameController,
                ),
                Container(
                  margin: EdgeInsets.all(MaximumThing * 0.01),
                  height: screenHeight * 0.3,
                  width: screenWidth * 0.9,
                  padding: EdgeInsets.symmetric(
                      horizontal: MaximumThing * 0.03,
                      vertical: MaximumThing * 0.02),
                  decoration: BoxDecoration(
                    color: MyColors.DarkLighter,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: Offset(2, 2))
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        charactersleft = 1100 - value.length;
                      });
                    },
                    maxLines: 50,
                    style: GoogleFonts.montserrat(
                        color: MyColors.white,
                        fontSize: MaximumThing * 0.015,
                        fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.montserrat(
                        color: MyColors.white.withOpacity(0.6),
                        fontSize: MaximumThing * 0.015,
                        fontWeight: FontWeight.w300,
                      ),
                      hintText: "Enter Description",
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${charactersleft} characters left",
                        style: GoogleFonts.montserrat(
                          color: MyColors.white,
                          fontSize: MaximumThing * 0.015,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                MyTextBox(
                  hint: 'Location',
                  valueController: locationController,
                ),
                ResponsiveDropdown(
                    items: isLoading
                        ? []
                        : categories['categories']
                            .map((value) {
                              return value['name'].toString();
                            })
                            .cast<String>()
                            .toList(),
                    labelText: 'Category',
                    onChanged: (value) {
                      typeController.text = value;
                    }),
                SizedBox(
                  height: screenHeight * 0.1,
                  child: Center(child: MyDivider()),
                ),
                ColoredButton(
                  text: 'Continue',
                  onPressed: () {
                    if (nameController.text.isEmpty ||
                        locationController.text.isEmpty ||
                        typeController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please fill all the fields'),
                      ));
                      return;
                    }
                    if (charactersleft > 1050) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Description is too Short'),
                      ));
                      return;
                    }
                    if (charactersleft < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Description is too Long'),
                      ));
                      return;
                    }
                    Map<String, dynamic> args = {
                      'name': nameController.text,
                      'description': nameController.text,
                      'location': locationController.text,
                      'category': typeController.text
                    };
                    Navigator.pushNamed(context, '/AddCategory_MoreDetails',
                        arguments: args);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Add Service',
              para: 'Add your Services or Halls in the Application',
            ),
          ),
        ],
      ),
    );
  }
}
