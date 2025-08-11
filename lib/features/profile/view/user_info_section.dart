import 'package:flutter/material.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:arya/features/auth/model/user_model.dart';

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
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: (Theme.of(context).brightness == Brightness.light)
                ? Colors.black12
                : scheme.shadow.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(context, 'Ad', user.name ?? 'Belirtilmemiş'),
          _buildInfoRow(context, 'Soyad', user.surname ?? 'Belirtilmemiş'),
          _buildInfoRow(
            context,
            'Kullanıcı Adı',
            user.username ?? 'Belirtilmemiş',
          ),
          _buildInfoRow(context, 'E-posta', user.email ?? 'Belirtilmemiş'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: appColors?.textStrong ?? scheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: scheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
