import 'package:flutter/material.dart';

/// E-posta adresini akıllıca gösteren widget
/// Uzun e-posta adreslerinde taşmayı önler ve kullanıcı dostu görünüm sağlar
class EmailDisplayWidget extends StatelessWidget {
  final String email;
  final TextStyle? style;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;

  const EmailDisplayWidget({
    super.key,
    required this.email,
    this.style,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.padding,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    // E-posta adresini parçalara ayır
    final parts = _splitEmail(email);

    return Container(
      padding: padding,
      decoration: decoration,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: iconSize ?? 16,
              color: iconColor ?? Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: RichText(
              text: TextSpan(
                style: style ?? Theme.of(context).textTheme.bodyMedium,
                children: [
                  // Kullanıcı adı kısmı
                  TextSpan(
                    text: parts['username'],
                    style: (style ?? Theme.of(context).textTheme.bodyMedium)
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  // @ işareti
                  TextSpan(text: '@'),
                  // Domain kısmı
                  TextSpan(
                    text: parts['domain'],
                    style: (style ?? Theme.of(context).textTheme.bodyMedium)
                        ?.copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  /// E-posta adresini kullanıcı adı ve domain olarak parçalar
  Map<String, String> _splitEmail(String email) {
    final atIndex = email.indexOf('@');
    if (atIndex == -1) {
      return {'username': email, 'domain': ''};
    }

    final username = email.substring(0, atIndex);
    final domain = email.substring(atIndex + 1);

    return {'username': username, 'domain': domain};
  }
}
