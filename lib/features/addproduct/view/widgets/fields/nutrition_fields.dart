import 'package:flutter/material.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:arya/features/addproduct/view/widgets/common/section_title.dart';
import 'package:arya/features/addproduct/view/widgets/common/form_field.dart';

class NutritionFields extends StatelessWidget {
  final AddProductViewModel viewModel;

  const NutritionFields({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: "Besin Değerleri"),
        const SizedBox(height: 15),
        _buildNutritionRow([
          CustomFormField(
            controller: viewModel.energyController,
            labelText: "Enerji (kcal)",
            keyboardType: TextInputType.number,
          ),
          CustomFormField(
            controller: viewModel.fatController,
            labelText: "Yağ (g)",
            keyboardType: TextInputType.number,
          ),
        ]),
        const SizedBox(height: 15),
        _buildNutritionRow([
          CustomFormField(
            controller: viewModel.carbsController,
            labelText: "Karbonhidrat (g)",
            keyboardType: TextInputType.number,
          ),
          CustomFormField(
            controller: viewModel.proteinController,
            labelText: "Protein (g)",
            keyboardType: TextInputType.number,
          ),
        ]),
        const SizedBox(height: 15),
        _buildNutritionRow([
          CustomFormField(
            controller: viewModel.sodiumController,
            labelText: "Sodyum (mg)",
            keyboardType: TextInputType.number,
          ),
          CustomFormField(
            controller: viewModel.fiberController,
            labelText: "Lif (g)",
            keyboardType: TextInputType.number,
          ),
        ]),
        const SizedBox(height: 15),
        CustomFormField(
          controller: viewModel.sugarController,
          labelText: "Şeker (g)",
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
