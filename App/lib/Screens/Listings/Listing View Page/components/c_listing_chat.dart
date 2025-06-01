import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class ChatIcon extends StatelessWidget {
  final int ownerId;
  final Map<String, dynamic> listing;
  final String type;
  final EdgeInsetsGeometry? margin;

  const ChatIcon({
    super.key,
    required this.ownerId,
    required this.listing,
    required this.type,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final double maxDimension = Screen.max(context);
    final double iconSize = maxDimension * 0.03;
    final double fontSize = maxDimension * 0.015;
    final double padding = maxDimension * 0.017;
    final double spacing = maxDimension * 0.01;

    final colors = AppColors(context);

    return Positioned(
      bottom: Screen.height(context) * 0.05,
      right: Screen.height(context) * 0.03,
      child: GestureDetector(
        onTap: () async {
          final response = await MyApi.getRequest(
              endpoint: 'user/id/$ownerId/$type',
              context: context,
              headers: {
                'Authorization':
                    'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
              });
          context.pushNamedTransition(
              routeName: '/ChatBox',
              type: PageTransitionType.rightToLeftWithFade,
              duration: Duration(milliseconds: 300),
              arguments: {
                'userId': response['id'],
                'type': type,
                'ownerId': response['id'],
                'listing': listing
              });
        },
        child: Container(
          margin: margin,
          decoration: BoxDecoration(
            color: colors.red,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(51),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(padding),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                child: FaIcon(
                  FontAwesomeIcons.comment,
                  color: Colors.white,
                  size: iconSize,
                ),
              ),
              SizedBox(width: spacing),
              Text(
                'Chat',
                style: GoogleFonts.roboto(
                  color: colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
