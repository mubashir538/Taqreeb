import 'package:flutter/material.dart';

class AutoImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  final double height;

  AutoImageSlider({required this.imageUrls, required this.height});

  @override
  _AutoImageSliderState createState() => _AutoImageSliderState();
}

class _AutoImageSliderState extends State<AutoImageSlider> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoSlide();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    Future.delayed(Duration(seconds: 3)).then((_) {
      if (_pageController.hasClients) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % widget.imageUrls.length;
        });
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _startAutoSlide();
      }
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
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Image.network(
            widget.imageUrls[index],
            fit: BoxFit.cover,
            width: double.infinity,
          );
        },
      ),
    );
  }
}
