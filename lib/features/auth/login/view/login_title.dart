import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginTitle extends StatelessWidget {
  const LoginTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LottieLoader(path: LottiePaths.onLogin, width: 120, height: 120),
        Text(
          'auth.welcome'.tr(),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: AppTypography.boldWeight,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        ProjectSizedBox.heightSmall, // 8px boşluk
        Text(
          'auth.login_instructions'.tr(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
