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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: viewModel.loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'general.button.save'.tr(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: viewModel.loading
                ? null
                : () => viewModel.handleClear(context),
            style: OutlinedButton.styleFrom(
              padding: ProjectPadding.verticalNormal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.clear, size: 20),
                const SizedBox(width: 8),
                Text(
                  'general.button.clear'.tr(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
