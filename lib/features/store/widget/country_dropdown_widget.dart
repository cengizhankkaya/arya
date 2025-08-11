import 'package:flutter/material.dart';
import 'package:arya/features/store/view_model/store_view_model.dart';
import 'package:provider/provider.dart';

class CountryDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StoreViewModel>(
      builder: (context, model, child) {
        final scheme = Theme.of(context).colorScheme;
        return Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: (Theme.of(context).brightness == Brightness.light)
                    ? Colors.black12
                    : scheme.shadow.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        );
      },
    );
  }
}
