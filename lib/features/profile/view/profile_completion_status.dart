import 'package:arya/product/theme/app_colors.dart';
import 'package:arya/features/profile/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileCompletionStatus extends StatelessWidget {
  const ProfileCompletionStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    final isComplete = viewModel.isUserComplete;
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          Icon(
            isComplete ? Icons.check_circle : Icons.info,
            color: appColors?.textMuted ?? scheme.primary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              isComplete
                  ? 'Profil bilgileriniz tamamlanmış.'
                  : 'Profil bilgilerinizi tamamlamanız önerilir.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: appColors?.textStrong ?? scheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
