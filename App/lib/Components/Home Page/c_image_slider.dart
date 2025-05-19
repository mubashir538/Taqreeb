import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/screen_size.dart';

class AutoImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  final double height;
  final Duration slideDuration;
  final Duration preloadDuration;

  const AutoImageSlider({
    super.key,
    required this.imageUrls,
    required this.height,
    this.slideDuration = const Duration(seconds: 3),
    this.preloadDuration = const Duration(seconds: 1),
  });

  @override
  AutoImageSliderState createState() => AutoImageSliderState();
}

class AutoImageSliderState extends State<AutoImageSlider> {
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
    return Container(
      height: widget.height,
      width: Screen.width(context) * 0.9,
      margin: EdgeInsets.all(Screen.max(context) * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            _initialLoadComplete
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
                          child: Icon(FontAwesomeIcons.exclamation),
                        ),
                      );
                    },
                  )
                : Center(child: CircularProgressIndicator()),
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(Screen.max(context) * 0.02),
                width: Screen.width(context) * 0.9,
                height: Screen.height(context) * 0.1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withAlpha(20),
                      Colors.black.withAlpha(200),
                    ],
                  ),
                ),
                child: Text('Top Services',
                    style: GoogleFonts.roboto(
                        fontSize: Screen.max(context) * 0.03,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
