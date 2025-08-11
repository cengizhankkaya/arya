import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailField extends StatelessWidget {
  const EmailField({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    return TextFormField(
      controller: viewModel.emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: AuthConstants.emailHint,
        hintText: 'ornek@email.com',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: ProjectRadius.large),
      ),
      validator: viewModel.validateEmail,
      textInputAction: TextInputAction.next,
    );
  }
}
