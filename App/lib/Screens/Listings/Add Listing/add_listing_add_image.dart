import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/picture_options.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/icons.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  final _imageController = ImageController();
  final GlobalKey _headerKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null &&
        args is Map<String, dynamic> &&
        _imageController.args.isEmpty) {
      _imageController.args = Map.from(args);
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
    if (mounted) {
      setState(() => UI_Management.headerHeight = renderbox.size.height);
    }
  }

  Future<void> _pickMultipleImages() async {
    final images = await Picture.pickMultipleImages(context);
    if (images.isNotEmpty && mounted) {
      setState(() {
        _imageController.images.addAll(images.map((file) => file.path));
      });
    }
  }

  Future<void> _submitService() async {
    if (_imageController.images.isEmpty) {
      MyScaffold(text: 'Please add at least one image').show(context);
      return;
    }

    final response = await _imageController.submitService();

    if (!mounted) return;

    if (response['status'] == 'success') {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/HomePage',
        ModalRoute.withName('/'),
      );
    } else {
      MyScaffold(text: response['message'] ?? 'Failed to add service')
          .show(context);
    }
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
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Final Step',
              para: 'Add images to your service',
            ),
          ),
          Column(
            children: [
              SizedBox(
                  height: UI_Management.headerHeight +
                      Screen.height(context) * 0.02),
              _buildImageUploadButton(),
              const SizedBox(height: 10),
              _buildImageGrid(),
              SizedBox(
                  height: Screen.height(context) * 0.1), // Space for button
            ],
          ),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildImageUploadButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Screen.width(context) * 0.05),
      child: Container(
        height: Screen.height(context) * 0.2,
        decoration: BoxDecoration(
          color: MyColors.DarkLighter,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: _pickMultipleImages,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      width: Screen.width(context) * 0.9,
                      padding: EdgeInsets.all(Screen.max(context) * 0.02),
                      decoration: BoxDecoration(
                        color: MyColors.DarkLighter,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.add_photo_alternate,
                        color: MyColors.white,
                        size: Screen.max(context) * 0.03,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.all(Screen.width(context) * 0.03),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: Screen.width(context) * 0.03,
          mainAxisSpacing: Screen.width(context) * 0.03,
          childAspectRatio: 1,
        ),
        itemCount: _imageController.images.length,
        itemBuilder: (context, index) => _buildImageItem(index),
      ),
    );
  }

  Widget _buildImageItem(int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(
              File(_imageController.images[index]),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => setState(() => _imageController.removeImage(index)),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Positioned(
      bottom: Screen.height(context) * 0.02,
      left: Screen.width(context) * 0.25,
      right: Screen.width(context) * 0.25,
      child: ColoredButton(
        text: 'Add Service',
        width: Screen.width(context) * 0.5,
        onPressed: _submitService,
      ),
    );
  }
}

class ImageController {
  final List<String> images = [];
  Map<String, dynamic> args = {};

  void addImage(String path) {
    images.add(path);
  }

  void removeImage(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
    }
  }

  Future<Map<String, dynamic>> submitService() async {
    try {
      final userId = await MyStorage.getToken(MyTokens.userId) ?? "";
      final businessType = await MyTokens.getBusinessType();
      final data = {
        'userid': userId,
        'name': args['name'] ?? '',
        'type': businessType,
        'description': args['description'] ?? '',
        'category': args['category'] ?? '',
        'location': args['location'] ?? '',
        'priceMin': args['pricemin'] ?? '',
        'priceMax': args['pricemax'] ?? '',
        'products': _safeJsonEncode(args['products']),
        'packages': _safeJsonEncode(args['packages']),
        'addons': _safeJsonEncode(args['addons']),
        'viewData': _safeJsonEncode(args['viewData']), // Added viewData
      };
      print(_safeJsonEncode(args['viewData']));

      // _addCategorySpecificData(data);

      final response = await MyApi.postMultipartRequest(
        endpoint: 'businessowner/addListings/',
        body: data,
        files: {'pictures': images},
      );
      print('Executed... $response');

      return response ??
          {'status': 'error', 'message': 'No response from server'};
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  String? _safeJsonEncode(dynamic data) {
    try {
      return data != null ? jsonEncode(data) : null;
    } catch (e) {
      return null;
    }
  }

  void _addCategorySpecificData(Map<String, dynamic> data) {
    final category = args['category']?.toString() ?? '';

    final categoryFields = {
      'Venue': [
        'venueType',
        'staff',
        'guestmaxAllowed',
        'guestminAllowed',
        'catering'
      ],
      'Photography Place': ['type'],
      'Decorator': ['decorType', 'catering', 'staff'],
      'Photographer': ['portfolioLink'],
      'Graphic Designer': ['portfolioLink'],
      'Video Editor': ['portfolioLink'],
      'Caterer': ['serviceType', 'cateringOptions', 'staff', 'expertise'],
      'Car Renter': ['serviceType'],
    };

    if (categoryFields.containsKey(category)) {
      for (final field in categoryFields[category]!) {
        if (args[field] != null) {
          data[field] = args[field];
        }
      }
    }
  }
}
