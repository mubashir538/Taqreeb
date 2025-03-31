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
  bool _initialLoadComplete = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _startAutoSlide();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _preloadInitialImages().then((_) {
      if (mounted) {
        setState(() => _initialLoadComplete = true);
      }
    });
  }

  Future<void> _preloadInitialImages() async {
    // Preload first image immediately
    await _preloadImage(0);

    // Preload next images in background
    if (widget.imageUrls.length > 1) {
      _preloadImage(1);
    }
    if (widget.imageUrls.length > 2) {
      _preloadImage(2);
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
      _preloadImage(nextIndex);

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
      child: _initialLoadComplete
          ? PageView.builder(
              controller: _pageController,
              itemCount: widget.imageUrls.length,
              onPageChanged: (index) {
                if (mounted) {
                  setState(() => _currentIndex = index);
                }
                _preloadImage((index + 1) % widget.imageUrls.length);
                _preloadImage((index - 1) % widget.imageUrls.length);
              },
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: widget.imageUrls[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.error),
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
