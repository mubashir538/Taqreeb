import 'package:flutter/material.dart';
import 'package:taqreeb/Components/category_icon.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/color.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Column(
        children: [Header(), CategoryIcon(label: 'Venue')],
      ),
    );
  }
}
