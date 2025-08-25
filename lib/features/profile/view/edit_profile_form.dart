import 'package:arya/features/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arya/product/index.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: ProjectRadius.big,
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      padding: ProjectPadding.allSmall(),
      child: Column(
        children: [
          TextField(
            controller: viewModel.nameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'profile.labels.name'.tr(),
              prefixIcon: const Icon(Icons.badge_outlined),
            ),
          ),
          ProjectSizedBox.heightNormal,
          TextField(
            controller: viewModel.surnameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'profile.labels.surname'.tr(),
              prefixIcon: const Icon(Icons.badge),
            ),
          ),
          ProjectSizedBox.heightNormal,
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => viewModel.toggleEditMode(),
                  icon: const Icon(Icons.close),
                  label: Text('general.button.cancel'.tr()),
                ),
              ),
              ProjectSizedBox.widthNormal,
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => viewModel.updateUserFromControllers(),
                  icon: const Icon(Icons.save_rounded),
                  label: Text('general.button.save'.tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
