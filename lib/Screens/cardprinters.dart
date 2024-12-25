import 'package:flutter/material.dart';

class cardprinter extends StatefulWidget {
  const cardprinter({super.key});

  @override
  State<cardprinter> createState() => _cardprinterState();
}

class _cardprinterState extends State<cardprinter> {

  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  void _getHeaderHeight() {
    final RenderBox renderBox =
        _headerKey.currentContext?.findRenderObject() as RenderBox;
    setState(() {
      _headerHeight = renderBox.size.height;
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
