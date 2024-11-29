import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/ProductCard.dart';
import 'package:taqreeb/Components/Search Box.dart';
import 'package:taqreeb/Components/category_icon.dart';
import 'package:taqreeb/theme/color.dart';

class HomePage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),
            Container(
              margin: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SearchBox(controller: _searchController),
                  IconButton(
                    icon: Icon(Icons.tune, color: MyColors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Container(
              height: screenHeight * 0.2,
              alignment: Alignment.center,
              child: Image.network(
                'https://tse2.mm.bing.net/th?id=OIP.dZWWg5LlJhlUFNNdNuLsIQHaEL&pid=Api&P=0&h=220',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Center(
              child: Container(
                width: screenWidth * 0.95,
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Browse Categories',
                      style: GoogleFonts.montserrat(
                        fontSize: MaximumThing * 0.02,
                        fontWeight: FontWeight.w600,
                        color: MyColors.Yellow,
                      ),
                    ),
                    Text(
                      'See all',
                      style: GoogleFonts.montserrat(
                        fontSize: MaximumThing * 0.017,
                        fontWeight: FontWeight.w400,
                        color: MyColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.15,
              child: ListView.builder(
                itemBuilder: (context, index) => CategoryIcon(
                  onpressed: () {
                    Navigator.pushNamed(context, '/CategoryView_Caterers');
                  },
                  label: 'Caterers',
                  imageUrl:
                      'https://tse1.mm.bing.net/th?id=OIP.mXk6kBcrindk6DZZUj6gKgHaE0&pid=Api&P=0&h=220',
                ),
                itemCount: 5,
                scrollDirection: Axis.horizontal,
              ),
            ),
            Center(
              child: ColoredButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/CreateAIPackage');
                  },
                  text: 'Create Package with AI'),
            ),
            // GridView.builder(
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2,
            //       crossAxisSpacing: screenWidth * 0.02,
            //       mainAxisSpacing: screenHeight * 0.01,
            //       childAspectRatio: 1 / 1.5),
            //   itemBuilder: (context, index) {
            //     return HomePageProducts(
            //       onpressed: () =>
            //           Navigator.pushNamed(context, '/CategoryView_Venue'),
            //       image:
            //           'https://media.istockphoto.com/id/497959594/photo/fresh-cakes.jpg?s=612x612&w=0&k=20&c=T1vp7QPbg6BY3GE-qwg-i_SqVpstyHBMIwnGakdTTek=',
            //       name: 'Sana Sarah\'s Salon',
            //       category: 'Salon and Spa',
            //       price: 'Rs. 5000 - 10000',
            //     );
            //   },
            //   itemCount: 10,
            // ),
            Center(
              child: SizedBox(
                width: screenWidth * 0.9,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Productcard(
                        onpressed: () {
                          Navigator.pushNamed(context, '/CategoryView_Venue');
                        },
                        imageUrl:
                            'https://tse1.mm.bing.net/th?id=OIP.mXk6kBcrindk6DZZUj6gKgHaE0&pid=Api&P=0&h=220',
                        venueName: "Qasr-e-Noor",
                        location: "North Nazimabad",
                        type: "Venue");
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
