import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/package%20box.dart';
import 'package:taqreeb/theme/color.dart';

class CategoryPackages extends StatefulWidget {
  final Map listing;
  final bool type; // Toggle between editable and static layout

  const CategoryPackages({super.key, required this.listing, this.type = true});

  @override
  State<CategoryPackages> createState() => _CategoryPackagesState();
}

class _CategoryPackagesState extends State<CategoryPackages> {
  // Controllers for the text fields in the popup
  late TextEditingController nameController;
  late TextEditingController detailsController;
  late TextEditingController priceController;

  // Track which package is being edited
  int? editingIndex;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    detailsController = TextEditingController();
    priceController = TextEditingController();
  }

  // Method to show the popup for adding or editing a package
  void showPackagePopup({int? index}) {
    if (index != null) {
      // If index is provided, we are editing an existing package
      var package = widget.listing['Package'][index];
      nameController.text = package['name'];
      detailsController.text = package['description'];
      priceController.text = package['price'].toString();
    } else {
      // If no index, we are adding a new package
      nameController.clear();
      detailsController.clear();
      priceController.clear();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColors.Dark,
          title: Text(
            index != null ? 'Edit Package' : 'Add New Package',
            style: GoogleFonts.montserrat(
              color: MyColors.Yellow,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name TextField
              TextField(
                controller: nameController,
                style: GoogleFonts.montserrat(color: MyColors.white),
                decoration: InputDecoration(
                  labelText: 'Package Name',
                  labelStyle: TextStyle(color: MyColors.white),
                  border: OutlineInputBorder(),
                  hintText: 'Enter Package Name',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 16),
              // Details TextField
              TextField(
                controller: detailsController,
                style: GoogleFonts.montserrat(color: MyColors.white),
                decoration: InputDecoration(
                  labelText: 'Package Details',
                  labelStyle: TextStyle(color: MyColors.white),
                  border: OutlineInputBorder(),
                  hintText: 'Enter Package Details',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 16),
              // Price TextField
              TextField(
                controller: priceController,
                style: GoogleFonts.montserrat(color: MyColors.white),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Package Price',
                  labelStyle: TextStyle(color: MyColors.white),
                  border: OutlineInputBorder(),
                  hintText: 'Enter Package Price',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          actions: [
            // Save Button
            TextButton(
              onPressed: () {
                setState(() {
                  if (index != null) {
                    // Update the package at the index
                    widget.listing['Package'][index] = {
                      'name': nameController.text,
                      'description': detailsController.text,
                      'price': double.parse(priceController.text),
                    };
                  } else {
                    // Add new package
                    widget.listing['Package'].add({
                      'name': nameController.text,
                      'description': detailsController.text,
                      'price': double.parse(priceController.text),
                    });
                  }
                });
                Navigator.pop(context);
              },
              child: Text(
                'Save',
                style: GoogleFonts.montserrat(
                  color: MyColors.Yellow,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Method to delete a package
  void deletePackage(int index) {
    setState(() {
      widget.listing['Package'].removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double maximumDimension =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    if (widget.type) {
      // Editable layout
      return Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Packages',
              style: GoogleFonts.montserrat(
                fontSize: maximumDimension * 0.025,
                fontWeight: FontWeight.w600,
                color: MyColors.Yellow,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.02),
              child: Column(
                children: widget.listing['Package'].map<Widget>((package) {
                  int index = widget.listing['Package'].indexOf(package);
                  return Container(
                    margin:
                        EdgeInsets.symmetric(vertical: maximumDimension * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Package Name, Details, and Price
                        Column(crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(

                              children: [
                                IconButton(
                                  icon:
                                      Icon(Icons.edit, color: MyColors.Yellow),
                                  onPressed: () =>
                                      showPackagePopup(index: index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: MyColors.red),
                                  onPressed: () => deletePackage(index),
                                ),
                              ],
                            ),
                            PackageBox(
                              packagedetails: package['description'],
                              packageprice: package['price'].toString(),
                              packagename: package['name'],
                            ),
                          ],
                        ),
                        // Icons for Edit and Delete
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            // Add New Package Icon
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: MyColors.Yellow),
              onPressed: () => showPackagePopup(),
            ),
          ],
        ),
      );
    } else {
      // Static layout
      return Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Packages',
              style: GoogleFonts.montserrat(
                fontSize: maximumDimension * 0.025,
                fontWeight: FontWeight.w600,
                color: MyColors.Yellow,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.02),
              child: Column(
                children: widget.listing['Package'].map<Widget>((package) {
                  return PackageBox(
                    packagedetails: package['description'],
                    packageprice: package['price'].toString(),
                    packagename: package['name'],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    }
  }
}
