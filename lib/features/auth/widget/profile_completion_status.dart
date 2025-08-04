import 'package:arya/features/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileCompletionStatus extends StatelessWidget {
  const ProfileCompletionStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    final isComplete = viewModel.isUserComplete;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isComplete ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isComplete ? Colors.green : Colors.orange),
      ),
      child: Row(
        children: [
          Icon(
            isComplete ? Icons.check_circle : Icons.info,
            color: isComplete ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isComplete
                  ? 'Profil bilgileriniz tamamlanmış.'
                  : 'Profil bilgilerinizi tamamlamanız önerilir.',
              style: TextStyle(
                color: isComplete ? Colors.green[700] : Colors.orange[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
