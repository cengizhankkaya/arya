import 'package:arya/features/index.dart';
import 'package:flutter/material.dart';

class ProductFormFields extends StatelessWidget {
  final AddProductViewModel viewModel;

  const ProductFormFields({super.key, required this.viewModel});

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
