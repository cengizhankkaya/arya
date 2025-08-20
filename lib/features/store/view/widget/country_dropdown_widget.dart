import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountryDropdown extends StatelessWidget {
  const CountryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreViewModel>(
      builder: (context, model, child) {
        final scheme = Theme.of(context).colorScheme;
        return Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: ProjectRadius.xxLarge,
            boxShadow: [
              BoxShadow(
                color: (Theme.of(context).brightness == Brightness.light)
                    ? Colors.black12
                    : scheme.shadow.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: ProjectPadding.allLarge(),
        );
      },
    );
  }
}
