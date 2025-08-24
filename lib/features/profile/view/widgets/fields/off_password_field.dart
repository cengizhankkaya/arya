import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/index.dart';

class OffPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const OffPasswordField({super.key, required this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'off.password'.tr(),
          hintText: 'off.password_hint'.tr(),
          prefixIcon: const Icon(Icons.lock_outline),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        obscureText: true,
        validator: validator,
      ),
    );
  }
}
