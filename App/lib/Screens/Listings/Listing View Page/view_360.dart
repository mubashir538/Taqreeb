import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:video_player/video_player.dart';

class View360 extends StatefulWidget {
  const View360({super.key});

  @override
  State<View360> createState() => _View360State();
}

class _View360State extends State<View360> {
  late String videoUrl = '';
  bool _isInitialized = false;
  late VideoPlayerController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      print('args: $args');
      _initializeVideo(args);
    }
  }

  void _initializeVideo(String url) {
    if (videoUrl == url && _isInitialized) return;

    videoUrl = url;
    print('venue url: $videoUrl');
    print(videoUrl);
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1) + videoUrl))
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _isInitialized = true;
          _controller.play();
          _controller.setLooping(true);
        });
      }).catchError((error) {
        if (!mounted) return;
        setState(() {
          _isInitialized = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load video')),
        );
      });
  }

  // @override
  // void dispose() {
  //   if (_controller != null) {
  //     _controller.dispose();
  //   }
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _isInitialized && _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const CircularProgressIndicator(color: Colors.white),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
