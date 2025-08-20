import 'package:arya/features/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';

class UserInfoSection extends StatelessWidget {
  final UserModel user;
  const UserInfoSection({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: ProjectRadius.xxLarge,
        boxShadow: [
          BoxShadow(
            color: appColors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Yeşil header bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: ProjectRadius.xxLarge,
            ),
            child: Row(
              children: [
                Icon(Icons.person, color: appColors.white, size: 20),
                const SizedBox(width: 12),
                Text(
                  'profile.section.personal_info'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: appColors.white,
                    fontWeight: AppTypography.labelWeight,
                  ),
                ),
              ],
            ),
          ),
          // Bilgi alanları
          Padding(
            padding: ProjectPadding.allLarge(),
            child: Column(
              children: [
                _buildInfoRow(
                  context,
                  Icons.person,
                  'profile.labels.name'.tr(),
                  user.name ?? 'general.not_specified'.tr(),
                ),
                const SizedBox(height: 20),
                _buildInfoRow(
                  context,
                  Icons.person,
                  'profile.labels.surname'.tr(),
                  user.surname ?? 'general.not_specified'.tr(),
                ),
                const SizedBox(height: 20),
                _buildInfoRow(
                  context,
                  Icons.email,
                  'profile.labels.email'.tr(),
                  user.email ?? 'general.not_specified'.tr(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sol taraftaki yeşil ikon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: appColors.lightGreen,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        // Sağ taraftaki label ve value
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: AppTypography.labelWeight,
                  color: appColors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: appColors.black,
                  fontWeight: AppTypography.bodyLargeWeight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
