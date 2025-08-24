import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';

/// Kullanıcı profil bilgilerini gösteren header widget'ı
/// Bu widget, kullanıcının avatar'ını, adını ve email bilgilerini içerir
class ProfileHeader extends StatelessWidget {
  /// Kullanıcı bilgileri (User modeli ile değiştirilmeli)
  final dynamic user; // Replace `dynamic` with your actual `User` model
  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Tema renk şemasını al
    final scheme = Theme.of(context).colorScheme;
    // Uygulama özel renklerini al
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      // Ana container dekorasyonu - yeşil arka plan, yuvarlatılmış köşeler ve gölge
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
          // Avatar ve edit ikonu stack'i
          Stack(
            children: [
              // Ana avatar - beyaz arka plan, yeşil harf
              CircleAvatar(
                radius: 44,
                backgroundColor: scheme.onSurface,
                child: Text(
                  // Kullanıcı adının ilk harfini büyük harf olarak göster
                  user.displayName.isNotEmpty
                      ? user.displayName[0].toUpperCase()
                      : '?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: appColors.primaryGreen,
                    fontWeight: AppTypography.displayWeight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Kullanıcı bilgileri sütunu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kullanıcı adı
                Text(
                  user.displayName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: AppTypography.displayWeight,
                    color: appColors.black,
                  ),
                ),
                // Email bilgisi varsa göster
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
                        // Email ikonu
                        Icon(Icons.email, size: 16, color: scheme.onSurface),
                        const SizedBox(width: 8),
                        // Email metni
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
