import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../view_model/off_credentials_view_model.dart';

class OffActionButtons extends StatelessWidget {
  final OffCredentialsViewModel viewModel;

  const OffActionButtons({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: viewModel.loading
                ? null
                : () => viewModel.handleSave(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.of(context).openfoodfacts,
              foregroundColor: AppColors.of(context).textStrong,
              padding: ProjectPadding.verticalNormal,
              shape: RoundedRectangleBorder(borderRadius: ProjectRadius.large),
              elevation: 2,
            ),
            child: viewModel.loading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.of(context).white,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save, size: 20),
                      ProjectSizedBox.widthSmall,
                      Text(
                        'general.button.save'.tr(),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
          ),
        ),
        ProjectSizedBox.widthNormal,
        Expanded(
          child: OutlinedButton(
            onPressed: viewModel.loading
                ? null
                : () => viewModel.handleClear(context),
            style: OutlinedButton.styleFrom(
              padding: ProjectPadding.verticalNormal,
              shape: RoundedRectangleBorder(borderRadius: ProjectRadius.large),
              side: BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.clear, size: 20),
                ProjectSizedBox.widthSmall,
                Text(
                  'general.button.clear'.tr(),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
