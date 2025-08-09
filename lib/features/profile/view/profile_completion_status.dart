import 'package:arya/features/index.dart';
import 'package:arya/features/profile/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileCompletionStatus extends StatelessWidget {
  const ProfileCompletionStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    final isComplete = viewModel.isUserComplete;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            isComplete ? Icons.check_circle : Icons.info,
            color: isComplete
                ? const Color(0xFF7C7C7C)
                : const Color(0xFF7C7C7C),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              isComplete
                  ? 'Profil bilgileriniz tamamlanmış.'
                  : 'Profil bilgilerinizi tamamlamanız önerilir.',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
