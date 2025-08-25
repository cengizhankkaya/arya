import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class OffInfoCard extends StatelessWidget {
  final VoidCallback onLaunchOpenFoodFacts;

  const OffInfoCard({super.key, required this.onLaunchOpenFoodFacts});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: ProjectPadding.allLarge(),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: ProjectRadius.xLarge,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.of(context).red,
                size: 24,
              ),
              ProjectSizedBox.widthNormal,
              Expanded(
                child: Text(
                  'off.account_required'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.of(context).red,
                  ),
                ),
              ),
            ],
          ),
          ProjectSizedBox.heightMedium,
          Text(
            'off.account_required_desc'.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onLaunchOpenFoodFacts,
            icon: const Icon(Icons.open_in_new),
            label: Text('off.go_to_off'.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.of(context).openfoodfacts,
              foregroundColor: AppColors.of(context).textStrong,
              padding: ProjectPadding.symmetricVeryLarge,
              shape: RoundedRectangleBorder(borderRadius: ProjectRadius.medium),
            ),
          ),
        ],
      ),
    );
  }
}
