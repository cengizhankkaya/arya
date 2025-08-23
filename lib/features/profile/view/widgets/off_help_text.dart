import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/index.dart';

class OffHelpText extends StatelessWidget {
  const OffHelpText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: ProjectPadding.allSmall(),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.help_outline, color: Colors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'off.help_text'.tr(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
