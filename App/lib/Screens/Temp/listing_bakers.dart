// import 'dart:async';

// import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CategoryView_BakerySweet extends StatefulWidget {
//   const CategoryView_BakerySweet({super.key});

//   @override
//   State<CategoryView_BakerySweet> createState() =>
//       _CategoryView_BakerySweetState();
// }

// class _CategoryView_BakerySweetState extends State<CategoryView_BakerySweet> {
//   String token = '';
//   Map<String, dynamic> listing = {};
//   late int? listingId;
//   bool isLoading = true;
//   DateTime? entryTime; //added

//   bool isToggled = true;
//   List<String> headings = [];
//   List<String> values = [];
//   List<String> stars = [
//     '5 Stars',
//     '4 Stars',
//     '3 Stars',
//     '2 Stars',
//     '1 Stars',
//   ];
//   List<String> starsvalue = [];

//   final List<String> _imageUrls = [];
//   DateTime? selectedDate = DateTime.now();
//   Map<String, dynamic> events = {};
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
//     entryTime = DateTime.now(); // added-Store entry time when user opens page
//      
//    print("📌 User opened CategoryView_BakerySweet at: $entryTime");
//   }

//   bool type = false;
//   bool ischange = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     final args =
//         ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//     if (!ischange) {
//       setState(() {
//         listingId = args['id'];
//         type = args['isBusiness'];
//         ischange = true; // Prevents multiple API calls
//       });
//       fetchData();
//     }
//   }

//   Timer? timer;
//   void fetchData() async {
//     ischange = true;
//     final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
//     final listing = await MyApi.getRequest(
//       endpoint: 'Bakers/viewpage/${this.listingId}',
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (mounted) {
//         setState(() {
//           this.token = token;
//           this.listing = listing ?? {};
//           if (listing == null || listing['status'] == 'error') {
//             MyScaffold(text: 'Something Went Wrong!').show(context);
// ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               content: Text('Something Went Wrong!',
//                   style: GoogleFonts.montserrat(
//                       fontSize: 14,
//                       color: MyColors.white,
//                       fontWeight: FontWeight.w400)),
//               backgroundColor: MyColors.red,
//             ));
//             return;
//           } else {
//             isLoading = false;
//             for (var i = 0; i < listing['pictures'].length; i++) {
//               this._imageUrls.add(listing['pictures'][i]['picturePath']);
//             }
//             this.starsvalue.add('(${listing['reveiewData']['5'].toString()})');
//             this.starsvalue.add('(${listing['reveiewData']['4'].toString()})');
//             this.starsvalue.add('(${listing['reveiewData']['3'].toString()})');
//             this.starsvalue.add('(${listing['reveiewData']['2'].toString()})');
//             this.starsvalue.add('(${listing['reveiewData']['1'].toString()})');
//           }
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     if (entryTime != null) {
//       DateTime exitTime = DateTime.now();
//       int timeSpent = exitTime.difference(entryTime!).inSeconds;
//        
 //   print(
//           "🕒 Logging category view duration for Bakery Sweet: $timeSpent seconds");

//       logUserActivity("category_view_duration", {
//         "category": "Bakery and Sweets",
//         "listing_id": listingId ?? 0,
//         "time_spent_seconds": timeSpent
//       });
//     }
//     timer?.cancel();
//     super.dispose();
//   }

//   // added-Function to log time spent
//   // Future<void> logTimeSpent(int listingId, int timeSpent) async {
//   //   final response = await http.post(
//   //     Uri.parse(
//   //         'http://yourserver.com/api/log-activity/'), // Replace with actual Django API URL
//   //     headers: {'Content-Type': 'application/json'},
//   //     body: jsonEncode({
//   //       "user_id": 1, // Replace with actual user ID
//   //       "action": "category_view_duration",
//   //       "metadata": {
//   //         "category": "Venue",
//   //         "listing_id": listingId,
//   //         "time_spent_seconds": timeSpent
//   //       }
//   //     }),
//   //   );

//   //   if (response.statusCode == 201) {
//   //      
 //   print("Category view duration logged successfully");
//   //   } else {
//   //      
 //   print("Failed to log category view duration: ${response.body}");
//   //   }
//   // }
//   final GlobalKey _headerKey = GlobalKey();
//   double _headerHeight = 0.0;
//   void _getHeaderHeight() {
//     final RenderObject? renderBox =
//         _headerKey.currentContext?.findRenderObject();

//     if (renderBox is RenderBox) {
//       setState(() {
//         _headerHeight = renderBox.size.height;
//       });
//     }
//   }

//   Future<void> logUserActivity(
//       String action, Map<String, dynamic> metadata) async {
//     String? userId =
//         await MyStorage.getToken(MyTokens.userId); // Get user ID dynamically

//     if (userId == null) {
//        
//    print("⚠️ User ID not found. Skipping activity log.");
//       return;
//     }

//     final response = await MyApi.postRequest(
//       endpoint: 'log-user-activity/',
//       headers: {
//         'Authorization':
//             'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
//       },
//       body: {
//         "user_id": int.parse(userId), // Ensure user ID is an integer
//         "action": action,
//         "metadata": metadata,
//       },
//     );

//     if (response != null && response['status'] == 'success') {
//        
 //   print("✅ Activity logged: $action");
//     } else {
//        
 //   print("❌ Failed to log activity: ${response?['message']}");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     
//     final  
//     _getHeaderHeight();
//     return Scaffold(
//       backgroundColor: MyColors.Dark,
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(height: _headerHeight),
//                 isLoading
//                     ? Center(
//                         child: CircularProgressIndicator(
//                         valueColor:
//                             AlwaysStoppedAnimation<Color>(MyColors.white),
//                       ))
//                     : Column(
//                         children: [
//                           ImageSliderCategory(
//                             imageUrls: _imageUrls,
//                           ),
//                           Container(
//                             width: Screen.width(context),
//                             color: MyColors.Dark,
//                             padding: EdgeInsets.symmetric(
//                               horizontal: Screen.width(context) * 0.04,
//                               vertical: Screen.height(context) * 0.01,
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 UpperHeadings(
//                                     listing: listing,
//                                     listingId: listingId,
//                                     selectedDate: selectedDate,
//                                     events: events),
//                                 SizedBox(
//                                   height: Screen.height(context) * 0.05,
//                                   child: Center(
//                                       child: MyDivider(
//                                     width: Screen.width(context) * 0.85,
//                                   )),
//                                 ),
//                                 PricingSection(listing: listing),
//                                 DescriptionCategory(listing: listing),
//                                 CategoryDetails(
//                                     listing: listing,
//                                     headings: headings,
//                                     values: values),
//                                 CategoryPackages(listing: listing),
//                                 CategoryReview(
//                                     listing: listing, starsvalue: starsvalue),
//                                 SizedBox(
//                                   height: Screen.height(context) * 0.05,
//                                   child: Center(
//                                       child: MyDivider(
//                                     width: Screen.width(context) * 0.85,
//                                   )),
//                                 ),
//                                 Padding(
//                                   padding:
//                                       EdgeInsets.only(top: Screen.height(context) * 0.03),
//                                   child: Center(
//                                       child: ColoredButton(
//                                     text: 'Book Bakery and Sweets',
//                                     onPressed: () async {
//                                        
 //   print(
//                                           "🛒 User clicked 'Book Bakery and Sweets' for listing ID: $listingId");

//                                       await logUserActivity("book_bakerysweet",
//                                           {"listing_id": listingId ?? 0});

//                                       MyScaffold(text: 'Something Went Wrong!').show(context);
// ScaffoldMessenger.of(context)
//                                           .showSnackBar(SnackBar(
//                                         content: Text('Booking action logged!',
//                                             style: GoogleFonts.montserrat(
//                                                 fontSize: 14,
//                                                 color: MyColors.white,
//                                                 fontWeight: FontWeight.w400)),
//                                         backgroundColor: MyColors.green,
//                                       ));
//                                       Navigator.pushNamed(
//                                           context, '/orderSummary',
//                                           arguments: {
//                                             'Name': listing['Listing']['name'],
//                                             'type': listing['Listing']['type'],
//                                             'price': listing['Listing']
//                                                 ['basicPrice'],
//                                           });
//                                     },
//                                   )),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       )
//               ],
//             ),
//           ),
//           Positioned(
//             top: 0,
//             child: Header(
//               key: _headerKey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
