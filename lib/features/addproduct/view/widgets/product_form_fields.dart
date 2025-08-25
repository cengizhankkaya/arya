import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';

class ProductFormFields extends StatelessWidget {
  final AddProductViewModel viewModel;

  const ProductFormFields({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BasicInfoFields(viewModel: viewModel),
        ProjectSizedBox.heightLarge,
        ImageSection(viewModel: viewModel),
        ProjectSizedBox.heightLarge,
        NutritionFields(viewModel: viewModel),
        ProjectSizedBox.heightLarge,
        AdditionalInfoFields(viewModel: viewModel),
      ],
    );
  }
}
