import 'package:arya/features/addproduct/index.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AdditionalInfoFields extends StatelessWidget {
  final AddProductViewModel viewModel;

  const AdditionalInfoFields({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: "add_product.sections.additional_info".tr()),
        const SizedBox(height: 15),
        CustomFormField(
          controller: viewModel.allergensController,
          labelText: "add_product.fields.allergens".tr(),
          maxLines: 2,
        ),
        const SizedBox(height: 15),
        CustomFormField(
          controller: viewModel.descriptionController,
          labelText: "add_product.fields.description".tr(),
          maxLines: 3,
        ),
        const SizedBox(height: 15),
        CustomFormField(
          controller: viewModel.tagsController,
          labelText: "add_product.fields.tags".tr(),
          maxLines: 2,
        ),
      ],
    );
  }
}
