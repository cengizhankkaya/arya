import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/features/store/view_model/cart_view_model.dart';
import 'package:provider/provider.dart';
import 'package:arya/product/theme/app_typography.dart';

class CartSummaryWidget extends StatelessWidget {
  const CartSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cart = Provider.of<CartViewModel>(context);
    final numberFormat = NumberFormat.decimalPattern();
    final proteinFormat = NumberFormat("#,##0.0");

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          top: BorderSide(
            color: scheme.outline.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'store.totals.total_kcal'.tr(),
                  value: '${numberFormat.format(cart.totalKcal.round())} kcal',
                  icon: Icons.local_fire_department,
                  accentColor: scheme.tertiary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Metric(
                  label: 'store.totals.total_protein'.tr(),
                  value: '${proteinFormat.format(cart.totalProtein)} g',
                  icon: Icons.fitness_center,
                  accentColor: scheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? accentColor;

  const _Metric({
    required this.label,
    required this.value,
    required this.icon,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: scheme.onSurfaceVariant,
            fontWeight: AppTypography.bodyLargeWeight,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: accentColor ?? scheme.primary),
            const SizedBox(width: 6),
            Text(
              value,
              style: textTheme.titleSmall?.copyWith(
                color: scheme.onSurface,
                fontWeight: AppTypography.displayWeight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
