import 'package:flutter/material.dart';
import 'package:arya/features/store/view_model/cart_view_model.dart';
import 'package:provider/provider.dart';

class CartSummaryWidget extends StatelessWidget {
  const CartSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cart = Provider.of<CartViewModel>(context);

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: _TotalTile(
                  label: 'Toplam Kalori',
                  value: '${cart.totalKcal.toStringAsFixed(0)} kcal',
                  scheme: scheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TotalTile(
                  label: 'Toplam Protein',
                  value: '${cart.totalProtein.toStringAsFixed(1)} g',
                  scheme: scheme,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TotalTile extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme scheme;

  const _TotalTile({
    required this.label,
    required this.value,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
