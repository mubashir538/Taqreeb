import 'package:flutter/material.dart';
import 'package:taqreeb/core/utils/color.dart';

class AddCategoryAddProduct extends StatefulWidget {
  const AddCategoryAddProduct({super.key});

  @override
  State<AddCategoryAddProduct> createState() => _AddCategoryAddProductState();
}

class _AddCategoryAddProductState extends State<AddCategoryAddProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.dark,
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: MyColors.dark,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Product Form Coming Soon',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
