import 'package:arya/features/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arya/product/index.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const ProfileShimmerWidget();
        }

        if (viewModel.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                ProjectSizedBox.heightMedium,
                Text(
                  viewModel.errorMessage!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                ProjectSizedBox.heightMedium,
                ElevatedButton(
                  onPressed: viewModel.fetchUser,
                  child: Text(
                    'general.button.retry'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        }
        if (!viewModel.hasUser) {
          return Center(child: Text('profile.no_user_data'.tr()));
        }
        final user = viewModel.user!;
        return Container(
          color: Theme.of(context).colorScheme.surface,
          child: SingleChildScrollView(
            padding: ProjectPadding.symmetricSmall,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileHeader(user: user),
                    // Profil bilgileri ile logout butonu arasında boşluk
                    ProjectSizedBox.heightLarge,
                    viewModel.isEditing
                        ? const EditProfileForm()
                        : UserInfoSection(user: user),
                    if (!viewModel.isUserComplete) ...[
                      ProjectSizedBox.heightMedium,
                      const ProfileCompletionStatus(),
                    ],
                  ],
                ),
                ProjectSizedBox.heightLarge,
                ElevatedButton(
                  onPressed: () async {
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('dialogs.logout.title'.tr()),
                        content: Text('dialogs.logout.content'.tr()),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('general.button.cancel'.tr()),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('general.button.ok'.tr()),
                          ),
                        ],
                      ),
                    );

                    if (shouldLogout == true) {
                      viewModel.signOut();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(
                    'general.button.logout'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
