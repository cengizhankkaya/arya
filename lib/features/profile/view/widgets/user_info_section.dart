import 'package:arya/features/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';

class UserInfoSection extends StatelessWidget {
  final UserModel user;
  const UserInfoSection({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Keep extension warmed for subtree if needed later
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: ProjectRadius.xxLarge,
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (Theme.of(context).brightness == Brightness.light)
                ? Colors.black12
                : scheme.shadow.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: ProjectPadding.allLarge(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            context,
            'profile.labels.name'.tr(),
            user.name ?? 'general.not_specified'.tr(),
          ),
          _divider(context),
          _buildInfoRow(
            context,
            'profile.labels.surname'.tr(),
            user.surname ?? 'general.not_specified'.tr(),
          ),
          _divider(context),
          _buildInfoRow(
            context,
            'profile.labels.email'.tr(),
            user.email ?? 'general.not_specified'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();
    return Padding(
      padding: ProjectPadding.verticalMedium,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: appColors?.textStrong ?? scheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Divider(
      height: 0,
      thickness: 1,
      color: scheme.outlineVariant.withValues(alpha: 0.2),
    );
  }
}
