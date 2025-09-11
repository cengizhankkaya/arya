import 'package:arya/product/theme/app_typography.dart';
import 'package:arya/product/utility/constants/dimensions/project_padding.dart';
import 'package:arya/product/utility/constants/dimensions/project_radius.dart';
import 'package:arya/product/utility/constants/dimensions/project_sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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
      padding: ProjectPadding.productDetailCard,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.surfaceContainerHighest,
            scheme.surfaceContainerHighest.withValues(alpha: 0.8),
            scheme.surface,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: ProjectRadius.xxLarge,
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      scheme.primaryContainer,
                      scheme.primaryContainer.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: ProjectRadius.xxLarge,
                  border: Border.all(
                    color: scheme.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: scheme.onPrimaryContainer, size: 22),
              ),
              ProjectSizedBox.widthMedium,
              Expanded(
                child: Text(
                  titleKey.tr(),
                  style: AppTypography.lightTextTheme.titleLarge?.copyWith(
                    fontWeight: AppTypography.boldWeight,
                    color: scheme.onSurface,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          ProjectSizedBox.heightMedium,
          child,
          if (showDisclaimer) ...[
            ProjectSizedBox.heightMedium,
            Container(
              padding: ProjectPadding.allSmall(),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: ProjectRadius.large,
                border: Border.all(
                  color: scheme.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: scheme.onSurfaceVariant,
                  ),
                  ProjectSizedBox.widthSmall,
                  Expanded(
                    child: Text(
                      'detail.data_disclaimer'.tr(),
                      style: AppTypography.lightTextTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: AppTypography.bodyLargeWeight,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
