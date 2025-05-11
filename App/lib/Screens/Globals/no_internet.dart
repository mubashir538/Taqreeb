import 'package:flutter/material.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:google_fonts/google_fonts.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 80, color: MyColors.white),
            SizedBox(height: 20),
            Text(
              'No Internet Connection',
              style: GoogleFonts.roboto(color: MyColors.white, fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Please check your connection and try again',
              style: GoogleFonts.roboto(color: MyColors.white, fontSize: 16),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
