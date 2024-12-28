import 'package:flutter/material.dart';

class cardprinterviewpage extends StatefulWidget {
  const cardprinterviewpage({super.key});

  @override
  State<cardprinterviewpage> createState() => _cardprinterviewpageState();
}

class _cardprinterviewpageState extends State<cardprinterviewpage> {
  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  void _getHeaderHeight() {
    final RenderObject? renderBox =
        _headerKey.currentContext?.findRenderObject();

    if (renderBox is RenderBox) {
      setState(() {
        _headerHeight = renderBox.size.height;
      });
    }
  }
@override
  void initState() {
    super.initState();
       WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
