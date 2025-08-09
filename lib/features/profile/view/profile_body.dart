import 'package:arya/features/profile/view_model/profile_view_model.dart';
import 'package:arya/features/profile/view/profile_completion_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_profile_form.dart';
import 'profile_header.dart';
import 'user_info_section.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  viewModel.errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red[700]),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: viewModel.fetchUser,
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ),
          );
        }

        if (!viewModel.hasUser) {
          return const Center(child: Text("Kullanıcı verisi bulunamadı."));
        }

        final user = viewModel.user!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(user: user),
              const SizedBox(height: 32),
              viewModel.isEditing
                  ? const EditProfileForm()
                  : UserInfoSection(user: user),
              const SizedBox(height: 24),
              const ProfileCompletionStatus(),
            ],
          ),
        );
      },
    );
  }
}
