import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Inputs/c_input_description.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/utils/color.dart';

class AddCategoryAddProduct extends StatefulWidget {
  const AddCategoryAddProduct({super.key});

  @override
  State<AddCategoryAddProduct> createState() => _AddCategoryAddProductState();
}

class _AddCategoryAddProductState extends State<AddCategoryAddProduct> {
  final _formController = ProductFormController();
  final GlobalKey _headerKey = GlobalKey();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _formController.args = args;
    }
  }

  void _updateHeaderHeight(RenderBox renderbox) {
    setState(() => UI_Management.headerHeight = renderbox.size.height);
  }

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: ${e.toString()}')),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _submitForm() {
    if (_formController.nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a product name')),
      );
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    _formController.addProduct(image: _selectedImage!);
    Navigator.pushNamed(
      context,
      '/AddCategoryProducts', // Adjust this route name as needed
      arguments: _formController.args,
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
          SingleChildScrollView(
            child: SizedBox(
              width: Screen.max(context),
              child: Column(
                children: [
                  SizedBox(
                      height: Screen.max(context) * 0.02 +
                          UI_Management.headerHeight),
                  _buildNameField(),
                  _buildDescriptionField(),
                  _buildPriceField(),
                  _buildImageUploadSection(),
                  SizedBox(height: Screen.max(context) * 0.05),
                  _buildSubmitButton(),
                  SizedBox(height: Screen.max(context) * 0.02),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Add Product',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return MyTextBox(
      focusNode: _formController.nameFocus,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_formController.descriptionFocus);
      },
      hint: 'Product Name',
      valueController: _formController.nameController,
    );
  }

  Widget _buildDescriptionField() {
    return DescriptionBox(
      valueController: _formController.descriptionController,
      focusNode: _formController.descriptionFocus,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_formController.priceFocus);
      },
    );
  }

  Widget _buildPriceField() {
    return MyTextBox(
      focusNode: _formController.priceFocus,
      onFieldSubmitted: (_) => _formController.priceFocus.unfocus(),
      hint: 'Price',
      isNum: true,
      isPrice: true,
      valueController: _formController.priceController,
    );
  }

  Widget _buildImageUploadSection() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Screen.max(context) * 0.02,
        vertical: Screen.max(context) * 0.03,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Image',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Screen.max(context) * 0.02),
          if (_selectedImage != null)
            Center(
              child: Stack(
                children: [
                  Container(
                    width: Screen.max(context) * 0.6,
                    height: Screen.max(context) * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(File(_selectedImage!.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: Screen.max(context) * 0.01,
                    right: Screen.max(context) * 0.01,
                    child: GestureDetector(
                      onTap: _removeImage,
                      child: Container(
                        padding: EdgeInsets.all(Screen.max(context) * 0.01),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Icon(
                          Icons.close,
                          size: Screen.max(context) * 0.04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: Screen.max(context) * 0.03),
          Center(
            child: ColoredButton(
              text: _selectedImage == null ? 'Select Image' : 'Change Image',
              onPressed: _pickImage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ColoredButton(
      text: 'Add Product',
      onPressed: _submitForm,
    );
  }
}

class ProductFormController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();

  Map<String, dynamic> args = {};

  void addProduct({required XFile image}) {
    if (!args.containsKey('products')) {
      args['products'] = [];
    }

    final newProduct = {
      'name': _capitalize(nameController.text),
      'description': _capitalize(descriptionController.text),
      'price': _capitalize(priceController.text),
      'image': image.path,
    };

    args['products'].add(newProduct);

    // Clear form after submission
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    nameFocus.dispose();
    descriptionFocus.dispose();
    priceFocus.dispose();
  }
}
