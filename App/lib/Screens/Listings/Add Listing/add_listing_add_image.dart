import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/icons.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;

  final List<String> _images = [];
  Map<String, dynamic> args = {};
  bool ischanged = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (ischanged) {
      this.args = args;
      ischanged = false;
    }
  }

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

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final compressedFile = await _compressImage(File(pickedFile.path));
        setState(() {
          _images.add(compressedFile.path);
        });
      }
    } catch (e) {
      warningDialog(
        title: 'Error',
        message: 'Failed to pick an image. Please try again.',
      ).showDialogBox(context);
    }
  }

  Future<File> _compressImage(File file) async {
    try {
      final tempDir = Directory.systemTemp;
      final compressedPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        compressedPath,
        quality: 50,
      );

      if (compressedFile != null) {
        final FcompressedFile = File(compressedFile.path);
        return FcompressedFile;
      } else {
        throw Exception("Failed to compress image.");
      }
    } catch (e) {
      throw Exception("Compression error: ${e.toString()}");
    }
  }

  void _deleteImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    
     
    
    return Scaffold(
      backgroundColor: MyColors.Dark,
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
              SizedBox(height: _headerHeight),
              Container(
                margin: EdgeInsets.symmetric(horizontal: Screen.width(context) * 0.05),
                height: Screen.height(context) * 0.2,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: MyColors.DarkLighter,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 4,
                        spreadRadius: 1,
                        offset: Offset(2, 2)),
                  ],
                ),
                child: InkWell(
                  onTap: _pickImage,
                  child: Center(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: MyColors.DarkLighter,
                      child: Image.asset(
                        MyIcons.add,
                        color: MyColors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(Screen.width(context) * 0.03),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: Screen.width(context) * 0.03,
                    mainAxisSpacing: Screen.width(context) * 0.03,
                    childAspectRatio: 1,
                  ),
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: MyColors.DarkLighter,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 4,
                                spreadRadius: 1,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(
                                  File(_images[index]),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                                Container(
                                  color: Colors.black.withOpacity(0.5),
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
                            onPressed: () => _deleteImage(index),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: Screen.max(context) * 0.02,
            left: Screen.width(context) * 0.25,
            right: Screen.width(context) * 0.25,
            child: ColoredButton(
                text: 'Add Service',
                width: Screen.width(context) * 0.5,
                onPressed: () async {
                  final request = http.MultipartRequest('POST',
                      Uri.parse(MyApi.baseUrl + 'businessowner/addListings/'));

                  for (int i = 0; i < _images.length; i++) {
                    request.files.add(
                      await http.MultipartFile.fromPath(
                        'pictures',
                        _images[i],
                      ),
                    );
                  }

                  request.fields['userid'] =
                      await MyStorage.getToken(MyTokens.userId) ?? "";
                  request.fields['name'] = args['name'];
                  request.fields['type'] = await MyTokens.getBusinessType();
                  request.fields['description'] = args['description'];
                  request.fields['category'] = args['category'];
                  request.fields['location'] = args['location'];
                  final token =
                      await MyStorage.getToken(MyTokens.accessToken) ?? "";
                  request.headers.addAll({
                    'Authorization': 'Bearer $token',
                  });

                  request.fields['priceMin'] = args['pricemin'];
                  request.fields['priceMax'] = args['pricemax'];
                  if (args['packages'] != null) {
                    request.fields['packages'] = jsonEncode(args['packages']);
                  }
                  if (args['addons'] != null) {
                    request.fields['addons'] = jsonEncode(args['addons']);
                  }
                  if (args['category'] == 'Venue') {
                    request.fields['venueType'] = args['venueType'];
                    request.fields['staff'] = args['staff'];
                    request.fields['guestmaxAllowed'] = args['guestmaxAllowed'];
                    request.fields['guestminAllowed'] = args['guestminAllowed'];
                    request.fields['catering'] = args['catering'];
                  } else if (args['category'] == 'Photography Place') {
                    request.fields['type'] = args['type'];
                  } else if (args['category'] == 'Decorator') {
                    request.fields['decorType'] = args['decorType'];
                    request.fields['catering'] = args['catering'];
                    request.fields['staff'] = args['staff'];
                  } else if (args['category'] == 'Photographer') {
                    request.fields['portfolioLink'] = args['portfolioLink'];
                  } else if (args['category'] == 'Caterer') {
                    request.fields['serviceType'] = args['serviceType'];
                    request.fields['cateringOptions'] = args['cateringOptions'];
                    request.fields['staff'] = args['staff'];
                    request.fields['expertise'] = args['expertise'];
                  } else if (args['category'] == 'Car Renter') {
                    request.fields['serviceType'] = args['serviceType'];
                  } else if (args['category'] == 'Graphic Designer' ||
                      args['category'] == 'Video Editor') {
                    request.fields['portfolioLink'] = args['portfolioLink'];
                  }

                  final response = await request.send();

                  final responseBody = await response.stream.bytesToString();

                  if (response.statusCode == 200) {
                    final Map<String, dynamic> jsonResponse =
                        jsonDecode(responseBody);
                    if (jsonResponse['status'] == 'error') {
                      MyScaffold(text: jsonResponse['message']).show(context);
                    }
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/HomePage',
                      ModalRoute.withName('/'),
                    );
                  } else {
                    MyScaffold(text: 'Failed to add service. Please try again.')
                        .show(context);
                  }
                }),
          ),
        ],
      ),
    );
  }
}
