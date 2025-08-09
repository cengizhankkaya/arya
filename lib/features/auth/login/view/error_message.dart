import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ProjectPadding.allVerySmall(),
      margin: ProjectMargin.topMedium,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: ProjectRadius.medium,
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Text(
        message,
        style: TextStyle(color: const Color.fromARGB(255, 74, 14, 169)),
        textAlign: TextAlign.center,
      ),
    );
  }
}
