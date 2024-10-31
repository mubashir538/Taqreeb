import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart'; // Import ColoredButton
import 'package:taqreeb/Components/Border%20Button.dart'; // Import BorderButton
import 'package:taqreeb/Components/Message%20Chats,dart';
import 'package:taqreeb/Components/Recieve%20Message.dart';
import 'package:taqreeb/Components/Search%20Box.dart'; // Import SearchBox
import 'package:taqreeb/Components/Iconed%20Button.dart'; // Import IconedButton
import 'package:taqreeb/Components/GuestList%20Button.dart'; // Import GuestListButton
import 'package:taqreeb/Components/Send%20Message.dart'; // Import SendMessage
import 'package:taqreeb/Components/ProductCard.dart'; // Import ProductCard
import 'package:taqreeb/Components/ProductCard.dart'; // Import MessageChatButton

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      backgroundColor: Color(0xff18191A),
      appBar: AppBar(title: const Text('Taqreeb')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SearchBox(controller: searchController), // Call SearchBox
            const SizedBox(height: 20),
            ColoredButton(text: 'Continue'), // Call ColoredButton
            const SizedBox(height: 20), // Add space between buttons
            BorderButton(text: 'Cancel'), // Call BorderButton
            const SizedBox(height: 20),
            IconedButton(text: 'Continue with Google'), // Call IconedButton
            const SizedBox(height: 20),
            GuestListButton(
              // Call GuestListButton
              name: 'Mubashir Ahmed',
              phoneNumber: '03361273819',
            ),
            const SizedBox(height: 20),
            SendMessage(text: 'Hi Haziq, How are you???'), // Call SendMessageButton
            const SizedBox(height: 20),
            RecieveMessage(text: 'Bhai!!, Shadi kr rha hoon, My Life Update :)'), // Call RecieveMessage
            //call Product Card
        Productcard(
            imageUrl: 'https://tse4.mm.bing.net/th?id=OIP.A_WsK5iy-v39XTnXrp-RJAHaE8&pid=Api&P=0&h=220',
            venueName: 'Qasar-e-Noor',
            location: 'North Nazimabad - Block M - Karachi',
            type: 'Venue',
            ),
            //Call MessageChatButton
            const SizedBox(height: 20),
        MessageChatButton( 
          name: 'Mubashir Ahmed',
          message: 'Assalam-u-alikom', 
          time: '10:00 AM',
          ),

          ],
        ),
      ),
    );
  }
}
