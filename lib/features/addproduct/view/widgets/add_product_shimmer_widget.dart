import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:arya/product/index.dart';

class AddProductShimmerWidget extends StatelessWidget {
  const AddProductShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const ProjectPadding.allSmall(),
      child: Column(
        children: [
          _buildImageSectionShimmer(context),
          ProjectSizedBox.heightXLarge,
          _buildBasicInfoSectionShimmer(context),
          ProjectSizedBox.heightXLarge,
          _buildAdditionalInfoSectionShimmer(context),
          ProjectSizedBox.heightXLarge,
          _buildButtonsShimmer(context),
        ],
      ),
    );
  }

  Widget _buildImageSectionShimmer(BuildContext context) {
    return Container(
      padding: ProjectPadding.allSmall(),
      decoration: BoxDecoration(
        color: AppColors.of(context).cardBackground,
        borderRadius: ProjectRadius.large,
        border: Border.all(color: AppColors.of(context).grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: AppColors.of(context).shimmerBase,
            highlightColor: AppColors.of(context).shimmerHighlight,
            child: Container(
              height: 20,
              width: 120,
              decoration: BoxDecoration(
                color: AppColors.of(context).cardBackground,
                borderRadius: ProjectRadius.small,
              ),
            ),
          ),
          ProjectSizedBox.heightMedium,

          Shimmer.fromColors(
            baseColor: AppColors.of(context).shimmerBase,
            highlightColor: AppColors.of(context).shimmerHighlight,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.of(context).cardBackground,
                borderRadius: ProjectRadius.large,
                border: Border.all(
                  color: AppColors.of(context).shimmerBase,
                  style: BorderStyle.solid,
                ),
              ),
              child: Icon(
                Icons.add_photo_alternate,
                size: 48,
                color: AppColors.of(context).shimmerBase,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSectionShimmer(BuildContext context) {
    return Container(
      padding: ProjectPadding.allSmall(),
      decoration: BoxDecoration(
        color: AppColors.of(context).cardBackground,
        borderRadius: ProjectRadius.large,
        border: Border.all(color: AppColors.of(context).grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık shimmer
          Shimmer.fromColors(
            baseColor: AppColors.of(context).shimmerBase,
            highlightColor: AppColors.of(context).shimmerHighlight,
            child: Container(
              height: 20,
              width: 100,
              decoration: BoxDecoration(
                color: AppColors.of(context).cardBackground,
                borderRadius: ProjectRadius.small,
              ),
            ),
          ),
          ProjectSizedBox.heightMedium,

          // Form alanları shimmer
          for (int i = 0; i < 3; i++) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label shimmer
                Shimmer.fromColors(
                  baseColor: AppColors.of(context).shimmerBase,
                  highlightColor: AppColors.of(context).shimmerHighlight,
                  child: Container(
                    height: 16,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.of(context).cardBackground,
                      borderRadius: ProjectRadius.small,
                    ),
                  ),
                ),
                ProjectSizedBox.heightSmall,

                // Input field shimmer
                Shimmer.fromColors(
                  baseColor: AppColors.of(context).shimmerBase,
                  highlightColor: AppColors.of(context).shimmerHighlight,
                  child: Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.of(context).cardBackground,
                      borderRadius: ProjectRadius.medium,
                      border: Border.all(
                        color: AppColors.of(context).shimmerBase,
                      ),
                    ),
                  ),
                ),
                if (i < 2) ProjectSizedBox.heightMedium,
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoSectionShimmer(BuildContext context) {
    return Container(
      padding: ProjectPadding.allSmall(),
      decoration: BoxDecoration(
        color: AppColors.of(context).cardBackground,
        borderRadius: ProjectRadius.large,
        border: Border.all(color: AppColors.of(context).grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık shimmer
          Shimmer.fromColors(
            baseColor: AppColors.of(context).shimmerBase,
            highlightColor: AppColors.of(context).shimmerHighlight,
            child: Container(
              height: 20,
              width: 120,
              decoration: BoxDecoration(
                color: AppColors.of(context).cardBackground,
                borderRadius: ProjectRadius.small,
              ),
            ),
          ),
          ProjectSizedBox.heightMedium,

          // Text area shimmer
          Shimmer.fromColors(
            baseColor: AppColors.of(context).shimmerBase,
            highlightColor: AppColors.of(context).shimmerHighlight,
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.of(context).cardBackground,
                borderRadius: ProjectRadius.medium,
                border: Border.all(color: AppColors.of(context).shimmerBase),
              ),
            ),
          ),
          ProjectSizedBox.heightMedium,

          // Checkbox shimmer
          Row(
            children: [
              Shimmer.fromColors(
                baseColor: AppColors.of(context).shimmerBase,
                highlightColor: AppColors.of(context).shimmerHighlight,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.of(context).cardBackground,
                    borderRadius: ProjectRadius.small,
                  ),
                ),
              ),
              ProjectSizedBox.widthNormal,
              Shimmer.fromColors(
                baseColor: AppColors.of(context).shimmerBase,
                highlightColor: AppColors.of(context).shimmerHighlight,
                child: Container(
                  height: 16,
                  width: 150,
                  decoration: BoxDecoration(
                    color: AppColors.of(context).cardBackground,
                    borderRadius: ProjectRadius.small,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButtonsShimmer(BuildContext context) {
    return Column(
      children: [
        // Kaydet butonu shimmer
        Shimmer.fromColors(
          baseColor: AppColors.of(context).shimmerBase,
          highlightColor: AppColors.of(context).shimmerHighlight,
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.of(context).cardBackground,
              borderRadius: ProjectRadius.medium,
            ),
          ),
        ),
        ProjectSizedBox.heightNormal,

        // İptal butonu shimmer
        Shimmer.fromColors(
          baseColor: AppColors.of(context).shimmerBase,
          highlightColor: AppColors.of(context).shimmerHighlight,
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.of(context).cardBackground,
              borderRadius: ProjectRadius.medium,
            ),
          ),
        ),
      ],
    );
  }
}
