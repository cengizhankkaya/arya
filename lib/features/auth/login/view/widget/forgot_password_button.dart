import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          AuthConstants.forgotPasswordText,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: AppTypography.labelWeight,
          ),
        ),
      ),
    );
  }
}
