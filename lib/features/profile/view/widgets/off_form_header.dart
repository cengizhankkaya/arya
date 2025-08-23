import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/index.dart';

class OffFormHeader extends StatelessWidget {
  const OffFormHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'off.account_info'.tr(),
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'off.account_info_desc'.tr(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
