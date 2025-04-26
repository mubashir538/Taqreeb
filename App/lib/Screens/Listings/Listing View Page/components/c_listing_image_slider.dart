import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageSliderCategory extends StatefulWidget {
  final List<String> imageUrls;

  const ImageSliderCategory({
    super.key,
    required this.imageUrls,
  });

  @override
  State<ImageSliderCategory> createState() => _ImageSliderCategoryState();
}

class _ImageSliderCategoryState extends State<ImageSliderCategory> {
  int _currentIndex = 0;

  String _getImageUrl(String path) {
    return '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}$path';
  }

  Widget _buildImageSlider() {
    return SizedBox(
      width: double.infinity,
      height: Screen.height(context) * 0.3,
      child: PageView.builder(
        itemCount: widget.imageUrls.length,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemBuilder: (context, index) => CachedNetworkImage(
          imageUrl: _getImageUrl(widget.imageUrls[index]),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    final isActive = _currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width:
          isActive ? Screen.max(context) * 0.015 : Screen.max(context) * 0.01,
      height:
          isActive ? Screen.max(context) * 0.015 : Screen.max(context) * 0.01,
      decoration: BoxDecoration(
        color: isActive ? MyColors.red : MyColors.whiteDarker,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildIndicatorRow() {
    return Positioned(
      bottom: -(Screen.max(context) * 0.01),
      child: Container(
        height: Screen.max(context) * 0.05,
        width: Screen.width(context),
        decoration: BoxDecoration(
          color: MyColors.dark,
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
          ],
        ),
      ],
    );
  }
}
