import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: ProjectPadding.allVerySmall(),
      margin: ProjectMargin.topMedium,
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: ProjectRadius.medium,
        border: Border.all(color: scheme.error),
      ),
      child: Text(
        message,
        style: TextStyle(color: scheme.onErrorContainer),
        textAlign: TextAlign.center,
      ),
    );
  }
}
