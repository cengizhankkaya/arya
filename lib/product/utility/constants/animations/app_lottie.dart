import 'package:arya/product/utility/constants/animations/lottie_loader.dart';
import 'package:arya/product/utility/constants/animations/lottie_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppLottie extends StatelessWidget {
  const AppLottie({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LottieViewModel>(
      builder: (context, vm, _) {
        if (!vm.visible) return const SizedBox.shrink();
        return LottieLoader(path: vm.path, repeat: vm.repeat);
      },
    );
  }
}
