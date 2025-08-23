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
    final appColors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: ProjectRadius.xxLarge,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: ProjectMargin.verySmall.top,
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
              baseColor: appColors.shimmerBase,
              highlightColor: appColors.shimmerHighlight,
              child: Container(
                decoration: BoxDecoration(
                  color: appColors.shimmerBase,
                  borderRadius: ProjectRadius.large,
                ),
              ),
            ),
          ),
          SizedBox(height: ProjectMargin.small.top),

          // Ürün adı placeholder'ı
          Shimmer.fromColors(
            baseColor: appColors.shimmerBase,
            highlightColor: appColors.shimmerHighlight,
            child: Container(
              height: ProjectMargin.medium.top,
              width: double.infinity,
              decoration: BoxDecoration(
                color: appColors.shimmerBase,
                borderRadius: ProjectRadius.small,
              ),
            ),
          ),
          SizedBox(height: ProjectMargin.small.top),

          // İkinci satır placeholder'ı
          Shimmer.fromColors(
            baseColor: appColors.shimmerBase,
            highlightColor: appColors.shimmerHighlight,
            child: Container(
              height: ProjectMargin.normal.top,
              width: 60,
              decoration: BoxDecoration(
                color: appColors.shimmerBase,
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
                  baseColor: appColors.shimmerBase,
                  highlightColor: appColors.shimmerHighlight,
                  child: Container(
                    height: ProjectMargin.normal.top,
                    decoration: BoxDecoration(
                      color: appColors.shimmerBase,
                      borderRadius: ProjectRadius.small,
                    ),
                  ),
                ),
              ),
              SizedBox(width: ProjectMargin.small.top),

              // Buton placeholder'ı
              Shimmer.fromColors(
                baseColor: appColors.shimmerBase,
                highlightColor: appColors.shimmerHighlight,
                child: Container(
                  width: ProjectMargin.large.top,
                  height: ProjectMargin.large.top,
                  decoration: BoxDecoration(
                    color: appColors.shimmerBase,
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
    final appColors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: ProjectRadius.xxLarge,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: ProjectMargin.verySmall.top,
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
              baseColor: appColors.shimmerBase,
              highlightColor: appColors.shimmerHighlight,
              child: Container(
                decoration: BoxDecoration(
                  color: appColors.shimmerBase,
                  borderRadius: ProjectRadius.large,
                ),
              ),
            ),
          ),
          SizedBox(height: ProjectMargin.small.top),

          // Ürün adı placeholder'ı
          Shimmer.fromColors(
            baseColor: appColors.shimmerBase,
            highlightColor: appColors.shimmerHighlight,
            child: Container(
              height: ProjectMargin.medium.top,
              width: double.infinity,
              decoration: BoxDecoration(
                color: appColors.shimmerBase,
                borderRadius: ProjectRadius.small,
              ),
            ),
          ),
          SizedBox(height: ProjectMargin.small.top),

          // İkinci satır placeholder'ı
          Shimmer.fromColors(
            baseColor: appColors.shimmerBase,
            highlightColor: appColors.shimmerHighlight,
            child: Container(
              height: ProjectMargin.normal.top,
              width: 60,
              decoration: BoxDecoration(
                color: appColors.shimmerBase,
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
                  baseColor: appColors.shimmerBase,
                  highlightColor: appColors.shimmerHighlight,
                  child: Container(
                    height: ProjectMargin.normal.top,
                    decoration: BoxDecoration(
                      color: appColors.shimmerBase,
                      borderRadius: ProjectRadius.small,
                    ),
                  ),
                ),
              ),
              SizedBox(width: ProjectMargin.small.top),

              // Buton placeholder'ı
              Shimmer.fromColors(
                baseColor: appColors.shimmerBase,
                highlightColor: appColors.shimmerHighlight,
                child: Container(
                  width: ProjectMargin.large.top,
                  height: ProjectMargin.large.top,
                  decoration: BoxDecoration(
                    color: appColors.shimmerBase,
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
