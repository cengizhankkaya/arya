import 'package:arya/features/index.dart';
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
        border: Border.all(color: scheme.outline.withOpacity(0.08), width: 1),
        boxShadow: [
          BoxShadow(
            color: (Theme.of(context).brightness == Brightness.light)
                ? Colors.black12
                : scheme.shadow.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: ProjectPadding.allLarge(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(context, 'Ad', user.name ?? 'Belirtilmemiş'),
          _divider(context),
          _buildInfoRow(context, 'Soyad', user.surname ?? 'Belirtilmemiş'),
          _divider(context),
          _buildInfoRow(context, 'E-posta', user.email ?? 'Belirtilmemiş'),
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
      color: scheme.outlineVariant.withOpacity(0.2),
    );
  }
}
