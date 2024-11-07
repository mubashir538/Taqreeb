import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/Search Box.dart';
import 'package:taqreeb/Components/category_icon.dart';
import 'package:taqreeb/Components/home page products.dart';
import 'package:taqreeb/Components/navbar.dart';
import 'package:taqreeb/theme/color.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Header(
            heading: 'Welcome!',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Icon(Icons.search, color: Colors.grey),
                        ),
                        Expanded(
                          child: SearchBox(controller: _searchController),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.tune, color: Colors.grey),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 16),

              Container(
                height: 200,
                alignment: Alignment.center,
                child: Image.network(
                  'https://tse2.mm.bing.net/th?id=OIP.dZWWg5LlJhlUFNNdNuLsIQHaEL&pid=Api&P=0&h=220',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Browse Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyColors.Yellow,
                    ),
                  ),
                  Text(
                    'see all',
                    style: TextStyle(color: MyColors.white),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Category Icons Row with internet images
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CategoryIcon(
                    label: 'Caterers',
                    imageUrl:
                        'https://tse1.mm.bing.net/th?id=OIP.mXk6kBcrindk6DZZUj6gKgHaE0&pid=Api&P=0&h=220',
                  ),
                  CategoryIcon(
                    label: 'Photography',
                    imageUrl:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLxjlqh1KJ4KaL7BVgXG9IkSOoAUKzOTwxrQ&s',
                  ),
                  CategoryIcon(
                    label: 'Venue',
                    imageUrl:
                        'https://images.squarespace-cdn.com/content/v1/60da576b8b440e12699c9263/73884aa7-e214-4147-9ceb-a5ec06e231fa/Wedding+venue.jpg',
                  ),
                  CategoryIcon(
                    label: 'Salon and Spa',
                    imageUrl:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYuCcO1J0ukw7eVcb_2YRkhmOaRUYW06nFFA&s',
                  ),
                  CategoryIcon(
                    label: 'Sweets',
                    imageUrl:
                        'https://images.deliveryhero.io/image/fd-pk/LH/i3tb-hero.jpg?width=480&height=360&quality=45',
                  ),
                ],
              ),
              SizedBox(height: 24),

              Center(
                child: ColoredButton(text: 'Create Package with AI'),
              ),
              SizedBox(height: 24),

              // Adding spacing between HomePageProducts widgets
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(
                              8.0), // Add padding around each product card
                          child: HomePageProducts(
                            image:
                                'https://media.istockphoto.com/id/497959594/photo/fresh-cakes.jpg?s=612x612&w=0&k=20&c=T1vp7QPbg6BY3GE-qwg-i_SqVpstyHBMIwnGakdTTek=',
                            name: 'Sana Sarah\'s Salon',
                            category: 'Salon and Spa',
                            price: 'Rs. 5000 - 10000',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: HomePageProducts(
                            image:
                                'https://media.istockphoto.com/id/497959594/photo/fresh-cakes.jpg?s=612x612&w=0&k=20&c=T1vp7QPbg6BY3GE-qwg-i_SqVpstyHBMIwnGakdTTek=',
                            name: 'Kababjees Sweets',
                            category: 'Sweets',
                            price: 'Rs. 5000 - 10000',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: HomePageProducts(
                            image:
                                'https://media.istockphoto.com/id/497959594/photo/fresh-cakes.jpg?s=612x612&w=0&k=20&c=T1vp7QPbg6BY3GE-qwg-i_SqVpstyHBMIwnGakdTTek=',
                            name: 'Sana Sarah\'s Salon',
                            category: 'Salon and Spa',
                            price: 'Rs. 5000 - 10000',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: HomePageProducts(
                            image:
                                'https://media.istockphoto.com/id/497959594/photo/fresh-cakes.jpg?s=612x612&w=0&k=20&c=T1vp7QPbg6BY3GE-qwg-i_SqVpstyHBMIwnGakdTTek=',
                            name: 'Kababjees Sweets',
                            category: 'Sweets',
                            price: 'Rs. 5000 - 10000',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: MyColors.Yellow,
        child: Icon(Icons.add, color: MyColors.red),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Navbar(),
    );
  }
}
