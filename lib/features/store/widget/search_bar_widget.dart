import 'package:arya/features/store/view_model/store_view_model.dart';
import 'package:arya/product/theme/app_colors.dart';
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
                ? Colors.black12
                : scheme.error,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        style: TextStyle(color: appColors?.textStrong ?? scheme.onSurface),
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Ürün ara...',
          hintStyle: TextStyle(color: scheme.onSurfaceVariant),
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
