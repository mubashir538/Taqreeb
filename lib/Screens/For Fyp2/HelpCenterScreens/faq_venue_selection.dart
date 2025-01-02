import 'package:flutter/material.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/faq_questions.dart';
import 'package:taqreeb/Components/Search Box.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<bool> _expandedStates = [false, false, false, false];

  void _toggleExpansion(int index) {
    setState(() {
      _expandedStates[index] = !_expandedStates[index];
    });
  }

  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  void _getHeaderHeight() {
    final RenderObject? renderBox =
        _headerKey.currentContext?.findRenderObject();

    if (renderBox is RenderBox) {
      setState(() {
        _headerHeight = renderBox.size.height;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Header(
                key: _headerKey,
                heading: 'FAQ - Venue Selection',
                para: '',
                image: '',
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SearchBox(
                  onChanged: (value) {},
                  controller: searchController,
                  hint: 'Search Typing to Search',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Find quick answers to common questions about wedding planning using our app..',
                style: TextStyle(
                  color: MyColors.white,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    FAQQuestion(
                      question: 'How do I find venues in my area?',
                      answer:
                          'Use the search feature in the Venue Selection section to filter venues by location, size, and style.',
                      isExpanded: _expandedStates[0],
                      onToggle: () => _toggleExpansion(0),
                    ),
                    SizedBox(height: 10),
                    FAQQuestion(
                      question: 'Can I book a venue directly through the app?',
                      answer:
                          'Yes, you can book a venue directly through our app with just a few clicks.',
                      isExpanded: _expandedStates[1],
                      onToggle: () => _toggleExpansion(1),
                    ),
                    SizedBox(height: 10),
                    FAQQuestion(
                      question: 'How do I compare venues?',
                      answer:
                          'Our app provides a comparison feature to help you make an informed decision.',
                      isExpanded: _expandedStates[2],
                      onToggle: () => _toggleExpansion(2),
                    ),
                    SizedBox(height: 10),
                    FAQQuestion(
                      question: 'What are the payment options available?',
                      answer:
                          'You can pay through credit/debit card, mobile payments, or bank transfer.',
                      isExpanded: _expandedStates[3],
                      onToggle: () => _toggleExpansion(3),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
