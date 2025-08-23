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
            // Profil header shimmer
            _buildProfileHeaderShimmer(context),
            const SizedBox(height: 20),

            // Kullanıcı bilgileri shimmer
            _buildUserInfoShimmer(context),
            const SizedBox(height: 20),

            // Profil tamamlama durumu shimmer
            _buildProfileCompletionShimmer(context),
            const SizedBox(height: 20),

            // Butonlar shimmer
            _buildButtonsShimmer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeaderShimmer(BuildContext context) {
    return Row(
      children: [
        // Profil resmi shimmer
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
        const SizedBox(width: 16),

        // İsim ve email shimmer
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
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.surface,
                highlightColor: Theme.of(context).colorScheme.surface,
                child: Container(
                  height: 16,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(4),
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
        // Başlık shimmer
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Container(
            height: 20,
            width: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Bilgi satırları shimmer
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
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.surface,
                  highlightColor: Theme.of(context).colorScheme.surface,
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (i < 3) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildProfileCompletionShimmer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık shimmer
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Container(
            height: 20,
            width: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Progress bar shimmer
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Yüzde shimmer
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Container(
            height: 16,
            width: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsShimmer(BuildContext context) {
    return Column(
      children: [
        // Düzenle butonu shimmer
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Çıkış yap butonu shimmer
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
