import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';

class PricingSection extends StatefulWidget {
  final Map listing;
  const PricingSection({super.key, required this.listing});

  @override
  State<PricingSection> createState() => _PricingSectionState();
}

class _PricingSectionState extends State<PricingSection> {
  bool isEditingPriceMin = false;
  bool isEditingPriceMax = false;
  final TextEditingController priceMinController = TextEditingController();
  final TextEditingController priceMaxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    priceMinController.text = widget.listing['Listing']['priceMin'].toString();
    priceMaxController.text = widget.listing['Listing']['priceMax'].toString();
    SetType();
  }

  Future<void> saveField(String field, String value) async {
    try {
      final response = await MyApi.postRequest(
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
        },
        endpoint: 'businessowner/updateListings/',
        body: {
          'id': widget.listing['Listing']['id'].toString(),
          field: value,
        },
      );
      if (response['status'] == 'success') {
        setState(() {
          widget.listing['Listing'][field] = value;
          widget.listing['Listing']['basicPrice'] = ((int.parse(
                          widget.listing['Listing']['priceMin'].toString()) +
                      int.parse(
                          widget.listing['Listing']['priceMax'].toString())) /
                  2)
              .round();
          if (field == 'priceMin') isEditingPriceMin = false;
          if (field == 'priceMax') isEditingPriceMax = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$field updated successfully!')),
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to update $field.');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update $field: $e')),
      );
    }
  }

  bool type = false;
  Future<void> SetType() async {
    final value = await MyStorage.exists(MyTokens.isBusinessOwner) ||
        await MyStorage.exists(MyTokens.isFreelancer);
    setState(() {
      type = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double maximumDimension =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    if (type) {
      // Editable layout
      return Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.02),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pricing:",
                  style: GoogleFonts.montserrat(
                    fontSize: maximumDimension * 0.02,
                    fontWeight: FontWeight.w500,
                    color: MyColors.white,
                  ),
                ),
                Text(
                  "Rs. ${widget.listing['Listing']['priceMin'].toString()} - ${widget.listing['Listing']['priceMax'].toString()}",
                  style: GoogleFonts.montserrat(
                    fontSize: maximumDimension * 0.02,
                    fontWeight: FontWeight.w400,
                    color: MyColors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: maximumDimension * 0.02),
            _buildEditableRow(
              "Minimum Price:",
              "priceMin",
              isEditingPriceMin,
              priceMinController,
              () => setState(() => isEditingPriceMin = true),
              () => saveField('priceMin', priceMinController.text),
              maximumDimension,
            ),
            SizedBox(height: maximumDimension * 0.02),
            _buildEditableRow(
              "Maximum Price:",
              "priceMax",
              isEditingPriceMax,
              priceMaxController,
              () => setState(() => isEditingPriceMax = true),
              () => saveField('priceMax', priceMaxController.text),
              maximumDimension,
            ),
            SizedBox(height: maximumDimension * 0.02),
            _buildNonEditableRow(
              "Basic Price:",
              widget.listing['Listing']['basicPrice'].toString(),
              maximumDimension,
            ),
            SizedBox(
              height: screenHeight * 0.05,
              child: Center(
                  child: MyDivider(
                width: screenWidth * 0.85,
              )),
            ),
          ],
        ),
      );
    } else {
      // Original layout
      return Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.02),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pricing:",
                  style: GoogleFonts.montserrat(
                    fontSize: maximumDimension * 0.02,
                    fontWeight: FontWeight.w500,
                    color: MyColors.white,
                  ),
                ),
                Text(
                  "Rs. ${widget.listing['Listing']['priceMin'].toString()} - ${widget.listing['Listing']['priceMax'].toString()}",
                  style: GoogleFonts.montserrat(
                    fontSize: maximumDimension * 0.02,
                    fontWeight: FontWeight.w400,
                    color: MyColors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: maximumDimension * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Basic Price:",
                  style: GoogleFonts.montserrat(
                    fontSize: maximumDimension * 0.015,
                    fontWeight: FontWeight.w500,
                    color: MyColors.Yellow,
                  ),
                ),
                Text(
                  widget.listing['Listing']['basicPrice'].toString(),
                  style: GoogleFonts.montserrat(
                    fontSize: maximumDimension * 0.015,
                    fontWeight: FontWeight.w400,
                    color: MyColors.white,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.05,
              child: Center(
                  child: MyDivider(
                width: screenWidth * 0.85,
              )),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildEditableRow(
    String label,
    String field,
    bool isEditing,
    TextEditingController controller,
    VoidCallback onEdit,
    VoidCallback onSave,
    double maximumDimension,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: maximumDimension * 0.015,
            fontWeight: FontWeight.w500,
            color: MyColors.Yellow,
          ),
        ),
        if (isEditing)
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: GoogleFonts.montserrat(
              fontSize: maximumDimension * 0.015,
              color: MyColors.white,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter $label...',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          )
        else
          Text(
            widget.listing['Listing'][field].toString(),
            style: GoogleFonts.montserrat(
              fontSize: maximumDimension * 0.015,
              fontWeight: FontWeight.w400,
              color: MyColors.white,
            ),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: ColoredButton(
            text: isEditing ? "Save" : "Edit",
            onPressed: isEditing ? onSave : onEdit,
          ),
        ),
      ],
    );
  }

  Widget _buildNonEditableRow(
    String label,
    String value,
    double maximumDimension,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: maximumDimension * 0.015,
            fontWeight: FontWeight.w500,
            color: MyColors.Yellow,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: maximumDimension * 0.015,
            fontWeight: FontWeight.w400,
            color: MyColors.white,
          ),
        ),
      ],
    );
  }
}
