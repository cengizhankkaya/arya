import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:arya/features/addproduct/view/widgets/index.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class AddProductScreen extends StatelessWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddProductViewModel(),
      child: Consumer<AddProductViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: _buildBody(viewModel),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return AppBar(
      title: const Text(
        "Ürün Ekle",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: colors.addbakground,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      elevation: 0,
    );
  }

  Widget _buildBody(AddProductViewModel viewModel) {
    return SingleChildScrollView(
      padding: const ProjectPadding.allSmall(),
      child: Form(
        key: viewModel.formKey,
        child: Column(
          children: [
            ProductFormFields(viewModel: viewModel),
            ProductFormActions(viewModel: viewModel),
          ],
        ),
      ),
    );
  }
}
