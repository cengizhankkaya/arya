import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final dynamic user; // Replace `dynamic` with your actual `User` model
  const ProfileHeader({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: appColors.lightGreen,
        borderRadius: ProjectRadius.xxLarge,
        boxShadow: [
          BoxShadow(
            color: appColors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: ProjectPadding.symmetricSmall,
      child: Row(
        children: [
          Stack(
            children: [
              // Ana avatar - beyaz arka plan, yeşil harf
              CircleAvatar(
                radius: 44,
                backgroundColor: appColors.white,
                child: Text(
                  user.displayName.isNotEmpty
                      ? user.displayName[0].toUpperCase()
                      : '?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: appColors.primaryGreen,
                    fontWeight: AppTypography.displayWeight,
                  ),
                ),
              ),
              // Sağ alt köşedeki küçük yeşil edit ikonu
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: ProjectPadding.allSmall(),
                  decoration: BoxDecoration(
                    color: appColors.primaryGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: appColors.white, width: 2),
                  ),
                  child: Icon(Icons.person, size: 10, color: appColors.white),
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
                    fontWeight: AppTypography.displayWeight,
                    color: appColors.black,
                  ),
                ),
                if (user.email != null) ...[
                  const SizedBox(height: 8),
                  // Email için özel tasarım - açık yeşil arka plan, beyaz ikon
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: appColors.lightGreen,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: appColors.primaryGreen.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.email, size: 16, color: scheme.onSurface),
                        const SizedBox(width: 8),
                        Text(
                          user.email!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: scheme.onSurface,
                                fontWeight: AppTypography.bodyLargeWeight,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
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
