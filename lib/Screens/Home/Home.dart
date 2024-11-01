import 'package:flutter/material.dart';
import 'package:taqreeb/Components/category_icon.dart';
import 'package:taqreeb/Components/Colored%20Button.dart'; 
import 'package:taqreeb/Components/function.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/home%20page%20products.dart';
import 'package:taqreeb/Components/navbar.dart';
import 'package:taqreeb/Components/progressbar.dart';
import 'package:taqreeb/theme/color.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Column(
        children: [
          Header(),
          CategoryIcon(label: 'Venue')
        ],

      ),

    );
  }
}
