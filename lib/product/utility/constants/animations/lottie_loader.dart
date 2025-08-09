import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieLoader extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final bool repeat;

  const LottieLoader({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.repeat = true,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(path, width: width, height: height, repeat: repeat);
  }
}
