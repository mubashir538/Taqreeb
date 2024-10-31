import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/function.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/home%20page%20products.dart';
import 'package:taqreeb/Components/navbar.dart';
import 'package:taqreeb/Components/progressbar.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/images.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      // appBar: AppBar(title: const Text('Taqreeb')),
      body: Column(
        children: [
          Header(),
          Function1(),
          ColoredButton(text: 'Hello'),
          ProgressBar(Progress: 3),
          HomePageProducts(
            category: 'Spa',
            name: 'Taqreeb',
            price: 'Rs. 10,000 - 15,000',
            image:
                'https://img.freepik.com/premium-photo/young-man-barbershop-trimming-shaving_752325-15382.jpg?semt=ais_hybrid',
          )
          ,
          Navbar()
        ],
      ),
    );
  }
}
