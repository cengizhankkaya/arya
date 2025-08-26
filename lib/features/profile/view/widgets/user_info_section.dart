import 'package:arya/features/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'email_display_widget.dart';

class UserInfoSection extends StatelessWidget {
  final UserModel user;
  const UserInfoSection({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    final appColors = AppColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: appColors.primaryGreen,
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
            padding: ProjectPadding.symmetricPrivate,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: ProjectRadius.xxLarge,
            ),
            child: Row(
              children: [
                Icon(Icons.person, color: appColors.white, size: 20),
                ProjectSizedBox.widthNormal,
                Expanded(
                  child: Text(
                    'profile.section.personal_info'.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: appColors.white,
                      fontWeight: AppTypography.labelWeight,
                    ),
                  ),
                ),
                Consumer<ProfileViewModel>(
                  builder: (context, viewModel, child) {
                    return IconButton(
                      onPressed: () => viewModel.toggleEditMode(),
                      icon: Icon(Icons.edit, color: appColors.white, size: 20),
                      tooltip: 'general.button.edit'.tr(),
                    );
                  },
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
                ProjectSizedBox.heightLarge,
                _buildInfoRow(
                  context,
                  Icons.person,
                  'profile.labels.surname'.tr(),
                  user.surname ?? 'general.not_specified'.tr(),
                ),
                ProjectSizedBox.heightLarge,
                _buildEmailRow(context),
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
    final appColors = AppColors.of(context);
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
        ProjectSizedBox.widthMedium,
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
              ProjectSizedBox.heightVerySmall,
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: appColors.black,
                  fontWeight: AppTypography.bodyLargeWeight,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// E-posta satırı için özel widget
  Widget _buildEmailRow(BuildContext context) {
    final appColors = AppColors.of(context);
    final email = user.email ?? 'general.not_specified'.tr();

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
            Icons.email,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        ProjectSizedBox.widthMedium,
        // Sağ taraftaki label ve email
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'profile.labels.email'.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: AppTypography.labelWeight,
                  color: appColors.black,
                ),
              ),
              ProjectSizedBox.heightVerySmall,
              // E-posta için özel widget kullan
              EmailDisplayWidget(
                email: email,
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
