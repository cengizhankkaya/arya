import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:arya/product/index.dart';

class ProductShimmerWidget extends StatelessWidget {
  const ProductShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: ProjectPadding.allSmall(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.95,
      ),
      itemCount: 6, // Yükleme sırasında gösterilecek placeholder sayısı
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
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: ProjectPadding.allVerySmall(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Resim placeholder'ı
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.onPrimary,
              highlightColor: Theme.of(context).colorScheme.onPrimary,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: ProjectRadius.large,
                ),
              ),
            ),
          ),
          SizedBox(height: ProjectMargin.small.top),

          // Ürün adı placeholder'ı
          Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.onPrimary,
            highlightColor: Theme.of(context).colorScheme.onPrimary,
            child: Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: ProjectRadius.small,
              ),
            ),
          ),
          SizedBox(height: ProjectMargin.small.top),

          // İkinci satır placeholder'ı
          Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.onPrimary,
            highlightColor: Theme.of(context).colorScheme.onPrimary,
            child: Container(
              height: 14,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: ProjectRadius.small,
              ),
            ),
          ),
          SizedBox(height: ProjectMargin.verySmall.top),

          // Alt kısım
          Row(
            children: [
              // Marka placeholder'ı
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.onPrimary,
                  highlightColor: Theme.of(context).colorScheme.onPrimary,
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: ProjectRadius.small,
                    ),
                  ),
                ),
              ),
              SizedBox(width: ProjectMargin.small.top),

              // Buton placeholder'ı
              Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.onPrimary,
                highlightColor: Theme.of(context).colorScheme.onPrimary,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: ProjectRadius.large,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Tek bir shimmer kartı için widget
class SingleProductShimmerCard extends StatelessWidget {
  const SingleProductShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildShimmerCard(context);
  }

  Widget _buildShimmerCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: ProjectRadius.xxLarge,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: ProjectPadding.allVerySmall(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Resim placeholder'ı
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.onPrimary,
              highlightColor: Theme.of(context).colorScheme.onPrimary,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: ProjectRadius.large,
                ),
              ),
            ),
          ),
          SizedBox(height: ProjectMargin.small.top),

          // Ürün adı placeholder'ı
          Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.onPrimary,
            highlightColor: Theme.of(context).colorScheme.onPrimary,
            child: Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: ProjectRadius.small,
              ),
            ),
          ),
          SizedBox(height: ProjectMargin.small.top),

          // İkinci satır placeholder'ı
          Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.onPrimary,
            highlightColor: Theme.of(context).colorScheme.onPrimary,
            child: Container(
              height: 14,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: ProjectRadius.small,
              ),
            ),
          ),
          SizedBox(height: ProjectMargin.verySmall.top),

          // Alt kısım
          Row(
            children: [
              // Marka placeholder'ı
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.onPrimary,
                  highlightColor: Theme.of(context).colorScheme.onPrimary,
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: ProjectRadius.small,
                    ),
                  ),
                ),
              ),
              SizedBox(width: ProjectMargin.small.top),

              // Buton placeholder'ı
              Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.onPrimary,
                highlightColor: Theme.of(context).colorScheme.onPrimary,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: ProjectRadius.large,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
