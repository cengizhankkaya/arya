import 'package:flutter/material.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:arya/features/addproduct/view/widgets/common/section_title.dart';
import 'package:arya/features/addproduct/view/widgets/common/form_field.dart';

class AdditionalInfoFields extends StatelessWidget {
  final AddProductViewModel viewModel;

  const AdditionalInfoFields({Key? key, required this.viewModel})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: "Diğer Bilgiler"),
        const SizedBox(height: 15),
        CustomFormField(
          controller: viewModel.allergensController,
          labelText: "Allerjenler (virgülle ayırın)",
          maxLines: 2,
        ),
        const SizedBox(height: 15),
        CustomFormField(
          controller: viewModel.descriptionController,
          labelText: "Ürün Açıklaması",
          maxLines: 3,
        ),
        const SizedBox(height: 15),
        CustomFormField(
          controller: viewModel.tagsController,
          labelText: "Etiketler (vegan, organik, vb.)",
          maxLines: 2,
        ),
      ],
    );
  }
}
