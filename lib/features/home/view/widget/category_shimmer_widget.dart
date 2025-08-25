import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:arya/product/index.dart';

class CategoryShimmerWidget extends StatelessWidget {
  const CategoryShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: ProjectPadding.allSmall(),
      itemCount: 8, // Yükleme sırasında gösterilecek placeholder sayısı
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        return _buildShimmerCard(context);
      },
    );
  }

  Widget _buildShimmerCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: ProjectRadius.xxLarge,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      padding: ProjectPadding.allVerySmall(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Resim placeholder'ı
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.outline,
              highlightColor: Theme.of(context).colorScheme.outline,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: ProjectRadius.xxLarge,
                ),
              ),
            ),
          ),
          ProjectSizedBox.heightNormal,
          Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.outline,
            highlightColor: Theme.of(context).colorScheme.outline,
            child: Container(
              height: 20,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: ProjectRadius.small,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
