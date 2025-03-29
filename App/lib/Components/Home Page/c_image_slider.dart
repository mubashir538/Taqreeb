import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AutoImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  final double height;
  final Duration slideDuration;
  final Duration preloadDuration;

  const AutoImageSlider({
    required this.imageUrls,
    required this.height,
    this.slideDuration = const Duration(seconds: 3),
    this.preloadDuration = const Duration(seconds: 1),
  });

  @override
  _AutoImageSliderState createState() => _AutoImageSliderState();
}

class _AutoImageSliderState extends State<AutoImageSlider> {
  late PageController _pageController;
  int _currentIndex = 0;
  final Map<int, bool> _imageLoaded = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _preloadImages();
    _startAutoSlide();
  }

  void _preloadImages() {
    for (int i = 0; i < widget.imageUrls.length; i++) {
      _preloadImage(i);
    }
  }

  Future<void> _preloadImage(int index) async {
    if (_imageLoaded[index] == true) return;

    try {
      await precacheImage(
        CachedNetworkImageProvider(widget.imageUrls[index]),
        context,
      );
      if (mounted) {
        setState(() {
          _imageLoaded[index] = true;
        });
      }
    } catch (e) {
      debugPrint('Error preloading image $index: $e');
    }
  }

  void _startAutoSlide() {
    Future.delayed(widget.slideDuration).then((_) {
      if (!mounted || !_pageController.hasClients) return;

      final nextIndex = (_currentIndex + 1) % widget.imageUrls.length;

      // Preload next image before showing
      if (!_imageLoaded.containsKey(nextIndex)) {
        _preloadImage(nextIndex);
      }

      _pageController
          .animateToPage(
        nextIndex,
        duration: widget.preloadDuration,
        curve: Curves.easeInOut,
      )
          .then((_) {
        if (mounted) {
          setState(() => _currentIndex = nextIndex);
          _startAutoSlide();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageUrls.length,
        onPageChanged: (index) {
          if (mounted) {
            setState(() => _currentIndex = index);
          }
          // Preload adjacent images when manually swiped
          _preloadImage((index + 1) % widget.imageUrls.length);
          _preloadImage((index - 1) % widget.imageUrls.length);
        },
        itemBuilder: (context, index) {
          return _imageLoaded[index] == true
              ? CachedNetworkImage(
                  imageUrl: widget.imageUrls[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
