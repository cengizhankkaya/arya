import 'package:arya/features/index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage(name: 'CategoryRoute')
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('appbar.categories'.tr()),
          centerTitle: true,
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onSecondary,
          elevation: 0,
        ),
        backgroundColor: scheme.surface,
        body: Padding(
          padding: ProjectPadding.allSmall(),
          child: Consumer<HomeViewModel>(
            builder: (context, vm, _) {
              final categories = vm.categories;
              return GridView.builder(
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85, // Kartları biraz daha geniş yapıyorum
                ),
                itemBuilder: (context, index) {
                  return CategoryCard(category: categories[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
