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
    if (args != null && _imageController.args.isEmpty) {
      _imageController.args = args as Map<String, dynamic>;
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

  Future<void> _pickImage() async {
    await Picture.pickImage(context, callback: (file) {
      setState(() => _imageController.addImage(file.path));
    });
  }

  Future<void> _submitService() async {
    final response = await _imageController.submitService();

    if (!mounted) return;

    if (response['status'] == 'success') {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/HomePage',
        ModalRoute.withName('/'),
      );
    } else {
      MyScaffold(text: 'Failed to add service. Please try again.')
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
              SizedBox(height: UI_Management.headerHeight),
              _buildImageUploadButton(),
              const SizedBox(height: 10),
              _buildImageGrid(),
            ],
          ),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildImageUploadButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Screen.width(context) * 0.05),
      height: Screen.height(context) * 0.2,
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyColors.darkLighter,
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
      child: InkWell(
        onTap: _pickImage,
        child: Center(
          child: CircleAvatar(
            radius: 30,
            backgroundColor: MyColors.darkLighter,
            child: Image.asset(
              MyIcons.add,
              color: MyColors.white,
            ),
          ),
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
        itemBuilder: (context, index) {
          return _buildImageItem(index);
        },
      ),
    );
  }

  Widget _buildImageItem(int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: MyColors.darkLighter,
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  File(_imageController.images[index]),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(
                  color: Colors.black.withAlpha(127),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: IconButton(
            icon: Icon(
              Icons.delete,
              color: MyColors.white,
              size: 30,
            ),
            onPressed: () =>
                setState(() => _imageController.removeImage(index)),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Positioned(
      bottom: Screen.max(context) * 0.02,
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
    images.removeAt(index);
  }

  Future<Map<String, dynamic>> submitService() async {
    final data = {
      'userid': await MyStorage.getToken(MyTokens.userId) ?? "",
      'name': args['name'],
      'type': await MyTokens.getBusinessType(),
      'description': args['description'],
      'category': args['category'],
      'location': args['location'],
      'priceMin': args['pricemin'],
      'priceMax': args['pricemax'],
      'packages':
          args['packages'] != null ? jsonEncode(args['packages']) : null,
      'addons': args['addons'] != null ? jsonEncode(args['addons']) : null,
    };

    _addCategorySpecificData(data);

    return await MyApi.postMultipartRequest(
      endpoint: 'businessowner/addListings/',
      body: data,
      files: {'pictures': images},
    );
  }

  void _addCategorySpecificData(Map<String, dynamic> data) {
    switch (args['category']) {
      case 'Venue':
        data['venueType'] = args['venueType'];
        data['staff'] = args['staff'];
        data['guestmaxAllowed'] = args['guestmaxAllowed'];
        data['guestminAllowed'] = args['guestminAllowed'];
        data['catering'] = args['catering'];
        break;
      case 'Photography Place':
        data['type'] = args['type'];
        break;
      case 'Decorator':
        data['decorType'] = args['decorType'];
        data['catering'] = args['catering'];
        data['staff'] = args['staff'];
        break;
      case 'Photographer':
      case 'Graphic Designer':
      case 'Video Editor':
        data['portfolioLink'] = args['portfolioLink'];
        break;
      case 'Caterer':
        data['serviceType'] = args['serviceType'];
        data['cateringOptions'] = args['cateringOptions'];
        data['staff'] = args['staff'];
        data['expertise'] = args['expertise'];
        break;
      case 'Car Renter':
        data['serviceType'] = args['serviceType'];
        break;
    }
  }
}
