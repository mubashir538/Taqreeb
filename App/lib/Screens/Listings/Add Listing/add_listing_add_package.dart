import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Inputs/c_input_description.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class AddCategoryAddPackage extends StatefulWidget {
  const AddCategoryAddPackage({super.key});

  @override
  State<AddCategoryAddPackage> createState() => _AddCategoryAddPackageState();
}

class _AddCategoryAddPackageState extends State<AddCategoryAddPackage> {
  final _formController = PackageFormController();
  final GlobalKey _headerKey = GlobalKey();
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedImages = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _formController.args = args;
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

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  void _updateHeaderHeight(RenderBox renderbox) {
    setState(() {
      UImanagement.headerHeight = renderbox.size.height;
    });
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only select up to 3 images')),
      );
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImages.add(image);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: ${e.toString()}')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _submitForm() {
    if (_formController.nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a package name')),
      );
      return;
    }

    _formController.addPackage(images: _selectedImages);
    context.pushNamedTransition(
      routeName: '/AddCategory_Packages',
      type: PageTransitionType.rightToLeftWithFade,
      duration: Duration(milliseconds: 300),
      arguments: _formController.args,
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
          SingleChildScrollView(
            child: SizedBox(
              width: Screen.width(context),
              child: Column(
                children: [
                  SizedBox(
                    height: (Screen.height(context) * 0.03) +
                        UImanagement.headerHeight,
                  ),
                  _buildNameField(),
                  _buildDetailsField(),
                  _buildPriceField(),
                  _buildImageUploadSection(),
                  SizedBox(
                    height: Screen.height(context) * 0.1,
                    child: const Center(child: MyDivider()),
                  ),
                  _buildSubmitButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Add Packages',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return MyTextBox(
      prefixIcon: FontAwesomeIcons.user,
      focusNode: _formController.nameFocus,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_formController.detailsFocus);
      },
      hint: 'Name',
      valueController: _formController.nameController,
    );
  }

  Widget _buildDetailsField() {
    return DescriptionBox(
      valueController: _formController.detailsController,
      focusNode: _formController.detailsFocus,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_formController.priceFocus);
      },
    );
  }

  Widget _buildPriceField() {
    return MyTextBox(
      prefixIcon: FontAwesomeIcons.moneyBill,
      focusNode: _formController.priceFocus,
      onFieldSubmitted: (_) => _formController.priceFocus.unfocus(),
      hint: 'Price',
      isNum: true,
      isPrice: true,
      valueController: _formController.priceController,
    );
  }

  Widget _buildImageUploadSection() {
    final colors = AppColors(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Images (Max 3)',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (_selectedImages.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(
                                    File(_selectedImages[index].path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: const Icon(
                                  FontAwesomeIcons.xmark,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _pickImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Select Images',
              style: GoogleFonts.roboto(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ColoredButton(
        text: 'Add Package',
        onPressed: _submitForm,
      ),
    );
  }
}

class PackageFormController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode detailsFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();

  Map<String, dynamic> args = {};

  void addPackage({List<XFile> images = const []}) {
    if (!args.containsKey('packages')) {
      args['packages'] = [];
    }

    final newPackage = {
      'name': _capitalize(nameController.text),
      'details': _capitalize(detailsController.text),
      'price': _capitalize(priceController.text),
      'images': images.map((image) => image.path).toList(),
    };

    args['packages'].add(newPackage);

    // Clear form after submission
    nameController.clear();
    detailsController.clear();
    priceController.clear();
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  void dispose() {
    nameController.dispose();
    detailsController.dispose();
    priceController.dispose();
    nameFocus.dispose();
    detailsFocus.dispose();
    priceFocus.dispose();
  }
}
