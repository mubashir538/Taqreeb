import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Rating/c_listing_info.dart';
import 'package:taqreeb/Components/Rating/c_rating_bar.dart';
import 'package:taqreeb/Components/Rating/c_rating_filter.dart';
import 'package:taqreeb/Components/Rating/c_review_card.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _searchController = TextEditingController();

  final Map<String, dynamic> _listing = {};
  bool isChange = false;
  bool _isLoading = true;
  List<dynamic> _filteredReviews = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (args.isNotEmpty && !isChange) {
      isChange = true;
      _listing.addAll(args);
      _filteredReviews = _listing['Review'] ?? [];
      getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxDimension = _calculateMaxDimension(context);
    final colors = AppColors(context);

    return Scaffold(
      backgroundColor: colors.dark,
      body: _buildScreenContent(context, maxDimension),
    );
  }

  double _calculateMaxDimension(BuildContext context) {
    return Screen.width(context) > Screen.height(context)
        ? Screen.width(context)
        : Screen.height(context);
  }

  Widget _buildScreenContent(BuildContext context, double maxDimension) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(),
          _buildProductInfo(),
          _buildDivider(context),
          _buildRatingFilter(),
          _buildDivider(context),
          _buildRatingDistribution(),
          _buildDivider(context),
          _buildReviewsList(),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return ProductInfo(
      rating: double.parse(_listing['Listing']['rating']),
      reviews: _listing['Listing']['ratingCount'],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return MyDivider(
      thickness: 0.5,
      width: Screen.width(context),
    );
  }

  Widget _buildRatingFilter() {
    return RatingFilter(
      controller: _searchController,
      onChanged: (selectedFilter) {
        setState(() {
          _applyRatingFilter(selectedFilter);
        });
      },
    );
  }

  void _applyRatingFilter(String filter) {
    if (filter == 'All Reviews') {
      _filteredReviews = _listing['Review'] ?? [];
      return;
    }

    final starCount = int.parse(filter.split(' ')[0]);

    _filteredReviews = (_listing['Review'] as List).where((review) {
      final rating = double.parse(review['rating']);
      if (starCount == 5) return rating >= 4.5;
      if (starCount == 4) return rating >= 3.5 && rating < 4.5;
      if (starCount == 3) return rating >= 2.5 && rating < 3.5;
      if (starCount == 2) return rating >= 1.5 && rating < 2.5;
      if (starCount == 1) return rating < 1.5;
      return false;
    }).toList();
  }

  Widget _buildReviewsList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        final review = _filteredReviews[index];
        return _isLoading
            ? Container()
            : ReviewCard(
                name: review['userName'],
                profileUrl: review['userpic'],
                stars: review['rating'],
                message: review['review'],
                days: timeAgo(review['date']),
              );
      },
      itemCount: _filteredReviews.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Map<int, double> calculateRatingDistribution() {
    final percentages = {5: 0.0, 4: 0.0, 3: 0.0, 2: 0.0, 1: 0.0};
    final totalRatings = _listing['Listing']['ratingCount'];
    if (totalRatings > 0) {
      percentages[5] = double.parse(
          ((_listing['reviewData']['s5'] / totalRatings) * 100)
              .toStringAsFixed(1));
      percentages[4] = double.parse(
          ((_listing['reviewData']['s4'] / totalRatings) * 100)
              .toStringAsFixed(1));
      percentages[3] = double.parse(
          ((_listing['reviewData']['s3'] / totalRatings) * 100)
              .toStringAsFixed(1));
      percentages[2] = double.parse(
          ((_listing['reviewData']['s2'] / totalRatings) * 100)
              .toStringAsFixed(1));
      percentages[1] = double.parse(
          ((_listing['reviewData']['s1'] / totalRatings) * 100)
              .toStringAsFixed(1));
    }
    return percentages;
  }

  Widget _buildRatingDistribution() {
    return RatingDistribution(
      ratingPercentages: calculateRatingDistribution(),
    );
  }

  void getUserInfo() async {
    final token = await MyStorage.getToken(MyTokens.accessToken);
    for (int i = 0; i < _listing['Review'].length; i++) {
      final user = await MyApi.getRequest(
          context: context,
          endpoint: 'basicUserInfo/${_listing['Review'][i]['userID']}/',
          headers: {'Authorization': 'Bearer $token'},
          refresh: true);
      setState(() {
        _listing['Review'][i]['userName'] = user['name'];
        _listing['Review'][i]['userpic'] = user['profilePicture'];
      });
      setState(() {
        _isLoading = false;
      });
    }
  }

  String timeAgo(String dateString) {
    DateTime inputDate = DateTime.parse(dateString).toLocal();
    DateTime now = DateTime.now();
    Duration diff = now.difference(inputDate);

    if (diff.inDays >= 365) {
      int years = (diff.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (diff.inDays >= 30) {
      int months = (diff.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (diff.inDays >= 1) {
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }


}
