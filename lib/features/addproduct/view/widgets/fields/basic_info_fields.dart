import 'package:flutter/material.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:arya/features/addproduct/view/widgets/common/section_title.dart';
import 'package:arya/features/addproduct/view/widgets/common/form_field.dart';

class BasicInfoFields extends StatelessWidget {
  final AddProductViewModel viewModel;

  const BasicInfoFields({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: "Temel Bilgiler"),
        const SizedBox(height: 15),
        CustomFormField(
          controller: viewModel.barcodeController,
          labelText: "Barkod",
          validator: (value) =>
              value == null || value.isEmpty ? "Barkod zorunlu" : null,
        ),
        const SizedBox(height: 15),
        CustomFormField(
          controller: viewModel.nameController,
          labelText: "Ürün Adı",
          validator: (value) =>
              value == null || value.isEmpty ? "Ürün adı zorunlu" : null,
        ),
        const SizedBox(height: 15),
        CustomFormField(
          controller: viewModel.brandsController,
          labelText: "Marka",
        ),
        const SizedBox(height: 15),
        CustomFormField(
          controller: viewModel.categoriesController,
          labelText: "Kategoriler",
        ),
        const SizedBox(height: 15),
        CustomFormField(
          controller: viewModel.quantityController,
          labelText: "Miktar",
        ),
        const SizedBox(height: 15),
        CustomFormField(
          controller: viewModel.ingredientsController,
          labelText: "İçindekiler",
          maxLines: 3,
        ),
      ],
    );
  }
}
