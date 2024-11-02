import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryIcon extends StatelessWidget {
  final String label;
  final String imageUrl;

  const CategoryIcon({super.key, required this.label, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
const String imageUrl =
        'https://scontent.fkhi22-1.fna.fbcdn.net/v/t39.30808-6/462846583_3652200215061112_1789201124871518447_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=a5f93a&_nc_eui2=AeGpHXERbYJJSCtMY41W3zHD-B-YeID1F0j4H5h4gPUXSB1bFpiWGzL35-mKNMsaQ0fa70ajZFJykL6bI8r-wcla&_nc_ohc=RLHkVdtsB0YQ7kNvgGST43z&_nc_zt=23&_nc_ht=scontent.fkhi22-1.fna&_nc_gid=A46WfLMDHfcgmj5-t5Gjq1R&oh=00_AYCxK5-Nf7vLus_3G_WkcXAGjWTdEy9r9uZCeytGKArjqQ&oe=672A9643';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
            imageUrl,
          ),
        ),
        SizedBox(height: 10),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
