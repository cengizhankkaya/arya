import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:arya/features/addproduct/view/widgets/index.dart';
import 'package:arya/product/index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

@RoutePage(name: 'AddProductRoute')
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomeDialog(context);
    });
  }

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

  Future<void> _showWelcomeDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WelcomeDialog(
        onNavigateToCredentials: () => _navigateToOffCredentials(context),
      ),
    );
  }

  void _navigateToOffCredentials(BuildContext context) {
    context.router.push(const OffCredentialsRoute());
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return AppBar(
      title: Text(
        "add_product.title".tr(),
        style: TextStyle(fontWeight: AppTypography.boldWeight),
      ),
      backgroundColor: colors.addbackground,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      elevation: 0,
    );
  }

  Widget _buildBody(AddProductViewModel viewModel) {
    if (viewModel.isLoading) {
      return const AddProductShimmerWidget();
    }

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
