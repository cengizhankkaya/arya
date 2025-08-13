import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';

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
        borderRadius: ProjectRadius.xxLarge,
        boxShadow: [
          BoxShadow(
            color: (Theme.of(context).brightness == Brightness.light)
                ? Colors.black12
                : scheme.shadow.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: scheme.outline.withOpacity(0.08), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor:
                    appColors?.textMuted.withOpacity(0.15) ??
                    scheme.primary.withOpacity(0.15),
                child: Text(
                  user.displayName.isNotEmpty
                      ? user.displayName[0].toUpperCase()
                      : '?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: scheme.surface, width: 2),
                  ),
                  child: Icon(Icons.person, size: 16, color: scheme.onPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: appColors?.textStrong ?? scheme.onSurface,
                  ),
                ),
                if (user.email != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    user.email!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
