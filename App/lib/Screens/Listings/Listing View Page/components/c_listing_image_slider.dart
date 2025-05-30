import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageSliderCategory extends StatefulWidget {
  final List<String> imageUrls;
  final bool show360Button; // Add this to control 360° button visibility

  const ImageSliderCategory({
    super.key,
    required this.imageUrls,
    this.show360Button = true,
  });

  @override
  State<ImageSliderCategory> createState() => _ImageSliderCategoryState();
}

class _ImageSliderCategoryState extends State<ImageSliderCategory> {
  int _currentIndex = 0;

  String _getImageUrl(String path) {
    return '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}$path';
  }

  void _openFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return FullScreenImage(
            imageUrl: _getImageUrl(imageUrl),
          );
        },
      ),
    );
  }

  void _navigateTo360View(BuildContext context) {
    // Replace with your 360° view screen navigation
    Navigator.pushNamed(context, '/360View');
  }

  Widget _build360Button() {
    return Positioned(
      top: 16,
      right: 16,
      child: GestureDetector(
        onTap: () => _navigateTo360View(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.rotate_right, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Text(
                '360° View',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    return SizedBox(
      width: double.infinity,
      height: Screen.height(context) * 0.3,
      child: PageView.builder(
        itemCount: widget.imageUrls.length,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => _openFullScreenImage(context, widget.imageUrls[index]),
          child: CachedNetworkImage(
            imageUrl: _getImageUrl(widget.imageUrls[index]),
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    final colors = AppColors(context);

    final isActive = _currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width:
          isActive ? Screen.max(context) * 0.015 : Screen.max(context) * 0.01,
      height:
          isActive ? Screen.max(context) * 0.015 : Screen.max(context) * 0.01,
      decoration: BoxDecoration(
        color: isActive ? colors.red : colors.whiteDarker,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildIndicatorRow() {
    final colors = AppColors(context);

    return Positioned(
      bottom: -(Screen.max(context) * 0.01),
      child: Container(
        height: Screen.max(context) * 0.05,
        width: Screen.width(context),
        decoration: BoxDecoration(
          color: colors.dark,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        margin: EdgeInsets.only(top: Screen.max(context) * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imageUrls.asMap().entries.map((entry) {
            return _buildIndicator(entry.key);
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            _buildImageSlider(),
            _buildIndicatorRow(),
            if (widget.show360Button) _build360Button(),
          ],
        ),
      ],
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withAlpha(230),
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}

// Create this screen for 360° view
