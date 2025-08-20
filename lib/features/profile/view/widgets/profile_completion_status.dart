import 'package:arya/features/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileCompletionStatus extends StatelessWidget {
  const ProfileCompletionStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    final isComplete = viewModel.isUserComplete;
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();
    return Container(
      padding: ProjectPadding.allLarge(),
      decoration: BoxDecoration(
        color: isComplete
            ? scheme.primaryContainer
            : scheme.surfaceContainerHighest,
        borderRadius: ProjectRadius.xxLarge,
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: ProjectPadding.allSmall(),
            decoration: BoxDecoration(
              color: isComplete ? scheme.primary : scheme.secondary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isComplete ? Icons.check_rounded : Icons.info_rounded,
              color: scheme.onPrimary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isComplete
                      ? 'profile.status.completed'.tr()
                      : 'profile.status.incomplete'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: AppTypography.displayWeight,
                    color: isComplete
                        ? scheme.onPrimaryContainer
                        : appColors?.textStrong ?? scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isComplete
                      ? 'profile.status.completed_desc'.tr()
                      : 'profile.status.incomplete_desc'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
