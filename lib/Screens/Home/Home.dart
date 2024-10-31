import 'package:flutter/material.dart';
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
import 'package:taqreeb/Components/progressbar.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/images.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(),
      backgroundColor: MyColors.Dark,
      ),
    );
  }
}
