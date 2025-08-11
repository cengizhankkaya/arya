import 'package:arya/product/utility/constants/dimensions/project_padding.dart';
import 'package:flutter/material.dart';
import 'package:arya/product/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final dynamic user; // Replace `dynamic` with your actual `User` model

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();
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
      padding: const ProjectPadding.allMedium(),
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: appColors?.textMuted ?? scheme.primary,
              child: Text(
                user.displayName.isNotEmpty
                    ? user.displayName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.displayName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: appColors?.textStrong ?? scheme.onSurface,
              ),
            ),
            if (user.email != null) ...[
              const SizedBox(height: 8),
              Text(
                user.email!,
                style: TextStyle(fontSize: 16, color: scheme.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
