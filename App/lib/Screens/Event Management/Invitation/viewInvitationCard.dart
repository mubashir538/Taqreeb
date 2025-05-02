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
  bool _isSaving = false;
  bool _isSharing = false;
  bool _isGenerating = false;
  bool _isLoadingTemplates = false;
  final Map<String, dynamic> data = {};
  String CardUrl = '';
  List<Map<String, dynamic>> templates = [];
  String? selectedTemplateId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (!_isChanged) {
      _isChanged = true;
      data.addAll(args['data']);
      _loadTemplates();
      generateCard();
    }
  }

  Future<void> _loadTemplates() async {
    setState(() => _isLoadingTemplates = true);
    try {
      final response = await MyApi.getRequest(
        endpoint: 'Invitation/Templates',
        params: {'eventType': data['eventType']},
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}',
        },
      );
      if (response['templates'] != null) {
        setState(() {
          templates = List<Map<String, dynamic>>.from(response['templates']);
          if (templates.isNotEmpty) {
            selectedTemplateId = templates[0]['id'];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        MyScaffold(text: "Error loading templates: ${e.toString()}")
            .show(context);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingTemplates = false);
      }
    }
  }

  Future<void> downloadImage(String imageUrl, String fileName) async {
    setState(() => _isSaving = true);
    try {
      await Permission.storage.request();

      if (await Permission.photos.request().isGranted ||
          await Permission.storage.request().isGranted) {
        // Get download directory
        Directory directory;
        if (Platform.isAndroid) {
          directory = Directory('/storage/emulated/0/Download');
        } else {
          directory = await getApplicationDocumentsDirectory();
        }

        // Full path
        String fullPath = '${directory.path}/$fileName';

        // Download
        Dio dio = Dio();
        await dio.download(imageUrl, fullPath);

        if (mounted) {
          MyScaffold(text: "Downloaded to: $fullPath").show(context);
        }
      } else {
        if (mounted) {
          MyScaffold(text: "Storage permission not granted").show(context);
        }
      }
    } catch (e) {
      if (mounted) {
        MyScaffold(text: "Error saving image: ${e.toString()}").show(context);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> shareImageFromUrl(String imageUrl) async {
    setState(() => _isSharing = true);
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
        text: "Check out this invitation!\nI created it using Taqreeb",
      );
    } catch (e) {
      if (mounted) {
        MyScaffold(text: "Error sharing image: ${e.toString()}").show(context);
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  Future<void> generateCard({String? templateId}) async {
    setState(() {
      _isGenerating = true;
      _isLoading = true;
    });
    try {
      // Create a copy of the data to avoid modifying the original
      final requestData = Map<String, dynamic>.from(data);
      if (templateId != null) {
        requestData['templateId'] = templateId;
      }

      final response = await MyApi.postRequest(
          endpoint: 'Invitation/CardDetails',
          body: requestData,
          headers: {
            'Authorization':
                'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}',
          });
      if (response['TempCard'] == null) {
        if (mounted) {
          MyScaffold(text: "Failed to generate card").show(context);
        }
        return;
      }
      setState(() {
        CardUrl = MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1) +
            response['TempCard'];
        if (templateId != null) {
          selectedTemplateId = templateId;
        }
      });
    } catch (e) {
      if (mounted) {
        MyScaffold(text: "Error generating card: ${e.toString()}")
            .show(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            SingleChildScrollView(
              child: SizedBox(
                width: Screen.width(context),
                child: Column(
                  children: [
                    SizedBox(height: Screen.height(context) * 0.1),
                    Container(
                      width: Screen.width(context),
                      margin: EdgeInsets.all(Screen.max(context) * 0.02),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: CardUrl,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          if (_isGenerating)
                            const Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    ),

                    // Template Selection Section
                    if (!_isLoadingTemplates && templates.isNotEmpty)
                      Column(
                        children: [
                          const Text(
                            'Available Templates',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: templates.length,
                              itemBuilder: (context, index) {
                                final template = templates[index];
                                return GestureDetector(
                                  onTap: () {
                                    if (template['id'] != selectedTemplateId) {
                                      generateCard(templateId: template['id']);
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            template['id'] == selectedTemplateId
                                                ? Colors.blue
                                                : Colors.grey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: CachedNetworkImage(
                                        imageUrl: '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${template['imageUrl']}',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                    Stack(
                      children: [
                        ColoredButton(
                          text: 'Generate Random Background',
                          onPressed:
                              _isGenerating ? null : () => generateCard(),
                        ),
                        if (_isGenerating)
                          const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ColoredButton(
                              text: 'Save Card',
                              width: Screen.width(context) * 0.45,
                              onPressed: _isSaving
                                  ? null
                                  : () => downloadImage(
                                      CardUrl, 'Taqreeb Invitation Card.png'),
                            ),
                            if (_isSaving)
                              const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                          ],
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ColoredButton(
                              text: 'Send Card',
                              width: Screen.width(context) * 0.45,
                              onPressed: _isSharing
                                  ? null
                                  : () => shareImageFromUrl(CardUrl),
                            ),
                            if (_isSharing)
                              const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          const Positioned(top: 0, child: Header()),
        ],
      ),
    );
  }
}
