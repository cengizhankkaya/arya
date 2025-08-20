import 'package:flutter/material.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:arya/features/addproduct/view/widgets/common/section_title.dart';
import 'package:arya/features/addproduct/view/widgets/common/form_field.dart';
import 'package:easy_localization/easy_localization.dart';

class NutritionFields extends StatelessWidget {
  final AddProductViewModel viewModel;

  const NutritionFields({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: "add_product.sections.nutrition".tr()),
        const SizedBox(height: 15),
        _buildNutritionRow([
          CustomFormField(
            controller: viewModel.energyController,
            labelText: "add_product.fields.energy".tr(),
            keyboardType: TextInputType.number,
          ),
          CustomFormField(
            controller: viewModel.fatController,
            labelText: "add_product.fields.fat".tr(),
            keyboardType: TextInputType.number,
          ),
        ]),
        const SizedBox(height: 15),
        _buildNutritionRow([
          CustomFormField(
            controller: viewModel.carbsController,
            labelText: "add_product.fields.carbs".tr(),
            keyboardType: TextInputType.number,
          ),
          CustomFormField(
            controller: viewModel.proteinController,
            labelText: "add_product.fields.protein".tr(),
            keyboardType: TextInputType.number,
          ),
        ]),
        const SizedBox(height: 15),
        _buildNutritionRow([
          CustomFormField(
            controller: viewModel.sodiumController,
            labelText: "add_product.fields.sodium".tr(),
            keyboardType: TextInputType.number,
          ),
          CustomFormField(
            controller: viewModel.fiberController,
            labelText: "add_product.fields.fiber".tr(),
            keyboardType: TextInputType.number,
          ),
        ]),
        const SizedBox(height: 15),
        CustomFormField(
          controller: viewModel.sugarController,
          labelText: "add_product.fields.sugar".tr(),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildNutritionRow(List<Widget> children) {
    return Row(
      children: [
        for (int i = 0; i < children.length; i++) ...[
          Expanded(child: children[i]),
          if (i < children.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}
