import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;

  const SectionTitle({
    Key? key,
    required this.title,
    this.fontSize = 18,
    this.fontWeight = FontWeight.bold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontWeight: fontWeight, fontSize: fontSize),
    );
  }
}
