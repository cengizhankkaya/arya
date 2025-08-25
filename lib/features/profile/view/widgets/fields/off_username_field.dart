import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/index.dart';

class OffUsernameField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const OffUsernameField({super.key, required this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: ProjectRadius.large,
        boxShadow: [
          BoxShadow(
            color: AppColors.of(context).black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'off.username'.tr(),
          hintText: 'off.username_hint'.tr(),
          prefixIcon: const Icon(Icons.person_outline),
          border: OutlineInputBorder(
            borderRadius: ProjectRadius.large,
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: ProjectPadding.symmetricNormal,
        ),
        validator: validator,
      ),
    );
  }
}
