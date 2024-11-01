import 'package:flutter/material.dart';
import 'package:taqreeb/Components/category_icon.dart';
import 'package:taqreeb/Components/Colored%20Button.dart'; 
import 'package:taqreeb/Components/Border%20Button.dart'; 
import 'package:taqreeb/Components/Message%20Chats,dart';
import 'package:taqreeb/Components/Recieve%20Message.dart';
import 'package:taqreeb/Components/Search%20Box.dart'; 
import 'package:taqreeb/Components/Iconed%20Button.dart'; 
import 'package:taqreeb/Components/GuestList%20Button.dart'; 
import 'package:taqreeb/Components/Send%20Message.dart'; 
import 'package:taqreeb/Components/ProductCard.dart'; 
import 'package:taqreeb/Components/function.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/home%20page%20products.dart';
import 'package:taqreeb/Components/navbar.dart';
import 'package:taqreeb/Components/progressbar.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/images.dart';
import 'package:taqreeb/Components/Cake%20Box.dart';
import 'package:taqreeb/Components/Cart%20Item.dart';
import 'package:taqreeb/Components/OTP%20Boxes.dart';
import 'package:taqreeb/Components/Selection%20Dialog.dart';
import 'package:taqreeb/screen/forgot%20password.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      backgroundColor: MyColors.Dark,
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
          ForgotPassword(),
          Navbar(),
          Center(
        child: CategoryIcon(
          label: 'Caterers',
        ))
        ],

      ),

    );
  }
}
