import 'package:flutter/material.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:arya/features/addproduct/view/widgets/common/section_title.dart';
import 'package:arya/features/addproduct/view/widgets/common/form_field.dart';
import 'package:arya/product/index.dart';
import 'package:easy_localization/easy_localization.dart';

class BasicInfoFields extends StatelessWidget {
  final AddProductViewModel viewModel;

  const BasicInfoFields({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: "add_product.sections.basic_info".tr()),
        ProjectSizedBox.widthNormalMedium,
        CustomFormField(
          controller: viewModel.barcodeController,
          labelText: "add_product.fields.barcode".tr(),
          validator: (value) => value == null || value.isEmpty
              ? "add_product.fields.barcode_required".tr()
              : null,
        ),
        ProjectSizedBox.widthNormalMedium,
        CustomFormField(
          controller: viewModel.nameController,
          labelText: "add_product.fields.product_name".tr(),
          validator: (value) => value == null || value.isEmpty
              ? "add_product.fields.product_name_required".tr()
              : null,
        ),
        ProjectSizedBox.widthNormalMedium,
        CustomFormField(
          controller: viewModel.brandsController,
          labelText: "add_product.fields.brand".tr(),
        ),
        ProjectSizedBox.widthNormalMedium,
        CustomFormField(
          controller: viewModel.categoriesController,
          labelText: "add_product.fields.categories".tr(),
        ),
        ProjectSizedBox.widthNormalMedium,
        CustomFormField(
          controller: viewModel.quantityController,
          labelText: "add_product.fields.quantity".tr(),
        ),
        ProjectSizedBox.widthNormalMedium,
        CustomFormField(
          controller: viewModel.ingredientsController,
          labelText: "add_product.fields.ingredients".tr(),
          maxLines: 3,
        ),
      ],
    );
  }
}
