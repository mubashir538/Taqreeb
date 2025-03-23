import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/utils/color.dart';

class ImageSliderCategory extends StatefulWidget {
  final List<String> imageUrls;
  const ImageSliderCategory({super.key, required this.imageUrls});

  @override
  State<ImageSliderCategory> createState() => _ImageSliderCategoryState();
}

class _ImageSliderCategoryState extends State<ImageSliderCategory> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: Screen.height(context) * 0.3,
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
              bottom: -(Screen.max(context) * 0.01),
              child: Container(
                height: Screen.max(context) * 0.05,
                width: Screen.width(context),
                decoration: BoxDecoration(
                  color: MyColors.Dark,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                margin: EdgeInsets.only(top: Screen.max(context) * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.imageUrls.length, (index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: _currentIndex == index
                          ? Screen.max(context) * 0.015
                          : Screen.max(context) * 0.01,
                      height: _currentIndex == index
                          ? Screen.max(context) * 0.015
                          : Screen.max(context) * 0.01,
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
