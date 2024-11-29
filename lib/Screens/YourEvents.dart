import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/Components/Search%20Box.dart';
import 'package:taqreeb/Components/function.dart';

class YourEvents extends StatelessWidget {
  const YourEvents({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    TextEditingController controller = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              heading: 'Your Events',
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
              child:
                  SearchBox(controller: controller, width: screenWidth * 0.9),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 6,
              itemBuilder: (context, index) => Function12(
                name: "Wishfa",
                head: 'Budget',
                budget: '500,000',
                headings: [
                  'Event Type',
                  'Functions',
                  'Date',
                  'Catering Cost',
                  'Venue Cost',
                  'Photographer Included'
                ],
                values: [
                  'Wedding',
                  '5',
                  '24th Oct - 30 Nov',
                  '300,000',
                  '600,000',
                  'Yes'
                ],
                type: 'Event',
              ),
            )
          ],
        ),
      ),
    );
  }
}
