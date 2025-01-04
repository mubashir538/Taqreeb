import 'package:flutter/material.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/theme/color.dart';

class ImageSliderCategory extends StatefulWidget {
  final List<String> imageUrls;
  const ImageSliderCategory({super.key,required this.imageUrls});

  @override
  State<ImageSliderCategory> createState() => _ImageSliderCategoryState();
}

class _ImageSliderCategoryState extends State<ImageSliderCategory> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double maximumDimension =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.3,
              child: PageView.builder(
                itemCount: widget.imageUrls.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.network(
                    '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${widget.imageUrls[index]}',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Positioned(
              bottom: -(maximumDimension * 0.01),
              child: Container(
                height: maximumDimension * 0.05,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: MyColors.Dark,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.only(top: maximumDimension * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.imageUrls.length, (index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: _currentIndex == index
                          ? maximumDimension * 0.015
                          : maximumDimension * 0.01,
                      height: _currentIndex == index
                          ? maximumDimension * 0.015
                          : maximumDimension * 0.01,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? MyColors.red
                            : MyColors.whiteDarker,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
