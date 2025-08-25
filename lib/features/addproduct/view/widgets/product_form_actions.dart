import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductFormActions extends StatelessWidget {
  final AddProductViewModel viewModel;

  const ProductFormActions({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProjectSizedBox.heightXXLarge,
        _buildSubmitButton(context),
        ProjectSizedBox.heightLarge,
        _buildMessages(),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    final colors = AppColors.of(context);
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ElevatedButton(
              onPressed: () => _showAddProductDialog(context, viewModel),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.addbackground,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: ProjectRadius.medium,
                ),
              ),
              child: Text(
                "add_product.buttons.add_product".tr(),
                style: TextStyle(
                  fontSize: AppTypography.bodyLargeSize,
                  fontWeight: AppTypography.boldWeight,
                ),
              ),
            ),
    );
  }

  Widget _buildMessages() {
    return Builder(
      builder: (context) {
        final colors = AppColors.of(context);
        return Column(
          children: [
            if (viewModel.errorMessage != null) ...[
              Container(
                width: double.infinity,
                padding: ProjectPadding.allSmall(),
                decoration: BoxDecoration(
                  color: colors.red50,
                  border: Border.all(color: colors.red200),
                  borderRadius: ProjectRadius.xLarge,
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: colors.red600),
                    ProjectSizedBox.widthNormal,
                    Expanded(
                      child: Text(
                        viewModel.errorMessage!,
                        style: TextStyle(
                          color: colors.red700,
                          fontWeight: AppTypography.bodyLargeWeight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ProjectSizedBox.heightSmallMedium,
            ],
            if (viewModel.successMessage != null) ...[
              Container(
                width: double.infinity,
                padding: ProjectPadding.allSmall(),
                decoration: BoxDecoration(
                  color: colors.green50,
                  border: Border.all(color: colors.green200),
                  borderRadius: ProjectRadius.xLarge,
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: colors.green600),
                    ProjectSizedBox.widthNormal,
                    Expanded(
                      child: Text(
                        viewModel.successMessage!,
                        style: TextStyle(
                          color: colors.green700,
                          fontWeight: AppTypography.bodyLargeWeight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Future<void> _showAddProductDialog(
    BuildContext context,
    AddProductViewModel viewModel,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('dialogs.add_product.title'.tr()),
        content: Text('dialogs.add_product.content'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('general.button.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(
                context,
              ).extension<AppColors>()!.addbackground,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Text('dialogs.add_product.add'.tr()),
          ),
        ],
      ),
    );

    if (result == true) {
      await viewModel.addProduct();
    }
  }
}
