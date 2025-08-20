import 'package:arya/features/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchStoreBar extends StatefulWidget {
  @override
  State<SearchStoreBar> createState() => _SearchStoreBarState();
}

class _SearchStoreBarState extends State<SearchStoreBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: (Theme.of(context).brightness == Brightness.light)
                ? appColors!.dividerAlt
                : scheme.error,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: appColors?.textStrong ?? scheme.onSurface,
        ),
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'store.search_hint'.tr(),
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          prefixIcon: IconButton(
            icon: Icon(
              Icons.search,
              color: appColors?.textMuted ?? scheme.outline,
            ),
            onPressed: () {
              final viewModel = Provider.of<StoreViewModel>(
                context,
                listen: false,
              );
              final query = _controller.text.trim();
              if (query.isEmpty) {
                viewModel.fetchRandomProducts();
              } else {
                viewModel.search(query);
              }
            },
          ),
          filled: true,
          fillColor: scheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: scheme.outline, width: 2),
          ),
        ),
      ),
    );
  }
}
