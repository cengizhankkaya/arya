import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:arya/product/index.dart';

class ProfileShimmerWidget extends StatelessWidget {
  const ProfileShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        padding: ProjectPadding.symmetricSmall,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeaderShimmer(context),
            ProjectSizedBox.heightLarge,
            _buildUserInfoShimmer(context),
            ProjectSizedBox.heightLarge,
            _buildProfileCompletionShimmer(context),
            ProjectSizedBox.heightLarge,
            _buildButtonsShimmer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeaderShimmer(BuildContext context) {
    return Row(
      children: [
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
            ),
          ),
        ),
        ProjectSizedBox.widthMedium,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.surface,
                highlightColor: Theme.of(context).colorScheme.surface,
                child: Container(
                  height: 24,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: ProjectRadius.small,
                  ),
                ),
              ),
              ProjectSizedBox.heightSmall,
              Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.surface,
                highlightColor: Theme.of(context).colorScheme.surface,
                child: Container(
                  height: 16,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: ProjectRadius.small,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfoShimmer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Container(
            height: 20,
            width: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: ProjectRadius.small,
            ),
          ),
        ),
        ProjectSizedBox.heightMedium,
        for (int i = 0; i < 4; i++) ...[
          Row(
            children: [
              Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.surface,
                highlightColor: Theme.of(context).colorScheme.surface,
                child: Container(
                  height: 16,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: ProjectRadius.small,
                  ),
                ),
              ),
              ProjectSizedBox.widthMedium,
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.surface,
                  highlightColor: Theme.of(context).colorScheme.surface,
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: ProjectRadius.small,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (i < 3) ProjectSizedBox.heightNormal,
        ],
      ],
    );
  }

  Widget _buildProfileCompletionShimmer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Container(
            height: 20,
            width: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: ProjectRadius.small,
            ),
          ),
        ),
        ProjectSizedBox.heightNormal,
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: ProjectRadius.small,
            ),
          ),
        ),
        ProjectSizedBox.heightSmall,
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Container(
            height: 16,
            width: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: ProjectRadius.small,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsShimmer(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: ProjectRadius.large,
            ),
          ),
        ),
        ProjectSizedBox.heightNormal,
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: ProjectRadius.large,
            ),
          ),
        ),
      ],
    );
  }
}
