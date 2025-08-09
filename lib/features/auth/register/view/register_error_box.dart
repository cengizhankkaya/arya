import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';

class RegisterErrorBox extends StatelessWidget {
  final String message;

  const RegisterErrorBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ProjectPadding.allVerySmall(),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: ProjectRadius.medium,
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.red.shade700),
        textAlign: TextAlign.center,
      ),
    );
  }
}
