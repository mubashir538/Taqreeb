import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/user_logs.dart';

class BookNowButton extends StatelessWidget {
  final Map<String, dynamic> listing;
  final BuildContext context;
  const BookNowButton({
    super.key,
    required this.context,
    required this.listing,
  });
  Future<void> _handleBookNow() async {
    await Logs.logUserActivity(
        "book_${listing['Listing']['type'].toLowerCase().trim()}",
        {"listing_id": listing['Listing']['id'] ?? 0});

    context.pushNamedTransition(
        routeName: '/OrderSummary',
        type: PageTransitionType.rightToLeftWithFade,
        duration: Duration(milliseconds: 300),
        arguments: {
          'Name': listing['Listing']['name'],
          'type': listing['Listing']['type'],
          'price': listing['Listing']['basicPrice'],
          'id': listing['Listing']['id']
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Screen.height(context) * 0.03),
      child: Center(
        child: ColoredButton(
          text: 'Book ${listing['Listing']['type']}',
          onPressed: _handleBookNow,
        ),
      ),
    );
  }
}
