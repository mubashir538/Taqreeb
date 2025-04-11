import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';

class ViewInvitationCard extends StatefulWidget {
  const ViewInvitationCard({super.key});

  @override
  State<ViewInvitationCard> createState() => _ViewInvitationCardState();
}

class _ViewInvitationCardState extends State<ViewInvitationCard> {
  bool _isLoading = true;
  bool _isChanged = false;
  final Map<String, dynamic> data = {};
  String CardUrl = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (!_isChanged) {
      _isChanged = true;
      data.addAll(args['data']);
      generateCard();
    }
  }

  Future<void> downloadImage(String imageUrl, String fileName) async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      MyScaffold(text: "Storage permission not granted").show(context);
    }

    // Get download directory
    Directory directory;
    if (Platform.isAndroid) {
      directory =
          Directory('/storage/emulated/0/Download'); // Common Downloads folder
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    // Full path
    String fullPath = '${directory.path}/$fileName';

    // Download
    Dio dio = Dio();
    await dio.download(imageUrl, fullPath);

    MyScaffold(text: "Downloaded to: $fullPath").show(context);
  }

  Future<void> shareImageFromUrl(String imageUrl) async {
    try {
      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final fileName = imageUrl.split('/').last;
      final filePath = '${tempDir.path}/$fileName';

      // Download image
      await Dio().download(imageUrl, filePath);

      // Get MIME type
      final mimeType = lookupMimeType(filePath);

      // Share
      await Share.shareXFiles(
        [XFile(filePath, mimeType: mimeType)],
        text: "Check out this invitation!",
      );
    } catch (e) {
      print("Error sharing image: $e");
    }
  }

  void generateCard() async {
    setState(() {
      _isLoading = true;
    });
    final response = await MyApi.postRequest(
        endpoint: 'Invitation/CardDetails',
        body: data,
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}',
        });
    if (response['TempCard'] == null) {
      return;
    }
    CardUrl = MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1) +
        response['TempCard'];
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: SizedBox(
                    width: Screen.width(context),
                    child: Column(children: [
                      Container(
                        height: Screen.height(context) * 0.8,
                        width: Screen.width(context),
                        margin: EdgeInsets.all(Screen.max(context) * 0.02),
                        child: CachedNetworkImage(
                          imageUrl: CardUrl,
                        ),
                      ),
                      ColoredButton(
                        text: 'Generate Other Background',
                        onPressed: () {
                          generateCard();
                        },
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ColoredButton(
                              text: 'Save Card',
                              width: Screen.width(context) * 0.45,
                              onPressed: () => downloadImage(
                                  CardUrl, 'Taqreeb Invitation Card.png'),
                            ),
                            ColoredButton(
                                text: 'Send Card',
                                width: Screen.width(context) * 0.45,
                                onPressed: () {}),
                          ])
                    ]))),
        Positioned(top: 0, child: Header())
      ],
    ));
  }
}
