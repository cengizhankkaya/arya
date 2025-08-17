import 'package:flutter/material.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:arya/features/addproduct/view/widgets/fields/index.dart';
import 'package:arya/features/addproduct/view/widgets/sections/index.dart';

class ProductFormFields extends StatelessWidget {
  final AddProductViewModel viewModel;

  const ProductFormFields({Key? key, required this.viewModel})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BasicInfoFields(viewModel: viewModel),
        const SizedBox(height: 20),
        ImageSection(viewModel: viewModel),
        const SizedBox(height: 20),
        NutritionFields(viewModel: viewModel),
        const SizedBox(height: 20),
        AdditionalInfoFields(viewModel: viewModel),
      ],
    );
  }
}
