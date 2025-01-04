import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
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
  bool isEditingBasicPrice = false;
  final bool type = true; // Toggle between layouts
  final TextEditingController priceMinController = TextEditingController();
  final TextEditingController priceMaxController = TextEditingController();
  final TextEditingController basicPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    priceMinController.text = widget.listing['Listing']['priceMin'].toString();
    priceMaxController.text = widget.listing['Listing']['priceMax'].toString();
    basicPriceController.text =
        widget.listing['Listing']['basicPrice'].toString();
  }

  Future<void> saveField(String field, String value) async {
    try {
      setState(() {
        widget.listing['Listing'][field] = value;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$field updated successfully!')),
      );

      if (field == 'priceMin') isEditingPriceMin = false;
      if (field == 'priceMax') isEditingPriceMax = false;
      if (field == 'basicPrice') isEditingBasicPrice = false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update $field: $e')),
      );
    }
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
            _buildEditableRow(
              "Basic Price:",
              "basicPrice",
              isEditingBasicPrice,
              basicPriceController,
              () => setState(() => isEditingBasicPrice = true),
              () => saveField('basicPrice', basicPriceController.text),
              maximumDimension,
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
}
