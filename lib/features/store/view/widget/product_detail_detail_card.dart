import 'package:arya/product/theme/app_typography.dart';
import 'package:arya/product/utility/constants/dimensions/project_radius.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/theme/app_colors.dart';

class ProductDetailCard extends StatelessWidget {
  const ProductDetailCard({
    super.key,
    required this.scheme,
    required this.titleKey,
    required this.icon,
    required this.child,
    this.showDisclaimer = true,
  });

  final ColorScheme scheme;
  final String titleKey;
  final IconData icon;
  final Widget child;
  final bool showDisclaimer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.surfaceContainerHighest, scheme.surface],
        ),
        borderRadius: ProjectRadius.xxLarge,
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).extension<AppColors>()!.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: ProjectRadius.xxLarge,
                ),
                child: Icon(icon, color: scheme.onPrimaryContainer, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                titleKey.tr(),
                style: AppTypography.lightTextTheme.titleLarge?.copyWith(
                  fontWeight: AppTypography.boldWeight,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
          if (showDisclaimer) ...[
            Text(
              'detail.data_disclaimer'.tr(),
              style: AppTypography.lightTextTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: AppTypography.bodyLargeWeight,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
