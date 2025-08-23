import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:arya/product/index.dart';

class CartShimmerWidget extends StatelessWidget {
  const CartShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPadding.allSmall(),
      child: Column(
        children: [
          // Sepet özeti shimmer
          _buildCartSummaryShimmer(context),
          SizedBox(height: ProjectMargin.medium.top),

          // Sepet öğeleri shimmer
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Yükleme sırasında gösterilecek placeholder sayısı
              itemBuilder: (context, index) {
                return _buildCartItemShimmer(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummaryShimmer(BuildContext context) {
    final appColors = AppColors.of(context);

    return Row(
      children: [
        // İlk sepet özeti shimmer
        Expanded(
          child: Container(
            padding: ProjectPadding.allSmall(),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: ProjectRadius.normal,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: ProjectMargin.verySmall.top,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık shimmer
                Shimmer.fromColors(
                  baseColor: appColors.shimmerBase,
                  highlightColor: appColors.shimmerHighlight,
                  child: Container(
                    height: ProjectMargin.large.top,
                    width: 100,
                    decoration: BoxDecoration(
                      color: appColors.shimmerBase,
                      borderRadius: ProjectRadius.small,
                    ),
                  ),
                ),
                SizedBox(height: ProjectMargin.normal.top),
                // Toplam fiyat shimmer
                Shimmer.fromColors(
                  baseColor: appColors.shimmerBase,
                  highlightColor: appColors.shimmerHighlight,
                  child: Container(
                    height: ProjectMargin.large.top,
                    width: 120,
                    decoration: BoxDecoration(
                      color: appColors.shimmerBase,
                      borderRadius: ProjectRadius.small,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: ProjectMargin.medium.top),

        // İkinci sepet özeti shimmer
        Expanded(
          child: Container(
            padding: ProjectPadding.allSmall(),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: ProjectRadius.normal,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: ProjectMargin.verySmall.top,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık shimmer
                Shimmer.fromColors(
                  baseColor: appColors.shimmerBase,
                  highlightColor: appColors.shimmerHighlight,
                  child: Container(
                    height: ProjectMargin.large.top,
                    width: 100,
                    decoration: BoxDecoration(
                      color: appColors.shimmerBase,
                      borderRadius: ProjectRadius.small,
                    ),
                  ),
                ),
                SizedBox(height: ProjectMargin.normal.top),

                // Toplam fiyat shimmer
                Shimmer.fromColors(
                  baseColor: appColors.shimmerBase,
                  highlightColor: appColors.shimmerHighlight,
                  child: Container(
                    height: ProjectMargin.large.top,
                    width: 120,
                    decoration: BoxDecoration(
                      color: appColors.shimmerBase,
                      borderRadius: ProjectRadius.small,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: ProjectMargin.medium.top),

        // Temizle butonu shimmer
        Shimmer.fromColors(
          baseColor: appColors.shimmerBase,
          highlightColor: appColors.shimmerHighlight,
          child: Container(
            width: ProjectMargin.large.top,
            height: ProjectMargin.large.top,
            decoration: BoxDecoration(
              color: appColors.shimmerBase,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItemShimmer(BuildContext context) {
    final appColors = AppColors.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: ProjectMargin.normal.top),
      padding: ProjectPadding.allNormal(),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: ProjectRadius.normal,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: ProjectMargin.verySmall.top,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ürün resmi shimmer
          Shimmer.fromColors(
            baseColor: appColors.shimmerBase,
            highlightColor: appColors.shimmerHighlight,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: appColors.shimmerBase,
                borderRadius: ProjectRadius.medium,
              ),
            ),
          ),
          SizedBox(width: ProjectMargin.normal.top),

          // Ürün bilgileri shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ürün adı shimmer
                Shimmer.fromColors(
                  baseColor: appColors.shimmerBase,
                  highlightColor: appColors.shimmerHighlight,
                  child: Container(
                    height: ProjectMargin.normal.top,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: appColors.shimmerBase,
                      borderRadius: ProjectRadius.small,
                    ),
                  ),
                ),
                SizedBox(height: ProjectMargin.medium.top),

                // Marka shimmer
                Shimmer.fromColors(
                  baseColor: appColors.shimmerBase,
                  highlightColor: appColors.shimmerHighlight,
                  child: Container(
                    height: ProjectMargin.normal.top,
                    width: 80,
                    decoration: BoxDecoration(
                      color: appColors.shimmerBase,
                      borderRadius: ProjectRadius.small,
                    ),
                  ),
                ),
                SizedBox(height: ProjectMargin.medium.top),

                // Fiyat shimmer
                Shimmer.fromColors(
                  baseColor: appColors.shimmerBase,
                  highlightColor: appColors.shimmerHighlight,
                  child: Container(
                    height: ProjectMargin.medium.top,
                    width: 60,
                    decoration: BoxDecoration(
                      color: appColors.shimmerBase,
                      borderRadius: ProjectRadius.small,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: ProjectMargin.normal.top),

          // Miktar kontrolleri shimmer
          Column(
            children: [
              // Artır butonu shimmer
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
              SizedBox(height: ProjectMargin.medium.top),

              // Miktar shimmer
              Shimmer.fromColors(
                baseColor: appColors.shimmerBase,
                highlightColor: appColors.shimmerHighlight,
                child: Container(
                  height: ProjectMargin.large.top,
                  width: 30,
                  decoration: BoxDecoration(
                    color: appColors.shimmerBase,
                    borderRadius: ProjectRadius.small,
                  ),
                ),
              ),
              SizedBox(height: ProjectMargin.medium.top),

              // Azalt butonu shimmer
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
